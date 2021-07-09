# Position
# 📝 Description

> Position consists of Product and Strategy.
>
> Users can create multiple positions, each of which is distributed as an independent contract by the XFactory.

## 📁 [product](https://github.com/bifrost-platform/BiFi-X/tree/main/contracts/position/product)
When creating a position, it acts as a caller to invoke contract Strategy as a delete call.

## 📁 [strategies](https://github.com/bifrost-platform/BiFi-X/tree/main/contracts/position/strategies)
Strategies defines the logics that users will run when creating Position and has a relationship of N(Product): 1(Strategy).

<br>
<br>
<br>

# Position
# 📝 Description

> Position은 Product와 Strategy로 구성 되어있습니다.
>
> 사용자는 여러개의 Position을 생성할 수 있으며, 각각의 Position의 Product는 XFactory에 의하여 독립된 contract로 배포됩니다.

## 📁 [product](https://github.com/bifrost-platform/BiFi-X/tree/main/contracts/position/product)
Position을 생성할 때 contract Strategy를 delegate call로 호출하는 caller의 역할을 합니다.

## 📁 [strategies](https://github.com/bifrost-platform/BiFi-X/tree/main/contracts/position/strategies)
Strategies는 사용자가 Position을 생성할 때 실행하게 될 logic에 대해 정의하고 있으며 N(Product) : 1(Strategy)의 관계를 가집니다.
