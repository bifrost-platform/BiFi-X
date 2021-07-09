// SPDX-License-Identifier: BSD-3-Clause

pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "../interfaces/bifi/IManagerDataStorage.sol";
import "../interfaces/bifi/IMarketManager.sol";
import "../interfaces/bifi/IMarketHandler.sol";
import "../interfaces/bifi/ICallProxy.sol";
import "../interfaces/IPositionStorage.sol";
import "../interfaces/uniswap/IUniswapV2Router02.sol";
import "../interfaces/IStrategy.sol";
import "../interfaces/IFactory.sol";
import "../utils/SafeMath.sol";

/**
 * @title BiFi-X's call proxy Contract
 * @author BiFi-X(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
 */
contract CallProxy {
  using SafeMath for uint256;

  IMarketManager public manager;
  IPositionStorage public positionStorage;
  IFactory public factory;
  ICallProxy public bifiCallProxy;

  address owner;
  uint256 unifiedPoint = 10 ** 18;

  // uniswapFee: 0.3%
  uint256 public uniswapFeePercent = 0.003 ether;
  uint256[] stableCoin = [1,2,4];
  uint256[] generalCoin = [0,3];

  uint256 constant ETH_ID = 0;

  struct TokenInfo {
    address tokenAddr;
    uint64 decimal;
  }

  mapping(uint256 => TokenInfo) public tokenInfo;

  struct StartPosition {
    uint256 depositAPY;
    uint256 borrowAPY;
    uint256 collateralAmount;
    uint256 expectedDepositAmount;
    uint256 expectedBorrowAmount;
    uint256 srcPrice;
    uint256 dstPrice;
    uint256 netLTV;
    uint256 flashloanFee;
    uint256 uniswapFee;
    uint256 flashloanFeePercent;
    uint256 uniswapFeePercent;
    uint256 bifiFee;
  }

  struct EndPosition {
    uint256 srcHandlerID;
    uint256 dstHandlerID;
    uint256 srcPrice;
    uint256 dstPrice;
    uint256 depositAmount;
    uint256 borrowAmount;
    uint256 depositAmountWithInterest;
    uint256 borrowAmountWithInterest;
    uint256 amountsInMax;
    uint256 flashloanFee;
    uint256 flashloanFeePercent;
    uint256 uniswapFee;
    uint256 uniswapFeePercent;
    uint256 bifiReward;
  }

  enum PositionInfo { Earn, Long, Short }

  struct PositionStatus {
    PositionInfo positionState;
    address positionAddress;
    uint256 scope;
    uint256 srcHandlerID;
    uint256 dstHandlerID;

    // when position was created, asset and price information
    uint256 depositAsset;
    uint256 srcAsset; // This is seedAsset (The asset of collateral)
    uint256 dstAsset; // This is borrowAsset (The asset of borrow)
    uint256 srcPrice; // This is seedPrice (The price of collateral)
    uint256 dstPrice; // This is borrowPrice (The price of borrow)

    // currnet position's price
    uint256 srcCurrentPrice;
    uint256 dstCurrentPrice;
    uint256 ltv;
    uint256 appraisedAsset; // This is current position's asset
    uint256 depositAmount;
    uint256 borrowAmount;
    uint256 depositInterestAmount;
    uint256 borrowInterestAmount;
    uint256 bifiReward;
  }

  struct UserReward {
    uint256 rewardLane;
    uint256 rewardLaneUpdateAt;
    uint256 rewardAmount;
  }

  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }

  constructor(address managerAddr, address positionStorageAddr, address factoryAddr, address bifiCallProxyAddr) public {
    owner = msg.sender;

    manager = IMarketManager(managerAddr);
    positionStorage = IPositionStorage(positionStorageAddr);
    factory = IFactory(factoryAddr);
    bifiCallProxy = ICallProxy(bifiCallProxyAddr);
  }

  function setManager(address managerAddr) external onlyOwner {
    manager = IMarketManager(managerAddr);
  }

  function setPositionStorage(address positionStorageAddr) external onlyOwner {
    positionStorage = IPositionStorage(positionStorageAddr);
  }

  function setUniswapFeePercent(uint256 feePercent) external onlyOwner {
    uniswapFeePercent = feePercent;
  }

  function setTokenInfo(uint256 handlerID, address tokenAddr, uint64 decimal) external onlyOwner {
    tokenInfo[handlerID] = TokenInfo(tokenAddr, decimal);
  }

  function setTokenInfos(uint256[] memory handlerID, address[] memory tokenAddr, uint64[] memory decimal) external onlyOwner {
    for (uint256 i = 0; i < handlerID.length; i++) {
      tokenInfo[handlerID[i]] = TokenInfo(tokenAddr[i], decimal[i]);
    }
  }

  function getTokenInfo(uint256 handlerID) external view returns (TokenInfo memory) {
    return tokenInfo[handlerID];
  }

  // Get information of position
  function getStartPosition(uint256 srcHandlerID, uint256 dstHandlerID, uint256 collateralAmount, uint256 times, uint256 feePercent, address userAddr, uint256 bifiAmount) external view returns (StartPosition memory) {
    StartPosition memory position;
    (position.depositAPY, ) = _getSIRandBIR(srcHandlerID);
    (, position.borrowAPY) = _getSIRandBIR(dstHandlerID);

    feePercent = feePercent.unifiedMul(times);
    // fee = flashloanAmount * fee Pecent
    uint256 fee = collateralAmount.unifiedMul(times.sub(unifiedPoint)).unifiedMul(feePercent);
    collateralAmount = collateralAmount.sub(fee);

    position.expectedDepositAmount = collateralAmount.unifiedMul(times);
    uint256 flashloanAmount = position.expectedDepositAmount.sub(collateralAmount);
    position.expectedBorrowAmount = position.expectedDepositAmount.sub(collateralAmount);

    position.bifiFee = factory.payFee(userAddr);

    // it is weird, but no revert
    if (bifiAmount > position.bifiFee) {
      bifiAmount = bifiAmount.sub(position.bifiFee);
    }

    position.flashloanFee = _getFlashFee(srcHandlerID, flashloanAmount, bifiAmount);
    // send enough flashloanFee 0.001% more
    position.flashloanFee = position.flashloanFee.add(position.flashloanFee.unifiedMul(10 ** 15));
    position.flashloanFeePercent = _getFlashFeePercent(srcHandlerID);


    position.netLTV = position.expectedBorrowAmount.unifiedDiv(position.expectedDepositAmount);

    position.srcPrice = manager.getTokenHandlerPrice(srcHandlerID);
    position.dstPrice = manager.getTokenHandlerPrice(dstHandlerID);
    // uniswapFeePercent == 0.3%
    position.uniswapFeePercent = uniswapFeePercent;

    if (srcHandlerID != dstHandlerID) {
      position.uniswapFee = flashloanAmount
        .unifiedMul(position.uniswapFeePercent + 0.003 ether);

      // swap twice, pool is not enough
      if (srcHandlerID != ETH_ID && dstHandlerID != ETH_ID) {
        position.uniswapFee = position.uniswapFee.mul(2);
        position.uniswapFeePercent = position.uniswapFeePercent.mul(2);
      }
    }

    position.uniswapFee = position.uniswapFee + fee;

    position.collateralAmount = collateralAmount.sub(position.uniswapFee).sub(position.flashloanFee);
    position.expectedDepositAmount = position.collateralAmount.unifiedMul(times);
    position.expectedBorrowAmount = position.expectedDepositAmount.sub(position.collateralAmount);


    if (srcHandlerID != dstHandlerID) {
      position.expectedBorrowAmount = position.expectedBorrowAmount
      .unifiedMul(manager.getTokenHandlerPrice(srcHandlerID))
      .unifiedDiv(manager.getTokenHandlerPrice(dstHandlerID));
    }

    return position;
  }

  function getAllPositionStatus(address userAddr) external view returns (PositionStatus[] memory) {
    uint256 positionIndex;

    address[] memory products = positionStorage.getUserProducts(userAddr);
    PositionStatus[] memory positionPackage = new PositionStatus[](products.length);
    for (uint256 i = 0; i < products.length; i++) {
      if (_isContract(products[i])) {
        positionPackage[positionIndex] = _getPositionStatus(products[i]);
        positionIndex++;
      }
    }

    PositionStatus[] memory trimmedResult = new PositionStatus[](positionIndex);
    for (uint j = 0; j < trimmedResult.length; j++) {
      trimmedResult[j] = positionPackage[j];
    }

    return trimmedResult;
  }

  function getFee(address userAddr) external view returns (uint256) {
    return factory.payFee(userAddr);
  }

  function _getPositionStatus(address positionAddr) internal view returns (PositionStatus memory) {
    IStrategy strategy = IStrategy(positionAddr);
    PositionStatus memory positionStatus;

    positionStatus.positionAddress = positionAddr;
    (positionStatus.srcHandlerID, positionStatus.dstHandlerID) =  _getPositionLendingID(positionAddr);
    (positionStatus.depositAmount,) = _getUserAmount(positionStatus.srcHandlerID, positionAddr);
    (,positionStatus.borrowAmount) = _getUserAmount(positionStatus.dstHandlerID, positionAddr);

    (positionStatus.depositInterestAmount,) = _getUserAmountWithInterest(positionStatus.srcHandlerID, positionAddr);
    (,positionStatus.borrowInterestAmount) = _getUserAmountWithInterest(positionStatus.dstHandlerID, positionAddr);

    positionStatus.srcCurrentPrice = manager.getTokenHandlerPrice(positionStatus.srcHandlerID);
    positionStatus.dstCurrentPrice = manager.getTokenHandlerPrice(positionStatus.dstHandlerID);

    uint256 borrowInterestAsset = positionStatus.borrowInterestAmount.unifiedMul(positionStatus.dstCurrentPrice);
    uint256 depositInterestAsset = positionStatus.depositInterestAmount.unifiedMul(positionStatus.srcCurrentPrice);

    positionStatus.ltv = borrowInterestAsset.unifiedDiv(depositInterestAsset);

    positionStatus.depositAsset = strategy.getDepositAsset();

    positionStatus.srcAsset = strategy.getSrcAsset();
    positionStatus.srcPrice = strategy.getSrcPrice();

    positionStatus.dstAsset = strategy.getDstAsset();
    positionStatus.dstPrice = strategy.getDstPrice();

    if (positionStatus.srcAsset != 0) {
      positionStatus.scope = positionStatus.depositAmount.unifiedMul(positionStatus.srcPrice).unifiedDiv(positionStatus.srcAsset);
    }
    positionStatus.appraisedAsset = positionStatus.depositInterestAmount.unifiedMul(positionStatus.srcPrice).sub(positionStatus.borrowInterestAmount.unifiedMul(positionStatus.dstPrice));

    (,,,positionStatus.bifiReward) = bifiCallProxy.callProxySI_getSI(payable(positionAddr));
    positionStatus.positionState = _getPositionName(positionStatus.srcHandlerID, positionStatus.dstHandlerID);

    return positionStatus;
  }

  function getEndPosition(address positionAddr, uint256 slippage, uint256 bifiAmount) external view returns (EndPosition memory) {
    EndPosition memory endPosition;
    endPosition = _getPositionLendingInfo(positionAddr);

    if (endPosition.dstHandlerID == 100) {
      return endPosition;
    }

    endPosition.flashloanFeePercent = _getFlashFeePercent(endPosition.dstHandlerID);
    endPosition.flashloanFee = _getFlashFee(endPosition.dstHandlerID, endPosition.borrowAmountWithInterest, bifiAmount);

    // uniswapFeePercent == 0.3%
    if (endPosition.srcHandlerID != endPosition.dstHandlerID) {
      // uint256 srcTokenPrice = manager.getTokenHandlerPrice(endPosition.srcHandlerID);
      // uint256 dstTokenPrice = manager.getTokenHandlerPrice(endPosition.dstHandlerID);

      // original collateralOut
      // collateralOut은 갚을 대상이므로 endPosition.borrowAmountWithInterest
      // endPosition.borrowAmountWithInterest
      uint amountsOut = endPosition.borrowAmountWithInterest.add(endPosition.flashloanFee);
      endPosition.amountsInMax = _getAmountsIn(amountsOut, [endPosition.srcHandlerID, endPosition.dstHandlerID]);

      // apply slippage
      // amountsInMax / 100 * (100 - splipage)
      endPosition.amountsInMax = (endPosition.amountsInMax).unifiedMul(unifiedPoint.add(slippage));
      endPosition.uniswapFeePercent = uniswapFeePercent;

      endPosition.uniswapFee = endPosition.borrowAmountWithInterest.unifiedMul(endPosition.uniswapFeePercent);
      // swap twice, pool is not enough
      if (endPosition.srcHandlerID != ETH_ID && endPosition.dstHandlerID != ETH_ID) {
        endPosition.uniswapFee = endPosition.uniswapFee.mul(2);
        endPosition.uniswapFeePercent = endPosition.uniswapFeePercent.mul(2);
      }
    }
    endPosition.uniswapFee = endPosition.uniswapFee.mul(2);
    (,,,endPosition.bifiReward) = bifiCallProxy.callProxySI_getSI(payable(positionAddr));

    return endPosition;
  }

  function getClaimableBifi(address positionAddr) external view returns (uint256) {
    (,,,uint256 bifiReward) = bifiCallProxy.callProxySI_getSI(payable(positionAddr));
    return bifiReward;
  }

  function _getPositionLendingID(address positionAddr) internal view returns (uint256, uint256) {
    uint256 depositAmount;
    uint256 borrowAmount;
    uint256 srcHandlerID;
    uint256 dstHandlerID;
    uint256 tokenHandlerLength = manager.getTokenHandlersLength();

    for (uint256 i = 0; i < tokenHandlerLength; i++) {
      (depositAmount, borrowAmount) = _getUserAmount(i, positionAddr);
      if (depositAmount > 0) {
        srcHandlerID = i;
      }
      if (borrowAmount > 0) {
        dstHandlerID = i;
      }
    }
    return (srcHandlerID, dstHandlerID);
  }

  // TODO getPositionLending Info에서 EndPosition 구조체를 사용중 ?
  function _getPositionLendingInfo(address positionAddr) internal view returns (EndPosition memory) {
    EndPosition memory endPosition;

    uint256 depositAmount;
    uint256 borrowAmount;
    uint256 tokenHandlerLength = manager.getTokenHandlersLength();

    // if position don't exist, 100
    endPosition.srcHandlerID = 100;
    endPosition.dstHandlerID = 100;

    for (uint256 i = 0; i < tokenHandlerLength; i++) {
      (depositAmount, borrowAmount) = _getUserAmount(i, positionAddr);
      if (depositAmount > 0) {
        endPosition.srcHandlerID = i;
        endPosition.depositAmount = depositAmount;
        (endPosition.depositAmountWithInterest, ) = _getUserAmountWithInterest(i, positionAddr);
      }
      if (borrowAmount > 0) {
        endPosition.dstHandlerID = i;
        endPosition.borrowAmount = borrowAmount;
        ( ,endPosition.borrowAmountWithInterest) = _getUserAmountWithInterest(i, positionAddr);
      }
    }

    return endPosition;
  }

  function getCurrentLTV(address positionAddr) external view returns (uint256) {
    return _getCurrentLTV(positionAddr);
  }

  function getMaxBoost(uint256 handlerID) external view returns (uint256) {
    return _getMaxBoost(handlerID);
  }

  function getFlashFeePercent(uint256 handlerID) external view returns (uint256) {
    return _getFlashFeePercent(handlerID);
  }

  function getPositionName(uint256 srcHandlerID, uint256 dstHandlerID) external view returns (PositionInfo) {
      return _getPositionName(srcHandlerID, dstHandlerID);
  }

  function _getPositionName(uint256 srcHandlerID, uint256 dstHandlerID) internal view returns (PositionInfo) {
    if (srcHandlerID == dstHandlerID) {
      return PositionInfo.Earn;
    } else {
      if (_arrayChecker(srcHandlerID, stableCoin)) {
        return PositionInfo.Short;
      } else if (_arrayChecker(dstHandlerID, stableCoin)) {
        return PositionInfo.Long;
      }
    }
  }


  function _arrayChecker(uint256 id, uint256[] memory ids) internal pure returns (bool) {
    for (uint256 i = 0; i < ids.length; i++) {
      if (id == ids[i]) {
        return true;
      }
    }
    return false;
  }

  function _getCurrentLTV(address positionAddr) internal view returns (uint256) {
    EndPosition memory endPosition;
    endPosition = _getPositionLendingInfo(positionAddr);
    uint256 ltv;
    if (endPosition.srcHandlerID == 100) {
      ltv = 0;
    } else {
      ltv = endPosition.borrowAmountWithInterest.unifiedDiv(endPosition.depositAmountWithInterest);
    }

    return ltv;
  }

  function _getPositionRewardAll(address positionAddr) internal view returns (uint256) {
    uint256 totalAmount = 0;
    uint256 tokenHandlerLength = manager.getTokenHandlersLength();
    uint256[] memory rewardInfo = new uint256[](tokenHandlerLength);
    rewardInfo = _getPositionRewardInfo(positionAddr);
    for (uint256 i = 0; i < rewardInfo.length; i++) {
      totalAmount += rewardInfo[i];
    }
    return totalAmount;
  }

  function _getPositionRewardInfo(address positionAddr) internal view returns (uint256[] memory) {
    uint256 rewardAmount;
    uint256 tokenHandlerLength = manager.getTokenHandlersLength();
    uint256[] memory rewardInfo = new uint256[](tokenHandlerLength);
    for (uint256 i = 0; i < tokenHandlerLength; i++) {
      (,address handlerAddr,) = manager.getTokenHandlerInfo(i);
      IMarketHandler handler = IMarketHandler(handlerAddr);
      (,bytes memory data) = handler.siViewProxy(abi.encodeWithSelector(handler.getUserRewardInfo.selector, positionAddr));
      (, , rewardAmount) = abi.decode(data, (uint256, uint256, uint256));
      rewardInfo[i] = rewardAmount;
    }
    return rewardInfo;
  }

  function _getNetLTV(uint256 times) internal view returns (uint256) {
    uint256 netLTV = unifiedPoint.sub(unifiedPoint.unifiedDiv(times));
    return netLTV;
  }

  function _getFlashFee(uint256 handlerID, uint256 flashAmount, uint256 bifiAmount) internal view returns (uint256 fee) {
    fee = manager.getFeeFromArguments(handlerID, flashAmount, bifiAmount);
  }

  function _getFlashFeePercent(uint256 handlerID) internal view returns (uint256) {
    uint256 feePercent = manager.getFeePercent(handlerID);
    return feePercent;
  }

  function getUserAmount(uint256 handlerID, address positionAddr) external view returns (uint256, uint256) {
    return _getUserAmount(handlerID, positionAddr);
  }

  function getAmount(address payable dataStorage, address payable positionAddr) external view returns (uint256, uint256) {
    return IMarketHandler(dataStorage).getUserAmount(positionAddr);
  }

  function getAmountsOut(uint amountIn, uint256[2] memory tokenIds) external view returns (uint) {
    return _getAmountsOut(amountIn, tokenIds);
  }

  function getAmountsIn(uint amountsOut, uint256[2] memory tokenIds) external view returns (uint) {
    return _getAmountsIn(amountsOut, tokenIds);
  }

  function _getAmountsIn(uint amountsOut, uint256[2] memory tokenIds) internal view returns (uint) {
    IUniswapV2Router02 uniswap = IUniswapV2Router02(factory.getUniswapAddr());
    address wethAddr = factory.getWETHAddr();
    address[] memory path;
    uint256 swapCount = 3;
    if (tokenIds[0] == 0 || tokenIds[1] == 0) {
      swapCount = 2;
    }

    if (swapCount > 2) {
      path = new address[](3);
      path[0] = tokenInfo[tokenIds[0]].tokenAddr;
      path[1] = wethAddr;
      path[2] = tokenInfo[tokenIds[1]].tokenAddr;
    } else {
      path = new address[](2);
      path[0] = tokenInfo[tokenIds[0]].tokenAddr;
      path[1] = tokenInfo[tokenIds[1]].tokenAddr;
    }

    uint256 underlyingAmountsout = _convertUnifiedToUnderlying(amountsOut, tokenInfo[tokenIds[1]].decimal);

    uint amounts = uniswap.getAmountsIn(underlyingAmountsout, path)[0];
    return _convertUnderlyingToUnified(amounts, tokenInfo[tokenIds[0]].decimal);
  }

  function _getAmountsOut(uint amountIn, uint256[2] memory tokenIds) internal view returns (uint) {
    IUniswapV2Router02 uniswap = IUniswapV2Router02(factory.getUniswapAddr());
    address wethAddr = factory.getWETHAddr();
    address[] memory path;
    uint256 swapCount = 3;
    if (tokenIds[0] == 0 || tokenIds[1] == 0) {
      swapCount = 2;
    }

    if (swapCount > 2) {
      path = new address[](3);
      path[0] = tokenInfo[tokenIds[0]].tokenAddr;
      path[1] = wethAddr;
      path[2] = tokenInfo[tokenIds[1]].tokenAddr;
    } else {
      path = new address[](2);
      path[0] = tokenInfo[tokenIds[0]].tokenAddr;
      path[1] = tokenInfo[tokenIds[1]].tokenAddr;
    }

    uint256 underlyingAmountIn = _convertUnifiedToUnderlying(amountIn, tokenInfo[tokenIds[0]].decimal);

    uint amounts = uniswap.getAmountsOut(underlyingAmountIn, path)[path.length - 1];
    return _convertUnderlyingToUnified(amounts, tokenInfo[tokenIds[1]].decimal);
  }

  function _getUserAmount(uint256 handlerID, address positionAddr) internal view returns (uint256, uint256) {
    (,address handlerAddr,) = manager.getTokenHandlerInfo(handlerID);
    IMarketHandler handler = IMarketHandler(handlerAddr);
    (,bytes memory data)= handler.handlerViewProxy(
      abi.encodeWithSelector(handler.getUserAmount.selector, positionAddr)
    );
    return abi.decode(data, (uint256, uint256));
  }

  function _getUserAmountWithInterest(uint256 handlerID, address positionAddr) internal view returns (uint256, uint256) {
    (,address handlerAddr,) = manager.getTokenHandlerInfo(handlerID);
    IMarketHandler handler = IMarketHandler(handlerAddr);
    (,bytes memory data)= handler.handlerViewProxy(
      abi.encodeWithSelector(handler.getUserAmountWithInterest.selector, positionAddr)
    );
    return abi.decode(data, (uint256, uint256));
  }

  // Get BIR and SIR
  function _getSIRandBIR(uint256 handlerID) internal view returns (uint256, uint256) {
    (,address handlerAddr,) = manager.getTokenHandlerInfo(handlerID);
    IMarketHandler handler = IMarketHandler(handlerAddr);
    (,bytes memory data)= handler.handlerViewProxy(
      abi.encodeWithSelector(handler.getSIRandBIR.selector)
    );
    return abi.decode(data, (uint256, uint256));
  }

  function _getMaxBoost(uint256 handlerID) internal view returns (uint256) {
    (,address handlerAddr,) = manager.getTokenHandlerInfo(handlerID);
    IMarketHandler handler = IMarketHandler(handlerAddr);
    (,bytes memory data)= handler.handlerViewProxy(
      abi.encodeWithSelector(handler.getTokenHandlerBorrowLimit.selector)
    );

    uint256 borrowLimit = abi.decode(data, (uint256));
    return unifiedPoint.unifiedDiv(unifiedPoint.sub(borrowLimit));
  }

  /**
  * @dev Convert amount of handler's unified decimals to amount of token's underlying decimals
  * @param unifiedTokenAmount The amount of unified decimals
  * @return (underlyingTokenAmount)
  */
  function _convertUnifiedToUnderlying(uint256 unifiedTokenAmount, uint256 decimal) internal view returns (uint256) {
    return unifiedTokenAmount.mul(decimal) / unifiedPoint;
  }

  /**
  * @dev Convert amount of token's underlying decimals to amount of handler's unified decimals
  * @param underlyingTokenAmount The amount of underlying decimals
  * @return (unifiedTokenAmount)
  */
  function _convertUnderlyingToUnified(uint256 underlyingTokenAmount, uint256 decimal) internal view returns (uint256) {
    return underlyingTokenAmount.mul(unifiedPoint) / decimal;
  }

  function isContract(address _addr) public view returns (bool) {
    return _isContract(_addr);
  }

  function _isContract(address _addr) internal view returns (bool) {
    uint32 size;
    assembly {
      size := extcodesize(_addr)
    }
    return (size > 0);
  }
}
