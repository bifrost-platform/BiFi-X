# Standard Strategy
# 📝 Description
> It corresponds to StrategyID 1, and supports Earn, Long, and Short based on UniswapV2.

### [StrategyLogic.sol](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/position/strategies/Standard/StrategyLogic.sol)
Contains the logic that the strategy operates.
+ Flashloan from BiFi allows you to maximize your rewards and returns by depositing and lending to BiFi at a higher cost than principal.
+ Supports Earn, Long and Short.
+ The asset exchange required for long and short is carried out using Uniswap V2.
+ The functions supported for users are as follows.

``` c#
startStrategy(bytes memory params)
```
It is called when the user creates a Position, and deposits and Borrows in BiFi through this.

``` c#
endStrategy(bytes memory params)
```
Called when the user terminates Position, which allows them to withdraw their funds and Reward Token, and removes Position Contract.

``` c#
endStrategyWithTransfer(uint256 amount, bytes memory params)
```
It gas same role as endStrategy, but is used to terminate the Position through additional funds when withdrawal is not possible due to interest or external factors.

``` c#
rewardClaim()
```
Receive existing stack of Reward Token without exiting Position.

### [StrategySlot.sol](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/position/strategies/Standard/StrategySlot.sol)
Defines the Event that occurs in Strategy, and defines the variable to be saved.

### Events

This event is raised when the user's Position is initially executed.
``` c#
  event StartStrategy(
    uint256 productID,
    address productAddr,
    uint256 srcID,
    uint256 dstID,
    uint256 collateralAmount,
    uint256 flashloanAmount,
    uint256 lendingAmount
  );
```

This event is raised when the user's Position ends.
``` c#
  event EndStrategy(
    uint256 productID,
    address productAddr,
    uint256 srcID,
    uint256 dstID,
    uint256 flashloanAmount
  );
```

This event occurs after swapping through Uniswap when the user's Position is Long or Short and created.
``` c#
event LockPositionSwap(
    uint256 productID,
    address productAddr,
    uint256 swapAmount,
    address[] path,
    uint256 timestamp
  );
```

This event occurs after swapping through Uniswap when the user's Position is Long or Short and is terminated.
``` c#
  event UnlockPositionSwap(
    uint256 productID,
    address productAddr,
    uint256 outAmount,
    uint256 amountInMax,
    address[] path,
    uint256 timestamp
  );
```

This event is fired when creating a Position and returning the free amount received for stable transaction termination.
``` c#
 event ExtraPayback(
    address tokenAddr,
    uint256 amount,
    address recipient
  );
```

### Variables
| Variable | Meaning |
|---|---|
| `handlersAddress` | In approaching bifi strategy address the address of the contract |
| `handlerIDs` | BiFi's Handler IDs accessed from Strategy |
| `uniswapV2Addr ` | Address of uniswap contract used by Strategy |

### [StrategyStructure.sol](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/position/strategies/Standard/StrategyStructures.sol)
The structure for the variables used in Strategy is defined, and unlike Slot, values ​​that are not saved after execution are handled.

<br>
<br>
<br>

# Standard Strategy
# 📝 Description
> StrategyID 1번에 해당하며, UniswapV2를 기준으로 Earn, Long, Short을 지원합니다.

### [StrategyLogic.sol](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/position/strategies/Standard/StrategyLogic.sol)
Strategy가 동작하는 logic을 포함합니다.
+ BiFi의 flashloan을 사용하여 BiFi에 예금과 대출을 원금 대비 높은 금액으로 예치 및 대출을 하여 Reward 및 수익률을 극대화 시킬 수 있습니다.
+ Earn, Long, Short을 지원합니다.
+ Long, Short에 필요한 자산 교환을 Uniswap V2을 이용해 진행합니다.
+ 사용자에게 지원하는 기능은 아래와 같습니다.

``` c#
startStrategy(bytes memory params)
```
사용자가 Position을 생성할 때 호출되며, 이를 통해 BiFi에 Deposit, Borrow를 진행합니다.

``` c#
endStrategy(bytes memory params)
```
사용자가 Position을 종료할 떄 호출하며, 이를 통해 사용자의 자금 및 Reward Token을 출금할 수 있으며,
Position Contract를 제거합니다.

``` c#
endStrategyWithTransfer(uint256 amount, bytes memory params)
```
endStrategy와 동일한 역할을 하지만, 이자 혹은 외부의 요인으로 인하여 출금이 불가할 때
추가적인 자금을 통하여 Position을 종료할 때 사용합니다.

``` c#
rewardClaim()
```
Position을 종료하지 않고 기존에 쌓인 Reward Token을 수령합니다.

### [StrategySlot.sol](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/position/strategies/Standard/StrategySlot.sol)
Strategy에서 발생하는 Event를 정의하며, 저장하는 변수에 대해 정의합니다.

### Events

사용자의 Position이 초기 실행될 때 발생하는 이벤트입니다.
``` c#
  event StartStrategy(
    uint256 productID,
    address productAddr,
    uint256 srcID,
    uint256 dstID,
    uint256 collateralAmount,
    uint256 flashloanAmount,
    uint256 lendingAmount
  );
```

사용자의 Position이 종료될 때 발생하는 이벤트입니다.
``` c#
  event EndStrategy(
    uint256 productID,
    address productAddr,
    uint256 srcID,
    uint256 dstID,
    uint256 flashloanAmount
  );
```

사용자의 Position이 Long 혹은 Short이고 생성될 때, Uniswap을 통해 swap한 후 발생하는 이벤트입니다.
``` c#
event LockPositionSwap(
    uint256 productID,
    address productAddr,
    uint256 swapAmount,
    address[] path,
    uint256 timestamp
  );
```

사용자의 Position이 Long 혹은 Short이고 종료될 때, Uniswap을 통해 swap한 후 발생하는 이벤트입니다.
``` c#
  event UnlockPositionSwap(
    uint256 productID,
    address productAddr,
    uint256 outAmount,
    uint256 amountInMax,
    address[] path,
    uint256 timestamp
  );
```

Position을 생성할 때, 안정적인 트렌젝션 종료를 위해 받았던 여유 금액을 돌려줄 때 발생하는 이벤트입니다.
``` c#
 event ExtraPayback(
    address tokenAddr,
    uint256 amount,
    address recipient
  );
```

### Variables
| Variable | Meaning |
|---|---|
| `handlersAddress` | Strategy에서 접근하는 BiFi의 Handler contract의 주소들 |
| `handlerIDs` | Strategy에서 접근하는 BiFi의 Handler ID들 |
| `uniswapV2Addr ` | Strategy에서 사용하는 uniswap contract의 주소|

### [StrategyStructure.sol](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/position/strategies/Standard/StrategyStructures.sol)
Strategy에서 사용하는 변수에 대한 구조체가 정의되어 있으며, Slot과는 다르게 실행 후 저장되지 않는 값을 다루게됩니다.
