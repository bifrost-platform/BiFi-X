# callProxy

# π Description

> callProxy is a contract written to obtain the necessary values ββand information about the created Position when creating a BiFi-X Position through the user's assets.


## Method

``` solidity
function getStartPosition(uint256, uint256, uint256, uint256, uint256, address, uint256)
```

## Arguments
  | Variable |Meaning |
  |---|---|
  | `srcHandlerID` |BiFi Handler ID of Token to be deposited |
  | `dstHandlerID` |BiFi Handler ID of Token to be borrowed |
  | `collateralAmount` |User's collateral amount |
  | `times` |Multiple of Deposit to User's Collateral Amount |
  | `feePercent` |Percent of fee to be used to end the transaction |
  | `userAddr` | Address of user |
  | `bifiAmount` |User's BiFi Token Balance |
## Returns
  | Variable |Meaning |
  |---|---|
  | `depositAPY` |Annual Rate of Deposit Assets
  | `borrowAPY` |Annual Rate of Borrow Assets
  | `collateralAmount` |The actual amount of collateral for the user except fee
  | `expectedDepositAmount` |Expected value of Token Amount to be deposited in BiFi
  | `expectedBorrowAmount` |Borrow Token Amount Expected Value in BiFi
  | `srcPrice` |The price of the token to be deposited
  | `dstPrice` |The price of Token to Borrow
  | `netLTV` |LTV that Position will have in BiFi
  | `flashloanFee` |Fee for using flashloan when creating Position
  | `uniswapFee` |Fee for using uniswap when creating a Position
  | `flashloanFeePercent` |Fee for using flashloan when creating a Position percent
  | `uniswapFeePercent` |Fee for using uniswap when creating a Position percent
  | `bifiFee` |Number of BiFitoken to pay when using BiFi-X

## Method

``` solidity
function getEndPosition(address, uint256, uint256)
```

## Arguments
  | Variable |Meaning |
  |---|---|
  | `positionAddr` |User's Position contract address |
  | `slippage` |Slippage to allow when swapping through uniswap |
  | `bifiAmount` |User's BiFi Token Balance |

## Returns
  | Variable |Meaning |
  |---|---|
  | `srcHandlerID` |BiFi Handler ID of Deposited Token |
  | `dstHandlerID` |BiFi Handler ID of Borrow Token |
  | `srcPrice` |Price of the deposited token |
  | `dstPrice` |Price of the borrowed token |
  | `depositAmount` |Token Amount Deposited in BiFi |
  | `borrowAmount` |Token Amount borrowed in BiFi |
  | `depositAmountWithInterest` |Amount including interest of Token deposited in BiFi |
  | `borrowAmountWithInterest` |Amount including interest of Token Borrowed in BiFi |
  | `amountsInMax` |When swapping using uniswap, the maximum value for the Deposit asset to be input |
  | `flashloanFee` |Fee for using flashloan when exiting Position |
  | `flashloanFeePercent` |Fee for using flashloan when exiting Position percent |
  | `uniswapFee` |Fees for using uniswap when exiting Position |
  | `uniswapFeePercent` |Fee percent for using uniswap when exiting Position |
  | `bifiReward` |BiFi Token Amount to be received at the end of Position |

## Method

``` solidity
function getAllPositionStatus(address)
```


## Arguments
  | Variable |Meaning |
  |---|---|
  | `userAddr` |User's address |

## Returns
  | Variable |Meaning |
  |---|---|
  | `positionState` |Position is Earn or Long or Short |
  | `positionAddress` |Address of Position |
  | `scope` |Multiple of deposited assets to collateral |
  | `srcHandlerID` |BiFi Handler ID of Deposited Token |
  | `dstHandlerID` |BiFi Handler ID of Borrow Token |
  | `depositAsset` |Asset deposited in BiFi by user when creating a product |
  | `srcAsset` |Asset of collateral deposited by the user at the time of product |
  | `dstAsset` |Asset borrowed by the user when creating a product |
  | `srcPrice` |The price of the token that the user deposits in BiFi when creating a product |
  | `dstPrice` |The price of the token borrowed by the user to BiFi when creating a product |
  | `srcCurrentPrice` |The current price of the deposited token |
  | `dstCurrentPrice` |The current price of Borrow Token |
  | `ltv` |BiFi LTV in Current Position |
  | `appraisedAsset` |Assets in Current Position |
  | `depositAmount` |Deposit Amount of Position deposited in BiFi |
  | `borrowAmount` |Borrow Amount of Position Loaned to BiFi |
  | `depositInterestAmount` |Deposit Amount including interest of Position deposited in BiFi |
  | `borrowInterestAmount` |Borrow Amount including interest of Position loaned to BiFi |
  | `bifiReward` |Amount of Reward BiFi Tokens accumulated |

---

# callProxy

# π Description

> callProxyλ μ¬μ©μμ μμ°μ ν΅ν΄ BiFi-X Positionμ μμ±ν  λ νμν κ°λ€κ³Ό, μμ±λ Positionμ λν μ λ³΄λ€μ μ»μ΄ μ¬ μ μλλ‘ μμ± λ contractμλλ€.

## Method

``` solidity
function getStartPosition(uint256, uint256, uint256, uint256, uint256, address, uint256)
```

## Arguments
  | Variable |Meaning |
  |---|---|
  | `srcHandlerID` |Depositν  Tokenμ BiFi Handler ID |
  | `srcHandlerID` |Depositν  Tokenμ BiFi Handler ID |
  | `dstHandlerID` |Borrowν  Tokenμ BiFi Handler ID |
  | `collateralAmount` |μ¬μ©μμ λ΄λ³΄ κΈμ‘ |
  | `times` |μ¬μ©μμ λ΄λ³΄ κΈμ‘ λλΉ Deposit μ λ°°μ |
  | `feePercent` |μμ μ μΈ νΈλ μ μμ μ’λ£λ₯Ό μν΄ μ¬μ©ν  feeμ percent |
  | `userAddr` | μ¬μ©μμ μ£Όμ |
  | `bifiAmount` |μ¬μ©μμ BiFi Token Balance |
## Returns
  | Variable |Meaning |
  |---|---|
  | `depositAPY` |Deposit μμ°μ μ° μ΄μ¨
  | `borrowAPY` |Borrow μμ°μ μ° μ΄μ¨
  | `collateralAmount` |feeλ₯Ό μ μΈν μ¬μ©μμ μ€μ  λ΄λ³΄ κΈμ‘
  | `expectedDepositAmount` |BiFiμ Deposit λ  Token Amount μμ κ°
  | `expectedBorrowAmount` |BiFiμμ Borrow ν­ Token Amount μμ κ°
  | `srcPrice` |Deposit ν  Tokenμ κ°κ²©
  | `dstPrice` |Borrow ν  Tokenμ κ°κ²©
  | `netLTV` |BiFiμμ Positionμ΄ κ°μ§κ² λ  LTV
  | `flashloanFee` |Positionμ μμ±ν  λ flashloan μ¬μ©μ λν μμλ£
  | `uniswapFee` |Positionμ μμ±ν  λ uniswap μ¬μ©μ λν μμλ£
  | `flashloanFeePercent` |Positionμ μμ±ν  λ flashloan μ¬μ©μ λν μμλ£ percent
  | `uniswapFeePercent` |Positionμ μμ±ν  λ uniswap μ¬μ©μ λν μμλ£ percent
  | `bifiFee` |BiFi-Xλ₯Ό μ¬μ©ν  λ μ§λΆν  BiFi tokenμ κ°μ

## Method

``` solidity
function getEndPosition(address, uint256, uint256)
```

## Arguments
  | Variable |Meaning |
  |---|---|
  | `positionAddr` |μ¬μ©μμ Position contract μ£Όμ |
  | `slippage` |uniswapμ ν΅νμ¬ swap ν  λ νμ©ν  slippage |
  | `bifiAmount` |μ¬μ©μμ BiFi Token Balance |

## Returns
  | Variable |Meaning |
  |---|---|
  | `srcHandlerID` |Deposit ν Tokenμ BiFi Handler ID |
  | `dstHandlerID` |Borrow ν Tokenμ BiFi Handler ID |
  | `srcPrice` |Deposit ν Tokenμ Price |
  | `dstPrice` |Borrow ν Tokenμ Price |
  | `depositAmount` |BiFiμ Deposit λ Token Amount |
  | `borrowAmount` |BiFiμμ Borrow ν Token Amount |
  | `depositAmountWithInterest` |BiFiμ Deposit λ Token μ μ΄μ ν¬ν¨ Amount |
  | `borrowAmountWithInterest` |BiFiμμ Borrow ν Token μ μ΄μ ν¬ν¨ Amount |
  | `amountsInMax` |uniswapμ μ¬μ©νμ¬ swap ν  λ, μλ ₯ λ  Deposit μμ°μ λν μ΅λ κ° |
  | `flashloanFee` |Positionμ μ’λ£ν  λ flashloan μ¬μ©μ λν μμλ£ |
  | `flashloanFeePercent` |Positionμ μ’λ£ν  λ flashloan μ¬μ©μ λν μμλ£ percent |
  | `uniswapFee` |Positionμ μ’λ£ν  λ uniswap μ¬μ©μ λν μμλ£ |
  | `uniswapFeePercent` |Positionμ μ’λ£ν  λ uniswap μ¬μ©μ λν μμλ£ percent |
  | `bifiReward` |Positionμ μ’λ£ν  λ μλ Ήνκ² λ  BiFi Token Amount |

## Method

``` solidity
function getAllPositionStatus(address)
```

## Arguments
  | Variable |Meaning |
  |---|---|
  | `userAddr` |μ¬μ©μμ μ£Όμ |

## Returns
  | Variable |Meaning |
  |---|---|
  | `positionState` |Positionμ΄ Earn or Long or Short |
  | `positionAddress` |Positionμ μ£Όμ |
  | `scope` |λ΄λ³΄κΈ λλΉ Depositλ μμ°μ λ°°μ |
  | `srcHandlerID` |Deposit ν Tokenμ BiFi Handler ID |
  | `dstHandlerID` |Borrow ν Tokenμ BiFi Handler ID |
  | `depositAsset` |μ¬μ©μκ° Product μμ± μ BiFiμ depositν κΈμ‘ |
  | `srcAsset` |μ¬μ©μκ° Product μμ± μ μμΉν λ΄λ³΄ κΈμ‘ |
  | `dstAsset` |μ¬μ©μκ° Product μμ± μ λμΆν κΈμ‘ |
  | `srcPrice` |μ¬μ©μκ° Product μμ± μ BiFiμ depositν Tokenμ κ°κ²© |
  | `dstPrice` |μ¬μ©μκ° Product μμ± μ BiFiμ borrowν Tokenμ κ°κ²© |
  | `srcCurrentPrice` |Deposit ν Tokenμ νμ¬ κ°κ²© |
  | `dstCurrentPrice` |Borrow ν Tokenμ νμ¬ κ°κ²© |
  | `ltv` |νμ¬ Positionμ BiFiμ LTV |
  | `appraisedAsset` |νμ¬ Positionμ μμ° |
  | `depositAmount` |BiFiμ μμΉ λ Positionμ Deposit Amount |
  | `borrowAmount` |BiFiμ λμΆ λ Positionμ Borrow Amount |
  | `depositInterestAmount` |BiFiμ μμΉ λ Positionμ μ΄μ ν¬ν¨ Deposit Amount |
  | `borrowInterestAmount` |BiFiμ λμΆ λ Positionμ μ΄μ ν¬ν¨ Borrow Amount |
  | `bifiReward` |νμ¬κΉμ§ μμΈ Reward BiFi Tokenμ Amount|
