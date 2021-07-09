// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

/**
  * @title BiFi-X Standard StrategyStructures contract
  * @notice Define Standard Strategy params structure
  * @author BiFi-X(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
  */
contract StrategyStructures {
  struct StrategyParams {
    address managerAddr;
    uint256[] handlerIDs;
    address[] handlersAddress;
    address[] tokenAddr;
    address[] path;
    uint256 pathCount;
    uint256[] fees;
    uint256[] amounts;
    uint256 amountsInMax;
    uint256 lendingAmount;
    uint256[] decimal;
    uint256 collateralPrice;
    uint256 lendingPrice;
    uint256 totalDebt;
    uint256 flashAmount;
    bool lockFlag;
  }

  struct UniswapParams {
    address wethAddr;
    uint256 timestamp;
  }
}
