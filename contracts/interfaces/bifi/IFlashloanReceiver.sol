// SPDX-License-Identifier: BSD-3-Clause
pragma solidity 0.6.12;

interface IFlashloanReceiver {
  function executeOperation(
    address reserve,
    uint256 amount,
    uint256 fee,
    bytes calldata params
  ) external returns (bool);
}
