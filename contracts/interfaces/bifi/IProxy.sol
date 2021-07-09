// SPDX-License-Identifier: BSD-3-Clause
pragma solidity 0.6.12;

/**
 * @title BiFi's proxy interface
 * @author BiFi(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
 */
interface IProxy  {
  function deposit(uint256 unifiedTokenAmount, bool flag) external payable returns (bool);
  function withdraw(uint256 unifiedTokenAmount, bool flag) external returns (bool);
  function borrow(uint256 unifiedTokenAmount, bool flag) external returns (bool);
  function repay(uint256 unifiedTokenAmount, bool flag) external payable returns (bool);

	function handlerProxy(bytes memory data) external returns (bool, bytes memory);
	function handlerViewProxy(bytes memory data) external view returns (bool, bytes memory);
}
