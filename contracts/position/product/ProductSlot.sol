// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "../../interfaces/IERC721.sol";
import "../../interfaces/IFactory.sol";

/**
  * @title BiFi-X ProductSlot contract
  * @notice For prevent proxy storage variable mismatch
  * @author BiFi-X(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
  */
contract ProductSlot {
  IERC721 public NFT;
  IFactory public factory;

  bool public strategyExecuted;
  bool startedByOwner;

  address public strategy;
  uint256 public strategyID;
  uint256 public productID;

  uint256 public depositAsset;
  uint256 public srcAsset;
  uint256 public srcPrice;
  uint256 public dstAsset;
  uint256 public dstPrice;

  modifier onlyOwner {
    require(msg.sender == NFT.ownerOf(productID));
    _;
  }

  modifier onlyManager {
    require(msg.sender == factory.getManagerAddr(), "onlyManager");
    _;
  }

  modifier onlyFactory {
    require(msg.sender == address(factory), "onlyFactory");
    _;
  }
}
