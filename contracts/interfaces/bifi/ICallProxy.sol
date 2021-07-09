// SPDX-License-Identifier: BSD-3-Clause
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2

interface ICallProxy {
	struct callProxySI_MarketRewardInfo {
		uint256 handlerID;
		uint256 tokenPrice;
		uint256 dailyReward;
		uint256 claimedReward;
		uint256 depositReward;
		uint256 borrowReward;
	}

	struct callProxySI_GlobalRewardInfo {
		uint256 totalReward;
		uint256 dailyReward;
		uint256 claimedReward;
		uint256 remainReward;
	}


  function callProxySI_getSI(address payable userAddr) external view returns (address, callProxySI_MarketRewardInfo[] memory, callProxySI_GlobalRewardInfo memory, uint256);
}
