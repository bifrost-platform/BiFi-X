# callProxy

# 📝 Description

> callProxy is a contract written to obtain the necessary values ​​and information about the created Position when creating a BiFi-X Position through the user's assets.


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

# 📝 Description

> callProxy는 사용자의 자산을 통해 BiFi-X Position을 생성할 때 필요한 값들과, 생성된 Position에 대한 정보들을 얻어 올 수 있도록 작성 된 contract입니다.

## Method

``` solidity
function getStartPosition(uint256, uint256, uint256, uint256, uint256, address, uint256)
```

## Arguments
  | Variable |Meaning |
  |---|---|
  | `srcHandlerID` |Deposit할 Token의 BiFi Handler ID |
  | `srcHandlerID` |Deposit할 Token의 BiFi Handler ID |
  | `dstHandlerID` |Borrow할 Token의 BiFi Handler ID |
  | `collateralAmount` |사용자의 담보 금액 |
  | `times` |사용자의 담보 금액 대비 Deposit 의 배수 |
  | `feePercent` |안정적인 트렌젝션의 종료를 위해 사용할 fee의 percent |
  | `userAddr` | 사용자의 주소 |
  | `bifiAmount` |사용자의 BiFi Token Balance |
## Returns
  | Variable |Meaning |
  |---|---|
  | `depositAPY` |Deposit 자산의 연 이율
  | `borrowAPY` |Borrow 자산의 연 이율
  | `collateralAmount` |fee를 제외한 사용자의 실제 담보 금액
  | `expectedDepositAmount` |BiFi에 Deposit 될 Token Amount 예상 값
  | `expectedBorrowAmount` |BiFi에서 Borrow 항 Token Amount 예상 값
  | `srcPrice` |Deposit 할 Token의 가격
  | `dstPrice` |Borrow 할 Token의 가격
  | `netLTV` |BiFi에서 Position이 가지게 될 LTV
  | `flashloanFee` |Position을 생성할 때 flashloan 사용에 대한 수수료
  | `uniswapFee` |Position을 생성할 때 uniswap 사용에 대한 수수료
  | `flashloanFeePercent` |Position을 생성할 때 flashloan 사용에 대한 수수료 percent
  | `uniswapFeePercent` |Position을 생성할 때 uniswap 사용에 대한 수수료 percent
  | `bifiFee` |BiFi-X를 사용할 때 지불할 BiFi token의 개수

## Method

``` solidity
function getEndPosition(address, uint256, uint256)
```

## Arguments
  | Variable |Meaning |
  |---|---|
  | `positionAddr` |사용자의 Position contract 주소 |
  | `slippage` |uniswap을 통하여 swap 할 때 허용할 slippage |
  | `bifiAmount` |사용자의 BiFi Token Balance |

## Returns
  | Variable |Meaning |
  |---|---|
  | `srcHandlerID` |Deposit 한 Token의 BiFi Handler ID |
  | `dstHandlerID` |Borrow 한 Token의 BiFi Handler ID |
  | `srcPrice` |Deposit 한 Token의 Price |
  | `dstPrice` |Borrow 한 Token의 Price |
  | `depositAmount` |BiFi에 Deposit 된 Token Amount |
  | `borrowAmount` |BiFi에서 Borrow 한 Token Amount |
  | `depositAmountWithInterest` |BiFi에 Deposit 된 Token 의 이자 포함 Amount |
  | `borrowAmountWithInterest` |BiFi에서 Borrow 한 Token 의 이자 포함 Amount |
  | `amountsInMax` |uniswap을 사용하여 swap 할 때, 입력 될 Deposit 자산에 대한 최대 값 |
  | `flashloanFee` |Position을 종료할 때 flashloan 사용에 대한 수수료 |
  | `flashloanFeePercent` |Position을 종료할 때 flashloan 사용에 대한 수수료 percent |
  | `uniswapFee` |Position을 종료할 때 uniswap 사용에 대한 수수료 |
  | `uniswapFeePercent` |Position을 종료할 때 uniswap 사용에 대한 수수료 percent |
  | `bifiReward` |Position을 종료할 때 수령하게 될 BiFi Token Amount |

## Method

``` solidity
function getAllPositionStatus(address)
```

## Arguments
  | Variable |Meaning |
  |---|---|
  | `userAddr` |사용자의 주소 |

## Returns
  | Variable |Meaning |
  |---|---|
  | `positionState` |Position이 Earn or Long or Short |
  | `positionAddress` |Position의 주소 |
  | `scope` |담보금 대비 Deposit된 자산의 배수 |
  | `srcHandlerID` |Deposit 한 Token의 BiFi Handler ID |
  | `dstHandlerID` |Borrow 한 Token의 BiFi Handler ID |
  | `depositAsset` |사용자가 Product 생성 시 BiFi에 deposit한 금액 |
  | `srcAsset` |사용자가 Product 생성 시 예치한 담보 금액 |
  | `dstAsset` |사용자가 Product 생성 시 대출한 금액 |
  | `srcPrice` |사용자가 Product 생성 시 BiFi에 deposit한 Token의 가격 |
  | `dstPrice` |사용자가 Product 생성 시 BiFi에 borrow한 Token의 가격 |
  | `srcCurrentPrice` |Deposit 한 Token의 현재 가격 |
  | `dstCurrentPrice` |Borrow 한 Token의 현재 가격 |
  | `ltv` |현재 Position의 BiFi의 LTV |
  | `appraisedAsset` |현재 Position의 자산 |
  | `depositAmount` |BiFi에 예치 된 Position의 Deposit Amount |
  | `borrowAmount` |BiFi에 대출 된 Position의 Borrow Amount |
  | `depositInterestAmount` |BiFi에 예치 된 Position의 이자 포함 Deposit Amount |
  | `borrowInterestAmount` |BiFi에 대출 된 Position의 이자 포함 Borrow Amount |
  | `bifiReward` |현재까지 쌓인 Reward BiFi Token의 Amount|
