// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.6.12;

interface IFactory  {
  function setManagerAddr(address _bifiManagerAddr) external returns (bool);

  function setUniswapAddr(address _uniswapAddr) external returns (bool);

  function setNFT(address payable nftAddr) external returns (bool);

  function getManagerAddr() external view returns (address);

  function getUniswapAddr() external view returns (address);

  function getNFT() external view returns (address);

  function getStrategy(uint256 id) external view returns (address);

  function getBifiAddr() external view returns (address);

  function getWETHAddr() external view returns (address);

  function payFee(address user) external view returns (uint256);
}
