// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./XFactoryExternal.sol";

/**
  * @title BiFi-X XFactory logic contract
  * @author BiFi-X(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
  */
contract XFactoryLogic is XFactoryExternal {
  constructor(address _storageAddr, address _bifiManagerAddr) public {
    owner = msg.sender;
    storageAddr = _storageAddr;
    bifiManagerAddr = _bifiManagerAddr;
  }
}
