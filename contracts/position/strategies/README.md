# Strategies

# 📝 Description

> It is a contract that is executed based on Position.

## 📁 [Standard](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/position/strategies/Standard)

- Flashloan from BiFi allows you to maximize your rewards and returns by depositing and lending to BiFi at a higher cost than principal.
- Support for Earn, Long, and Short.
- The asset exchange required for long and short is carried out using Uniswap V2.

<br>
<br>

The functions supported for users are as follows.

``` solidity
startStrategy(bytes memory params)
```

It is called when the user creates a Position, and deposits and Borrows in BiFi through this.

<br>

``` solidity
endStrategy(bytes memory params)
```
Called when the user terminates Position, which withdraws the user's funds and Reward Token, and removes Position Contract.

<br>

``` solidity
endStrategyWithTransfer(uint256 amount, bytes memory params)
```
It has the same role as endStrategy, but is used to terminate Position through additional funds when withdrawals are not possible due to interest or external factors.

<br>

``` solidity
rewardClaim()
```

Receive reward tokens accumulated previously without terminating the position.

<br>
<br>
<br>

# Strategies

# 📝 Description

> Position에 기반하여 실행하는 contract입니다.

## 📁 [Standard](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/position/strategies/Standard)

- BiFi의 flashloan을 사용하여 BiFi에 예금과 대출을 원금 대비 높은 금액으로 예치 및 대출을 하여 Reward 및 수익률을 극대화 시킬 수 있습니다.
- Earn, Long, Short을 지원합니다.
- Long, Short에 필요한 자산 교환을 Uniswap V2을 이용해 진행합니다.

<br>
<br>

사용자에게 지원하는 기능은 아래와 같습니다.

``` solidity
startStrategy(bytes memory params)
```

사용자가 Position을 생성할 때 호출되며, 이를 통해 BiFi에 Deposit, Borrow를 진행합니다.

<br>

``` solidity
endStrategy(bytes memory params)
```

사용자가 Position을 종료할 떄 호출하며, 이를 통해 사용자의 자금 및 Reward Token을 출금할 수 있으며,
Position Contract를 제거합니다.

<br>

``` solidity
endStrategyWithTransfer(uint256 amount, bytes memory params)
```

endStrategy와 동일한 역할을 하지만, 이자 혹은 외부의 요인으로 인하여 출금이 불가할 때
추가적인 자금을 통하여 Position을 종료할 때 사용합니다.

<br>

``` solidity
rewardClaim()
```

Position을 종료하지 않고 기존에 쌓인 Reward Token을 수령합니다.
