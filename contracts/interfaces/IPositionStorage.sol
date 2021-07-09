// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface IPositionStorage {
  function createStrategy(address strategyLogic) external returns (bool);
  function setStrategy(uint256 strategyID, address strategyLogic) external returns (bool);
  function getStrategy(uint256 strategyID) external view returns (address);
  function newUserProduct(address user, address product) external returns (bool);
  function getUserProducts(address user) external view returns (address[] memory);
  function setFactory(address _factory) external returns (bool);
  function setProductToNFTID(address product, uint256 nftID) external returns (bool);
  function getNFTID(address product) external view returns (uint256);
}
