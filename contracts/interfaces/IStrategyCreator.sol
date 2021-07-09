// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface IStrategyCreator {
  function create(address sender, address strategyLogic, bytes memory strategyParams) external payable returns (address);
}
