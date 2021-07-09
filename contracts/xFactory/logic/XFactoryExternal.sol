// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./XFactoryInternal.sol";
import "../../utils/SafeERC20.sol";

/**
  * @title BiFi-X XFactoryExternal contract
  * @notice Implement entry point for XFactory contract
  * @author BiFi-X(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
  */
contract XFactoryExternal is XFactoryInternal {
  using SafeERC20 for IERC20;

  event Create(
    uint256 strategyID, // The ID to identify strategy logic contracts
    uint256 productID, // The NFT ID of Product. When checking the owner of the NFT, this ID will be used.
    address positionAddr, // The Address of Product.
    address userAddr // The Address of the user who created the product.
  );

  event PayFee(
    address userAddr, // The Address of the user who created the product.
    uint256 feeAmount // The amount of BIFI token you pay to create a product
  );

  event WithdrawFee(
    address receiver, // The Address of the receiver.
    uint256 feeAmount // The amount of BIFI token to be withdrawn.
  );

  /**
	* @dev Create product and store user's product data in storage
	* @param strategyID The ID of product strategy
  * @param strategyParams The encode parameter of strategy
	* @return Whether or not create succeed
	*/
  function create(uint256 strategyID, bytes memory strategyParams) external payable returns (bool) {
    address userAddr = msg.sender;

    // pay use BiFi-X
    IERC20 bifi = IERC20(bifiAddr);
    uint256 feeAmount = _payFee(userAddr);
    bifi.safeTransferFrom(userAddr, address(this), feeAmount);
    _createProduct(strategyID, userAddr, strategyParams);

    emit PayFee(userAddr, feeAmount);
    return true;
  }

   /**
	* @dev Create product and mint NFT
	* @param strategyID The ID of product strategy
	* @param sender The address of product creator and own nft
  * @param strategyParams The encoded parameter of strategy
	* @return Whether or not create succeed
	*/
  function _createProduct(uint256 strategyID, address sender, bytes memory strategyParams) internal returns (address, uint256) {
    StrategyParams memory vars;

    // TODO more abstraction
    // decode strategyParams
    (vars.tokenAddr,
    vars.handlersAddress,
    vars.handlerIDs,
    // 0: flashloan fee, 1: swap fee
    vars.fees,
    // 0: collateral amount, 1: lending amount, 2:flashloan amount
    vars.amounts,
    vars.decimal) = abi.decode(strategyParams, (address[], address[], uint256[], uint256[], uint256[], uint256[]));

    IERC721 nft = IERC721(NFT);
    uint256 productID = nft.totalSupply();

    // create new user's product contract include registered logic
    address payable productAddr = address(new ProductProxy(strategyID, address(NFT), address(this), productID));

    // mint NFT token for user's product owner access control
    nft.mint(sender, productID);

    // store product information in storage contract
    IPositionStorage positionStorage = IPositionStorage(storageAddr);

    positionStorage.newUserProduct(sender, productAddr);
    positionStorage.setProductToNFTID(productAddr, productID);

    // send collateral asset for start strategy
    if(msg.value == 0){
      IERC20(vars.tokenAddr[0]).safeTransferFrom(
        sender,
        productAddr,
        _convertUnifiedToUnderlying(vars.amounts[0].add(vars.fees[0]).add(vars.fees[1]), vars.decimal[0])
      );

      IStrategy(productAddr).startStrategy(strategyParams);
    } else {
      require(msg.value == vars.amounts[0].add(vars.fees[0]).add(vars.fees[1]), "FE001");
      IStrategy(productAddr).startStrategy{value: msg.value}(strategyParams);
    }

    emit Create(strategyID, productID, productAddr, msg.sender);
    return (productAddr, productID);
  }

  function payFee(address user) external view returns (uint256) {
    return _payFee(user);
  }

  function _payFee(address user) internal view returns (uint256) {
    uint256 amount = fee;

    IERC20 bifi = IERC20(bifiAddr);

    uint256 bifiBalance = bifi.balanceOf(user);

    // discount model
    if (bifiBalance > fee) {
      bifiBalance = bifiBalance.sub(fee);
      // (static bifi amount) * (0.1 + 0.9 * min(1.0, (BASE * 10^18) / bifiBalance))
      uint256 unifiedPoint = 10 ** 18;
      uint256 minimum = 10 ** 17;
      uint256 slope = unifiedPoint - minimum;
      uint256 discountRate = _min(unifiedPoint, discountBase.unifiedDiv(bifiBalance));

      amount = amount.unifiedMul(
        minimum.add(slope.unifiedMul(discountRate))
      );
    }

    return amount;
  }

  function _min(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a >= b) { return b; }
    return a;
  }

  function setStrategy(uint256 strategyID, address strategyAddr) external onlyOwner returns (bool) {
    IPositionStorage(storageAddr).setStrategy(strategyID, strategyAddr);
    return true;
  }

  function getStrategy(uint256 strategyID) external view returns (address) {
    return IPositionStorage(storageAddr).getStrategy(strategyID);
  }

  function setBifiAddr(address _bifiAddr) external onlyOwner returns (bool) {
    bifiAddr = _bifiAddr;
    return true;
  }

  function getBifiAddr() external view returns (address) {
    return bifiAddr;
  }

  function setWethAddr(address _wethAddr) external onlyOwner returns (bool) {
    wethAddr = _wethAddr;
    return true;
  }

  function setOwner(address owner) external onlyOwner returns (bool) {
    _setOwner(owner);
  }

  function setImplements(address implementsAddr) external onlyOwner returns (bool) {
    return _setImplements(implementsAddr);
  }

  function setStorageAddr(address storageAddr) external onlyOwner returns (bool) {
    return _setStorageAddr(storageAddr);
  }

  function getWETHAddr() external view returns (address) {
    return wethAddr;
  }

  function setManagerAddr(address _bifiManagerAddr) external onlyOwner returns (bool) {
    _setManagerAddr(_bifiManagerAddr);
    return true;
  }

  function setUniswapV2Addr(address _uniswapV2Addr) external onlyOwner returns (bool) {
    _setUniswapV2Addr(_uniswapV2Addr);
    return true;
  }

  function setNFT(address payable nftAddr) external onlyOwner returns (bool) {
    _setNFT(nftAddr);
    return true;
  }

  function setFee(uint256 _fee) external onlyOwner returns (bool) {
    _setFee(_fee);
    return true;
  }

  function setDiscountBase(uint256 _discountBase) external onlyOwner returns (bool) {
    _setDiscountBase(_discountBase);
    return true;
  }

  function getManagerAddr() external view returns (address) {
    return bifiManagerAddr;
  }

  function getUniswapAddr() external view returns (address) {
    return uniswapV2Addr;
  }

  function getNFT() external view returns (address) {
    return NFT;
  }

  function withdrawFee(address owner, uint256 amount) external onlyOwner returns (bool){
    // pay use BiFi-X
    IERC20 bifi = IERC20(bifiAddr);
    bifi.safeTransfer(owner, amount);
    emit WithdrawFee(owner, amount);
    return true;
  }
}
