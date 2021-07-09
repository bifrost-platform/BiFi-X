# Product
# 📝 Description
> Product is a contract created by XFactory when creating a Position and a caller that executes the Strategy.
>
> The product contract has a 1:1 mapping relationship with the NFT and the ownership of the product is determined based on the NFT Token.
>
> When the user creates a Position, the strategy logic corresponding to the entered StrategyID is executed.

### Variables

| Variable | Meaning |
|---|---|
| `NFT` | the NFT of BiFi-X |
| `factory` | BiFi-X factory contract address |
| `strategyExecuted ` | Whether the strategy is executed  |
| `startedByOwner` | Whether to execute by owner |
| `strategy ` | Product's strategy contract address |
| `strategyID ` | Product's strategy ID |
| `depositAsset` | The asset deposited in BiFi by user when creating a product |
| `srcAsset ` | The asset of collateral deposited by the user when creating a product  |
| `srcPrice` | The price of the token that the user deposits in BiFi when creating a product |
| `dstAsset ` | The asset borrowed by the user when creating a product |
| `dstPrice ` | The price of the token that the user borrows in BiFi when creating a product |

<br>
<br>
<br>

# Product
# 📝 Description
> Product는 Position을 생성할 때, XFactory에 의해서 생성되는 contract이며 Strategy를 실행하는 caller입니다.
> Product contract는 NFT와 1:1 Mapping 관계를 가지며, Product의 소유권은 NFT Token에 기반하여 결정됩니다.
>
> 사용자가 Position을 생성할 때 입력한 StrategyID에 맞는 Strategy logic을 실행하게됩니다.

### Variables

| Variable | Meaning |
|---|---|
| `NFT` | BiFi-X의 NFT |
| `factory` | BiFi-X의 factory contract 주소 |
| `strategyExecuted ` | strategy의 실행 여부 |
| `startedByOwner` | owner에 의한 실행 여부 |
| `strategy ` | Product의 strategy contract 주소 |
| `strategyID ` | Product의 strategy ID |
| `depositAsset` | 사용자가 Product 생성 시 BiFi에 deposit한 금액 |
| `srcAsset ` | 사용자가 Product 생성 시 예치한 담보 금액  |
| `srcPrice` | 사용자가 Product 생성 시 BiFi에 deposit한 Token의 가격 |
| `dstAsset ` | 사용자가 Product 생성 시 대출한 금액 |
| `dstPrice ` | 사용자가 Product 생성 시 BiFi에 borrow한 Token의 가격 |
