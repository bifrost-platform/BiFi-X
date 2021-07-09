// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "../../Product/ProductSlot.sol";
import "./StrategyStructures.sol";

/**
  * @title BiFi-X Standard StrategySlot contract
  * @notice For prevent Strategy proxy storage variable mismatch
  * @author BiFi-X(seinmyung25, Miller-kk, tlatkdgus1, dongchangYoo)
  */
contract StrategySlot is ProductSlot, StrategyStructures {

  event StartStrategy(
    uint256 productID, // The NFT ID of Product. When checking the owner of the NFT, this ID will be used.
    address productAddr, // The Address of Product.
    uint256 srcID, // The ID of handler that is deposited.
    uint256 dstID, // The ID of handler that is borrowed.
    uint256 collateralAmount, // The amount of token required when creating a position in BIFI-X.
    uint256 flashloanAmount, // The amount borrowed via flashloan for leverage, When creating a position in BIFI-X.
    uint256 lendingAmount, // The amount of borrow. This amount is borrowed to pay off flashloan amount.
    uint256 timestamp // The timestamp of StartStrategy action.
  );

  event EndStrategy(
    uint256 productID, // The NFT ID of Product. When checking the owner of the NFT, this ID will be used.
    address productAddr, // The Address of Product.
    uint256 srcID, // The ID of handler that is deposited.
    uint256 dstID, // The ID of handler that is borrowed.
    uint256 depositAmount, // The amount of deposit.
    uint256 flashloanAmount, // The amount borrowed to pay off the loan through flashloan, When closing a position in BIFI-X.
    uint256 timestamp // The timestamp of EndStrategy action.
  );

  event LockPositionSwap(
    uint256 productID, // The NFT ID of Product. When checking the owner of the NFT, this ID will be used.
    address productAddr, // The Address of Product.
    uint256 swapAmount, // The amount of swap.
    address[] path, // The path of swap (An array of token addresses).
    uint256 timestamp // The timestamp of LockPositionSwap action.
  );

  event UnlockPositionSwap(
    uint256 productID, // The NFT ID of Product. When checking the owner of the NFT, this ID will be used.
    address productAddr, // The Address of Product.
    uint256 outAmount, // The amount of tokens when exchanging tokens.
    uint256 amountInMax, // The maximum amount of token to be exchanged when exchanging tokens.
    address[] path, // The path of swap (An array of token addresses).
    uint256 timestamp // The timestamp of UnlockPositionSwap action.
  );

  event ExtraPayback(
    uint256 productID, // The NFT ID of Product. When checking the owner of the NFT, this ID will be used.
    address productAddr, // The Address of Product.
    address tokenAddr, // the Address of token.
    uint256 amount, // the amount to send remaining assets when creating or closing a position.
    address recipient, // the Address of recipient.
    uint256 timestamp // The timestamp of ExtraPayback action.
  );

  address[] handlersAddress;
  uint256[] handlerIDs;

  address uniswapV2Addr;
}
