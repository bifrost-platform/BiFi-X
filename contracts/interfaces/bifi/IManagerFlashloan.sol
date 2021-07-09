// SPDX-License-Identifier: BSD-3-Clause
pragma solidity 0.6.12;

interface IManagerFlashloan {
  function flashloan(
    uint256 handlerID,
    address receiverAddress,
    uint256 amount,
    bytes calldata params
  ) external returns (bool);

  function getFee(uint256 handlerID, uint256 amount) external view returns (uint256);

  function getTokenHandlerInfo(uint256 handlerID) external view returns (bool, address, string memory);
}
