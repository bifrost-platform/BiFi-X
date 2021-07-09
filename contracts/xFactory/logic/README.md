# XFactory Logic

# 📝 Description

> Logic contract called from the parent folder's XFactory Proxy to delete call.

### [XFactoryLogic.sol](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/xFactory/logic/XFactoryLogic.sol)

It contains a constructor of XFactory and inherits from XFactoryExternal.

### [XFactoryExternal.sol](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/xFactory/logic/XFactoryExternal.sol)

External functions of XFactory are defined.


### [XFactoryInternal.sol](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/xFactory/logic/XFactoryInternal.sol)

The internal functions of the XFactory are defined.

## Events

The event that occurs when a position is generated.

```solidity
event Create(
  uint256 strategyID, // The ID to identify strategy logic contracts
  uint256 productID, // The NFT ID of Product. When checking the owner of the NFT, this ID will be used.
  address positionAddr, // The Address of Product.
  address userAddr // The Address of the user who created the product.
);
```

This event occurs when a user uses BiFi-X to create a position and pay a fee.

```solidity
  event PayFee(
    address userAddr, // The Address of the user who created the product.
    uint256 feeAmount // The amount of BIFI token you pay to create a product
  );
```

This event occurs when the owner withdraws the BiFi-X fee.

```solidity
  event WithdrawFee(
    address receiver, // The Address of the receiver.
    uint256 feeAmount // The amount of BIFI token to be withdrawn.
  );
```

## Actions

### User Action

Generates a position corresponding to the straightyID.

```solidity
function create(uint256 strategyID, bytes memory strategyParams)
```

### Owner Action

Sets the strategy logic contract to be called with the delegate call corresponding to strategyID.

```solidity
function setStrategy(uint256 strategyID, address strategyAddr)
```

Sets BiFi Token to be used as BiFi-X's fee.

```solidity
function setBifiAddr(address _bifiAddr)
```

Sets the WETH Token address.

```solidity
function setWethAddr(address _wethAddr)
```

Sets the owner of the XFactory.

```solidity
function setOwner(address owner)
```

Sets the logic contract of XFactory.

```solidity
function setImplements(address implementsAddr)
```

Sets the storage contract of XFactory.

```solidity
function setStorageAddr(address storageAddr)
```

Sets the Manager contract of BiFi.

```solidity
function setManagerAddr(address _bifiManagerAddr)
```

Sets the Uniswap Router contract.

```solidity
function setUniswapV2Addr(address _uniswapV2Addr)
```

Set the NFT Token to be issued according to Position.

```solidity
function setNFT(address payable nftAddr)
```

Set the amount of BiFi fees for BiFi-X.

```solidity
function setFee(uint256 _fee)
```

Set the minimum amount of fee discounts for BiFi-X.

```solidity
function setDiscountBase(uint256 _discountBase)
```

Withdraw the usage fee of BiFi-X.

```solidity
function withdrawFee(address owner, uint256 amount)
```

---

# XFactory Logic

# 📝 Description

> 상위 폴더의 XFactory Proxy에서 delegate call로 호출되는 logic contract입니다.

### [XFactoryLogic.sol](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/xFactory/logic/XFactoryLogic.sol)

XFactory의 contructor가 포함 되어있고 XFactoryExternal을 상속 받습니다.

### [XFactoryExternal.sol](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/xFactory/logic/XFactoryExternal.sol)

XFactory의 External function들이 정의 되어있습니다.

### [XFactoryInternal.sol](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/xFactory/logic/XFactoryInternal.sol)

XFactory의 Internal function들이 정의 되어있습니다.

## Events

Position이 생성될 때 발생하는 이벤트입니다.

```solidity
event Create(
  uint256 strategyID, // The ID to identify strategy logic contracts
  uint256 productID, // The NFT ID of Product. When checking the owner of the NFT, this ID will be used.
  address positionAddr, // The Address of Product.
  address userAddr // The Address of the user who created the product.
);
```

사용자가 BiFi-X를 이용하여 Position을 생성하여 수수료를 지불할 때 발생하는 이벤트입니다.

```solidity
  event PayFee(
    address userAddr, // The Address of the user who created the product.
    uint256 feeAmount // The amount of BIFI token you pay to create a product
  );
```

Owner가 BiFi-X 사용 수수료에 대해 출금할 떄 발생하는 이벤트입니다.

```solidity
  event WithdrawFee(
    address receiver, // The Address of the receiver.
    uint256 feeAmount // The amount of BIFI token to be withdrawn.
  );
```

## Actions

### User Action

strategyID에 해당하는 Position을 생성합니다.

```solidity
function create(uint256 strategyID, bytes memory strategyParams)
```

### Owner Action

strategyID에 해당하는 delegate call로 호출 될 strategy logic contract를 설정합니다.

```solidity
function setStrategy(uint256 strategyID, address strategyAddr)
```

BiFi-X의 수수료로 사용 될 BiFi Token을 설정합니다.

```solidity
function setBifiAddr(address _bifiAddr)
```

WETH Token address를 설정합니다.

```solidity
function setWethAddr(address _wethAddr)
```

XFactory의 Owner를 설정합니다.

```solidity
function setOwner(address owner)
```

XFactory의 logic contract를 설정합니다.

```solidity
function setImplements(address implementsAddr)
```

XFactory의 storage contract를 설정합니다.

```solidity
function setStorageAddr(address storageAddr)
```

BiFi의 Manager contract를 설정합니다.

```solidity
function setManagerAddr(address _bifiManagerAddr)
```

Uniswap Router contract를 설정합니다.

```solidity
function setUniswapV2Addr(address _uniswapV2Addr)
```

Position에 맞춰 발행될 NFT Token을 설정합니다.

```solidity
function setNFT(address payable nftAddr)
```

BiFi-X의 BiFi 수수료 수량을 설정합니다.

```solidity
function setFee(uint256 _fee)
```

BiFi-X의 수수료 할인 최소 수량에 대해 설정합니다.

```solidity
function setDiscountBase(uint256 _discountBase)
```

BiFi-X의 사용 수수료를 출금합니다.

```solidity
function withdrawFee(address owner, uint256 amount)
```
