// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "../../interfaces/IPositionStorage.sol";
import "../../interfaces/IStrategyCreator.sol";
import "../../Position/Product/ProductProxy.sol";
import "../../Position/Strategies/Standard/StrategyStructures.sol";
import "../../Position/Strategies/Standard/StrategyLogic.sol";
import "../../interfaces/IERC721.sol";
import "../../interfaces/IERC20.sol";
import "../../utils/SafeMath.sol";
import "../storage/XFactorySlot.sol";

/**
  * @title BiFi-X XFactoryInternal contract
  * @notice Implement internal logics for contract, basically storage setter
  * @author BiFi-X(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
  */
contract XFactoryInternal is StrategyStructures, XFactorySlot {
  using SafeMath for uint256;

  uint256 constant UNIFIED_ONE = 10 ** 18;

	modifier onlyOwner {
		require(msg.sender == address(owner), "Revert: onlyOwner");
		_;
	}
  modifier onlyAdmin {
    require(msg.sender == address(owner), "Revert: onlyOwner");
		_;
  }

  function _setOwner(address _owner) internal onlyOwner returns (bool) {
    owner = _owner;
    return true;
  }

  function _setImplements(address implementsAddr) internal onlyOwner returns (bool) {
    _implements = implementsAddr;
    return true;
  }

  function _setStorageAddr(address storageAddr) internal onlyOwner returns (bool) {
    _storage = storageAddr;
    return true;
  }

  function _setManagerAddr(address _bifiManagerAddr) internal onlyOwner returns (bool) {
    bifiManagerAddr = _bifiManagerAddr;
    return true;
  }

  function _setUniswapV2Addr(address _uniswapV2Addr) internal onlyOwner returns (bool) {
    uniswapV2Addr = _uniswapV2Addr;
    return true;
  }

  function _setNFT(address nftAddr) internal onlyOwner returns (bool) {
    NFT = nftAddr;
    return true;
  }

  function _setFee(uint256 _fee) internal onlyOwner returns (bool) {
    fee = _fee;
    return true;
  }

  function _setDiscountBase(uint256 _discountBase) internal onlyOwner returns (bool) {
    discountBase = _discountBase;
    return true;
  }

  function _convertUnifiedToUnderlying(uint256 unifiedTokenAmount, uint256 underlyingTokenDecimal) internal pure returns (uint256) {
    return (unifiedTokenAmount.mul(underlyingTokenDecimal)) / UNIFIED_ONE;
  }
}
