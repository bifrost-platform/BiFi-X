// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./ProductSlot.sol";

/**
  * @title BiFi-X ProductProxy contract
  * @notice Deployed contract, (delegate)call Strategy logic
  * @author BiFi-X(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
  */
contract ProductProxy is ProductSlot {
  constructor(uint256 _strategyID, address _nft, address _factory, uint256 _productID) public {
    strategyID = _strategyID;
    NFT = IERC721(_nft);
    productID = _productID;
    factory = IFactory(_factory);
  }

  function setStrategyID(uint256 _strategyID) external onlyOwner returns (bool) {
    strategyID = _strategyID;
    return true;
  }

  function getStrategyID() external view returns (uint256) {
    return strategyID;
  }

  fallback() external payable {
    address addr = factory.getStrategy(strategyID);
    assembly {
      calldatacopy(0, 0, calldatasize())
      let result := delegatecall(gas(), addr, 0, calldatasize(), 0, 0)
      returndatacopy(0, 0, returndatasize())
      switch result
      case 0 { revert(0, returndatasize()) }
      default { return(0, returndatasize()) }
    }
  }

  receive() external payable {}
}
