// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./StrategySlot.sol";

import "../../../interfaces/bifi/IMarketManager.sol";
import "../../../interfaces/bifi/IFlashloanReceiver.sol";
import "../../../interfaces/bifi/IManagerFlashloan.sol";
import "../../../interfaces/bifi/IProxy.sol";
import "../../../interfaces/bifi/IMarketHandler.sol";
import "../../../interfaces/IERC20.sol";
import "../../../interfaces/IStrategy.sol";
import "../../../interfaces/uniswap/IUniswapV2Router02.sol";
import "../../../interfaces/IERC721.sol";
import "../../../utils/SafeMath.sol";
import "../../../utils/SafeERC20.sol";

/**
  * @title BiFi-X Standard StrategyLogic contract
  * @notice Strategy's make positions based on this contract
  * @author BiFi-X(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
  */
contract StrategyLogic is IStrategy, StrategySlot {
  using SafeMath for uint256;
  using SafeERC20 for IERC20;

  address constant public ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

  uint256 constant COLLATERAL_HANDLER = 0;
  uint256 constant LENDING_HANDLER    = 1;

  uint256 constant EXECUTE_AMOUNT = 10 ** 30;
  uint256 constant UNIFIED_ONE = 10 ** 18;

  /**
	* @dev For successfully start the strategy,
          calculate the amount of borrow and
          call the BiFi's manager flashloan function.
	* @param params The encoded params of strategy
	* @return Whether or not start strategy succeed
	*/
  function startStrategy(bytes memory params) external payable override returns (bool) {
    // check strategy already executed
    require(!strategyExecuted, "SL001");
    address _this = address(this);

    strategyExecuted = true;
    startedByOwner = true;

    // decode strategy params
    StrategyParams memory vars = _startParamsDecoder(params);

    uint256 actualBalance;
    uint256 expectedBalance = vars.amounts[0].add(vars.fees[0]).add(vars.fees[1]);

    handlerIDs = vars.handlerIDs;
    handlersAddress = vars.handlersAddress;

    if (handlerIDs[COLLATERAL_HANDLER] == 0) {
      actualBalance = _this.balance;
    } else {
      IERC20 collateralToken = IERC20(vars.tokenAddr[COLLATERAL_HANDLER]);
      actualBalance = collateralToken.balanceOf(_this);
    }

    // check seed
    require(actualBalance >= _convertUnifiedToUnderlying(expectedBalance, vars.decimal[0]), "SL002");

    // start strategy for make product contract of position
    // so, lockFlag true for switch control flow in executeOperation function
    vars.lockFlag = true;

    IMarketManager manager = IMarketManager(factory.getManagerAddr());

    vars.lendingAmount = vars.amounts[1];
    vars.collateralPrice = manager.getTokenHandlerPrice(vars.handlerIDs[COLLATERAL_HANDLER]);
    // startStrategy's flashloan target asset is collateral asset
    // if handlerIDs length 1 for Boost Strategy
    // so, lending token same as collateral, lending asset
    if (handlerIDs.length == 1) {
      // Boost case collatral, lending token amount == flashloan amount
      vars.lendingPrice = vars.collateralPrice;

      IMarketHandler handler = IMarketHandler(vars.handlersAddress[0]);

      (, bytes memory data) = handler.handlerViewProxy(abi.encodeWithSelector(handler.getTokenHandlerBorrowLimit.selector));

      uint256 borrowLimit = abi.decode(data, (uint256));

      // check max borrow amount can repay flashloan
      uint256 maxBorrowAmount = vars.amounts[0].add(vars.amounts[2]).unifiedMul(borrowLimit);
      require(maxBorrowAmount >= vars.lendingAmount, "SL003");
      emit StartStrategy(productID, address(this), handlerIDs[COLLATERAL_HANDLER], handlerIDs[COLLATERAL_HANDLER], vars.amounts[0], vars.amounts[2], vars.amounts[1], block.timestamp);
    } else if (handlerIDs.length == 2) {
      vars.lendingPrice = manager.getTokenHandlerPrice(vars.handlerIDs[LENDING_HANDLER]);
      emit StartStrategy(productID, address(this), handlerIDs[COLLATERAL_HANDLER], handlerIDs[LENDING_HANDLER], vars.amounts[0], vars.amounts[2], vars.amounts[1], block.timestamp);
    } else {
      revert("SL007");
    }


    // execute(start) flashloan
    manager.flashloan(
      handlerIDs[COLLATERAL_HANDLER],
      _this,
      vars.amounts[2],
      abi.encode(vars)
    );

    return true;
  }

  function endStrategyWithTransfer(uint256 amount, bytes memory params) external onlyOwner payable override returns (bool) {
    StrategyParams memory vars = _endParamsDecoder(params);
    address collateralAddr = vars.tokenAddr[0];
    if (collateralAddr == ETH_ADDRESS) {
      require(amount == 0, "only ether transfer");
    } else {
      address owner = NFT.ownerOf(productID);
      IERC20(collateralAddr).safeTransferFrom(owner, address(this), amount);
    }
    _endStrategy(params);
    return true;
  }

  function endStrategy(bytes memory params) external onlyOwner payable override returns (bool) {
    _endStrategy(params);
    return true;
  }

  /**
	* @dev End Strategy and selfdestruct Product contract.
	* @param params The encoded params of end strategy
	* @return Whether or not succeed
	*/
  function _endStrategy(bytes memory params) internal onlyOwner returns (bool) {
    startedByOwner = true;

    // decode parameter
    StrategyParams memory vars = _endParamsDecoder(params);

    address managerAddr = factory.getManagerAddr();
    IMarketManager manager = IMarketManager(managerAddr);

    // end strategy & release product position
    // so, lockFlag false for switch control flow in executeOperation function
    vars.lockFlag = false;

    address _this = address(this);
    uint256 handlerID;

    // endStrategy's flashloan target token is lending token
    (uint256 depositWithInterest, ) = _getUserAmountWithInterest(handlersAddress[COLLATERAL_HANDLER]);

    // if handlerIDs length 1 for Boost Strategy
    // so, same as collateral, lending token
    if (handlerIDs.length > 1) {
      handlerID = handlerIDs[LENDING_HANDLER];
      emit EndStrategy(productID, address(this), handlerIDs[COLLATERAL_HANDLER], handlerIDs[LENDING_HANDLER], depositWithInterest, vars.amounts[1], block.timestamp);
    }
    // else Leverage Strategy
    // so, flashloan target is repay token
    else {
      handlerID = handlerIDs[COLLATERAL_HANDLER];
      emit EndStrategy(productID, address(this), handlerIDs[COLLATERAL_HANDLER], handlerIDs[COLLATERAL_HANDLER], depositWithInterest, vars.amounts[1], block.timestamp);
    }

    vars.amounts[2] = vars.amounts[1];

    // execute(start) flashloan
    manager.flashloan(
      handlerID,
      _this,
      vars.amounts[2],
      abi.encode(vars)
    );

    // claim the rewards accumulated through the lending service.
    _rewardClaim();

    // selfdestruct this contract (for reduce gas fee)
    address _owner = NFT.ownerOf(productID);
    selfdestruct(payable(_owner));
  }

  /**
	* @dev Callback function when execute manager flashloan
  * @param reserve The address of token borrowed
  * @param amount The amount of token borrowed
  * @param fee The fee amount of token amount borrowed
	* @param params The encoded params of strategy(start or end)
	* @return Whether or not succeed
	*/
  function executeOperation(
      address reserve,
      uint256 amount,
      uint256 fee,
      bytes calldata params
  ) external onlyManager returns (bool) {
    // check executeOperation entry point is start or end Strategy
    require(startedByOwner, "onlyOwner");

    // decode params
    (StrategyParams memory vars) = abi.decode(params, (StrategyParams) );

    // calculate flashloan total debt for repay flashloan
    vars.totalDebt = amount.add(fee);

    address wethAddr = factory.getWETHAddr();

    IERC20 weth = IERC20(wethAddr);
    address _this = address(this);

    // if reserve is ETH, replace to WETH address for uniswap
    if (reserve == ETH_ADDRESS) { reserve = wethAddr; }

    // if handlersAddress length is 2, Boost case
    // Boost case, don't to build path for uniswap
    if (handlersAddress.length == 1) {
    }
    // if handlersAddress length is 2, Leverage case
    // Leverage case, need to build path for uniswap
    else if (handlersAddress.length == 2) {
      // pool is not enough (default)
      vars.pathCount = 3;

      for (uint256 i = 0; i < vars.handlerIDs.length; i++) {
        if (vars.handlerIDs[i] == 0) {
          // pool is enough, ETH
          vars.pathCount = 2;
        }
      }

      vars.path = new address[](vars.pathCount);

      if (vars.pathCount == 3) {
        vars.path[1] = wethAddr;
        vars.path[2] = reserve;
      } else if (vars.pathCount == 2) {
        vars.path[1] = reserve;
      }

      // if lock(startStrategy) case
      // path[0] : lending token (BiFi borrow)
      if (vars.lockFlag == true) {
        vars.path[0] = vars.tokenAddr[LENDING_HANDLER] == ETH_ADDRESS ? wethAddr : vars.tokenAddr[LENDING_HANDLER];
      }
      // if unlock(endStrategy) case
      // path[0] : collateral token (BiFi withdraw)
      else {
        vars.path[0] = vars.tokenAddr[COLLATERAL_HANDLER] == ETH_ADDRESS ? wethAddr : vars.tokenAddr[COLLATERAL_HANDLER];
      }
    } else {
      require(false, "SL004");
    }

    // deposit, borrow
    if (vars.lockFlag) { _lockPosition(vars); }

    // repay, withdraw
    else { _unlockPosition(vars); }

    // if handlersAddress.length is 2, Leverage case
    // need to use uniswap
    if (handlersAddress.length == 2) {
      // if user collateral is ETH, convert ETH to WETH
      uint256 _thisBalance = _this.balance;

      if (_thisBalance > 0) {
        weth.deposit{value: _thisBalance}();
      }

      if (vars.lockFlag) {
        // lock case, swap flashloan amount
        _lockPositionSwapPath(_this, vars);
      } else {
        // unlock case, swap flashloan + fee amount
        _unlockPositionSwapPath(_this, vars);
      }

      // if swap token is WETH, withdraw to ETH
      _thisBalance = weth.balanceOf(_this);
      if (_thisBalance > 0) { weth.withdraw(_thisBalance); }
    }

    depositAsset = vars.amounts[0].add(vars.amounts[2]).unifiedMul(vars.collateralPrice);

    srcAsset = vars.amounts[0].unifiedMul(vars.collateralPrice);
    srcPrice = vars.collateralPrice;

    dstAsset = vars.lendingAmount.unifiedMul(vars.lendingPrice);
    dstPrice = vars.lendingPrice;

    // repay flashloan
    _repayFlashloan(reserve, msg.sender, vars.totalDebt);

    // extra token return to owner
    _extraPayback(vars.tokenAddr, _this);

    startedByOwner = false;
    return true;
  }

  function getDepositAsset() external override view returns (uint256) {
    return depositAsset;
  }

  function getSrcAsset() external override view returns (uint256) {
    return srcAsset;
  }

  function getSrcPrice() external override view returns (uint256) {
    return srcPrice;
  }

  function getDstAsset() external override view returns (uint256) {
    return dstAsset;
  }

  function getDstPrice() external override view returns (uint256) {
    return dstPrice;
  }

  /**
	* @dev Repay flashloan borrow
	* @param reserve The address of flashloan borrow token
  * @param _to the address of flashloan lender
  * @param amount The amount of repay token
	*/
  function _repayFlashloan(address reserve, address _to, uint256 amount) internal {
    address wethAddr = factory.getWETHAddr();
    if (reserve == ETH_ADDRESS || reserve == wethAddr) {
      payable(_to).transfer(amount);
    } else {
      IERC20 token = IERC20(reserve);
      token.safeTransfer(_to, amount);
    }
  }

  /**
	* @dev Repay flashloan borrow
	* @param reserve The address[] of payback token
  * @param _this the address of extra token owner
	*/
  function _extraPayback(address[] memory reserve, address _this) internal {
    address _owner = NFT.ownerOf(productID);
    uint256 extraAmount;

    for (uint256 i = 0; i < reserve.length; i++) {
      if (reserve[i] != ETH_ADDRESS) {
        address tokenAddr = reserve[i];

        IERC20 token = IERC20(tokenAddr);
        extraAmount = token.balanceOf(_this);
        token.safeTransfer(_owner, extraAmount);

        emit ExtraPayback(productID, address(this), tokenAddr, extraAmount, _owner, block.timestamp);
      }
    }

    payable(_owner).transfer(_this.balance);
    emit ExtraPayback(productID, address(this), ETH_ADDRESS, _this.balance, _owner, block.timestamp);
  }

  /**
	* @dev Token Swap when lock
	* @param _this The address of flashloan borrow token
  * @param vars the count of swap number
	*/
  function _lockPositionSwapPath(address _this, StrategyParams memory vars) internal {
    UniswapParams memory params;
    params.wethAddr = factory.getWETHAddr();
    params.timestamp = block.timestamp;
    IUniswapV2Router02 uniswap = IUniswapV2Router02(factory.getUniswapAddr());
    IERC20 swapToken = IERC20(vars.path[0]);

    uint256 swapAmount = swapToken.balanceOf(address(this));
    swapToken.safeApprove(address(uniswap), swapAmount);
    uniswap.swapExactTokensForTokens(swapAmount, 0, vars.path, _this, params.timestamp);
    emit LockPositionSwap(productID, address(this), swapAmount, vars.path, params.timestamp);
  }

  // for avoid stack too deep
  struct UnlockPosition {
    IUniswapV2Router02 uniswap;
    IERC20 swapToken;
    uint256 outTokenAmount;
    uint256 dstBalanceAmount;
  }

  /**
	* @dev Token Swap when unlock
	* @param _this The address of flashloan borrow token
  * @param vars the address[] of token swap path when use uniswap
	*/
  function _unlockPositionSwapPath(address _this, StrategyParams memory vars) internal {
    UniswapParams memory params;
    UnlockPosition memory localVars;
    params.timestamp = block.timestamp;
    localVars.uniswap = IUniswapV2Router02(factory.getUniswapAddr());
    localVars.swapToken = IERC20(vars.path[0]);

    localVars.outTokenAmount = vars.totalDebt;

    IERC20 dstToken = IERC20(vars.path[vars.path.length-1]);
    localVars.dstBalanceAmount = dstToken.balanceOf(_this);

    if (vars.totalDebt > localVars.dstBalanceAmount) {
      localVars.outTokenAmount = vars.totalDebt.sub(localVars.dstBalanceAmount);
    }

    uint amountsInMax = _convertUnifiedToUnderlying(vars.amountsInMax, vars.decimal[0]);
    localVars.swapToken.safeApprove(address(localVars.uniswap), amountsInMax);
    localVars.uniswap.swapTokensForExactTokens(localVars.outTokenAmount, amountsInMax, vars.path, _this, params.timestamp);
    emit UnlockPositionSwap(productID, address(this), localVars.outTokenAmount, amountsInMax, vars.path, params.timestamp);
  }

  function _endParamsDecoder(bytes memory strategyParams) internal pure returns (StrategyParams memory) {
    StrategyParams memory vars;
    vars.amounts = new uint256[](3);
    (vars.tokenAddr,
    vars.handlersAddress,
    vars.handlerIDs,
    vars.amounts[1],
    vars.amountsInMax,
    vars.decimal) = abi.decode(strategyParams, (address[], address[], uint256[], uint256, uint256, uint256[]));
    return vars;
  }

  function _startParamsDecoder(bytes memory strategyParams) internal pure returns (StrategyParams memory) {
    StrategyParams memory vars;
    (vars.tokenAddr,
    vars.handlersAddress,
    vars.handlerIDs,
    // 0: flashloan fee, 1: swap fee
    vars.fees,
    // 0: collateral amount, 1: lending amount, 2: flashloan amount
    vars.amounts,
    vars.decimal) = abi.decode(strategyParams, (address[], address[], uint256[], uint256[], uint256[], uint256[]));
    return vars;
  }

  /**
	* @dev deposit and borrow
	* @param vars The variable of lock strategy
	* @return Whether or not _lockPosition succeed
	*/
  function _lockPosition(StrategyParams memory vars) internal returns (bool) {
    // add collateral amount
    uint256 depositAmount = vars.amounts[2].add(vars.amounts[0]);

    _deposit(vars.tokenAddr[0], handlersAddress[0], depositAmount);

    uint256 index = handlersAddress.length.sub(1);
    _borrow(handlersAddress[index], vars.lendingAmount);

    return true;
  }

  /**
	* @dev Repay and withdraw
	* @param vars The variable of lock strategy
	* @return Whether or not _lockPosition succeed
	*/
  function _unlockPosition(StrategyParams memory vars) internal returns (bool) {

    uint256 index = handlersAddress.length.sub(1);

    _repay(vars.tokenAddr[index], handlersAddress[index], vars.decimal[index]);

    _withdraw(vars.tokenAddr[0], handlersAddress[0], vars.decimal[0]);

    return true;
  }

  /**
	* @dev Deposit action to BiFi
	* @param reserve The address of token
  * @param tokenHandlerAddr The address of BiFi's tokenHandler contract
  * @param amount The amount of deposit
	*/
  function _deposit(address reserve, address tokenHandlerAddr, uint256 amount) internal {
    IProxy proxy = IProxy(tokenHandlerAddr);

    if (reserve == ETH_ADDRESS) {
      proxy.deposit{value: amount}(0, false);
    } else {
      IERC20 token = IERC20(reserve);
      token.safeApprove(tokenHandlerAddr, amount);
      proxy.deposit(amount, false);
    }
  }

  /**
	* @dev Repay action to BiFi
	* @param reserve The address of token
  * @param tokenHandlerAddr the address of BiFi's tokenHandler contract
  * @param decimal the decimal of reserve token
	*/
  function _repay(address reserve, address tokenHandlerAddr, uint256 decimal) internal {
    IProxy proxy = IProxy(tokenHandlerAddr);

    if (reserve == ETH_ADDRESS) {
      proxy.repay{value: address(this).balance}(0, false);
    } else {
      IERC20 token = IERC20(reserve);
      uint256 balance = token.balanceOf(address(this));
      uint256 unifiedAmount = _convertUnderlyingToUnified(balance, decimal);
      token.safeApprove(tokenHandlerAddr, balance);
      proxy.repay(unifiedAmount, false);
    }
  }

  /**
	* @dev Borrow action to BiFi
  * @param tokenHandlerAddr the address of BiFi tokenHandler contract
  * @param amount the amount of borrow
	*/
  function _borrow(address tokenHandlerAddr, uint256 amount) internal {
    IProxy proxy = IProxy(tokenHandlerAddr);
    proxy.borrow(amount, false);
  }

  /**
	* @dev Withdraw action to BiFi
  * @param tokenAddr the address of bifi token handler
  * @param tokenHandlerAddr the address of BiFi tokenHandler contract
  * @param decimal the decimal of withdraw token
	*/
  function _withdraw(address tokenAddr, address tokenHandlerAddr, uint256 decimal) internal {
    uint256 beforeBalance;
    uint256 afterBalance;

    address _this = address(this);

    if (tokenAddr == ETH_ADDRESS) {
      beforeBalance = _this.balance;
    } else {
      beforeBalance = IERC20(tokenAddr).balanceOf(_this);
    }

    IProxy proxy = IProxy(tokenHandlerAddr);
    (uint256 depositAmountWithInterest, ) = _getUserAmountWithInterest(tokenHandlerAddr);

    proxy.withdraw(depositAmountWithInterest, false);

    if (tokenAddr == ETH_ADDRESS) {
      afterBalance = _this.balance;
    } else {
      afterBalance = IERC20(tokenAddr).balanceOf(_this);
    }

    uint256 gap = depositAmountWithInterest.unifiedMul(10 ** 15);
    uint256 balance = _convertUnderlyingToUnified(afterBalance.sub(beforeBalance), decimal);

    if (depositAmountWithInterest > balance) {
      require(depositAmountWithInterest.sub(balance) <= gap, "SL005");
    } else {
      require(balance.sub(depositAmountWithInterest) <= gap, "SL006");
    }

  }


  /**
	* @dev Reward claim action to BiFi
	*/
  function rewardClaim() external {
    _rewardClaim();
  }

  function getProductID() external view returns (uint256) {
    return productID;
  }

  /**
	* @dev Reward claim action to BiFi
	*/
  function _rewardClaim() internal {
    address userAddr = address(this);

    address bifiAddr = factory.getBifiAddr();
    IMarketManager manager = IMarketManager(factory.getManagerAddr());
    IERC20 bifi = IERC20(bifiAddr);

    uint256 handlerLength = handlerIDs.length;

    for (uint256 i = 0; i < handlerLength; i++) {
      manager.claimHandlerReward(handlerIDs[i], payable(userAddr));
    }

    address owner = NFT.ownerOf(productID);
    bifi.safeTransfer(owner, bifi.balanceOf(userAddr));
  }

  function _getUserAmountWithInterest(address handlerAddr) internal view returns (uint256, uint256) {
    IMarketHandler handler = IMarketHandler(handlerAddr);
    (,bytes memory data)= handler.handlerViewProxy(
      abi.encodeWithSelector(handler.getUserAmountWithInterest.selector, address(this))
    );
    return abi.decode(data, (uint256, uint256));
  }

	function _convertUnderlyingToUnified(uint256 underlyingTokenAmount, uint256 underlyingTokenDecimal) internal pure returns (uint256) {
    return (underlyingTokenAmount.mul(UNIFIED_ONE)) / underlyingTokenDecimal;
	}

  function _convertUnifiedToUnderlying(uint256 unifiedTokenAmount, uint256 underlyingTokenDecimal) internal pure returns (uint256) {
		return (unifiedTokenAmount.mul(underlyingTokenDecimal)) / UNIFIED_ONE;
	}

  receive() external payable {
  }
}
