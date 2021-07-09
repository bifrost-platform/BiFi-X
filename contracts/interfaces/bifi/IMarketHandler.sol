// SPDX-License-Identifier: BSD-3-Clause
pragma solidity 0.6.12;

/**
 * @title BiFi's market handler interface
 * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
 */
interface IMarketHandler  {
	function deposit(uint256 unifiedTokenAmount, bool allFlag) external payable returns (bool);
	function withdraw(uint256 unifiedTokenAmount, bool allFlag) external returns (bool);
	function borrow(uint256 unifiedTokenAmount, bool allFlag) external returns (bool);
	function repay(uint256 unifiedTokenAmount, bool allFlag) external payable returns (bool);

  function getTokenHandlerBorrowLimit() external view returns (uint256);

  function getMarketRewardInfo() external view returns (uint256, uint256, uint256);
	function getUserAmount(address payable userAddr) external view returns (uint256, uint256);
	function getUserAmountWithInterest(address payable userAddr) external view returns (uint256, uint256);
  function getUserRewardInfo(address payable userAddr) external view returns (uint256, uint256, uint256);

	function getUserMaxBorrowAmount(address payable userAddr) external view returns (uint256);
	function getUserMaxWithdrawAmount(address payable userAddr) external view returns (uint256);
	function getUserMaxRepayAmount(address payable userAddr) external view returns (uint256);

	function getDepositTotalAmount() external view returns (uint256);
	function getBorrowTotalAmount() external view returns (uint256);

  function getERC20Addr() external view returns (address);
  function getSIRandBIR() external view returns (uint256, uint256);
  function handlerViewProxy(bytes memory data) external view returns (bool, bytes memory);
  function siViewProxy(bytes memory data) external view returns (bool, bytes memory);
}
