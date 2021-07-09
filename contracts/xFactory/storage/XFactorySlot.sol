// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

 /**
  * @title BiFi-X XFactorySlot contract
  * @notice For prevent proxy storage variable mismatch
  * @author BiFi-X(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
  */
contract XFactorySlot {
  address public storageAddr;
  address public _implements;
  address public _storage;

  address public owner;
  address public NFT;

  address public bifiManagerAddr;
  address public uniswapV2Addr;

  address public bifiAddr;
  address public wethAddr;

  // bifi fee variable
  uint256 fee;
  uint256 discountBase;
}
