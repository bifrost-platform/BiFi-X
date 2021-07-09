// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface IStrategy {
  function startStrategy(bytes memory params) external payable returns (bool);
  function endStrategy(bytes memory strategyParams) external payable returns (bool);
  function getDepositAsset() external view returns (uint256);
  function getSrcAsset() external view returns (uint256);
  function getSrcPrice() external view returns (uint256);
  function getDstAsset() external view returns (uint256);
  function getDstPrice() external view returns (uint256);
  function endStrategyWithTransfer(uint256 amount, bytes memory params) external payable returns (bool);
}
