# XFactory Storage
### [PositionStorage.sol](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/xFactory/storage/PositionStorage.sol)
Stores information about user-generated Position.

### Variable
  | Variable | Meaning |
  |---|---|
  | `owner` | Owner's address of XFactory Storage |
  | `factory` | Address of XFactory contract |
  | `strategies ` | Mapping of strategy ID and logic contract address  |
  | `userProducts ` | Mapping of user's address and created Position address  |
  | `productToNFTID ` | Mapping of created Position address and NFT Token ID |

### [XFactorySlot.sol](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/xFactory/storage/XFactorySlot.sol)
It stores variables used in XFactory's Logic contract.

#### Variable
  | Variable | Meaning |
  |---|---|
  | `storageAddr` | XFactory's storage contract address |
  | `_implements` | Address of logic contract of XFactory |
  | `_storage ` | Address of storage contract of XFactory  |
  | `owner ` | Address of Owner of XFactory |
  | `NFT ` | NFT Token of BIFI-X |
  | `bifiManagerAddr ` | Address of BiFi's Manager contract |
  | `uniswapV2Addr` | Address of Uniswap RouterV2 contract |
  | `bifiAddr` | Address of BiFi Token |
  | `wethAddr ` | Address of WETH Token |
  | `fee ` | Amount of BiFi fee in BiFi-X |
  | `discountBase ` | Fee Discount Minimum Quantity |

<br>
<br>
<br>

# XFactory Storage
### [PositionStorage.sol](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/xFactory/storage/PositionStorage.sol)
사용자가 생성한 Position에 대한 정보를 저장합니다.

#### Variable
  | Variable | Meaning |
  |---|---|
  | `owner` | XFactory Storage의 Owner 주소 |
  | `factory` | XFactory contract의 주소 |
  | `strategies ` | Strategy의 ID와 logic contract의 주소의 mapping  |
  | `userProducts ` | 사용자의 주소와 생성한 Position 주소의 mapping  |
  | `productToNFTID ` | 생성된 Position의 주소와 NFT Token ID의 mapping |

### [XFactorySlot.sol](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/xFactory/storage/XFactorySlot.sol)
XFactory의 Logic contract에서 사용하는 변수들을 저장합니다.
#### Variable
  | Variable | Meaning |
  |---|---|
  | `storageAddr` | XFactory의 storage contract 주소 |
  | `_implements` | XFactory의 logic contract의 주소 |
  | `_storage ` | XFactory의 storage contract의 주소  |
  | `owner ` | XFactory의 Owner의 주소 |
  | `NFT ` | BIFI-X의 NFT Token |
  | `bifiManagerAddr ` | BiFi의 Manager contract의 주소 |
  | `uniswapV2Addr` | Uniswap RouterV2 contract의 주소 |
  | `bifiAddr` | BiFi Token의 주소 |
  | `wethAddr ` | WETH Token의 주소  |
  | `fee ` | BiFi-X의 BiFi 수수료 수량 |
  | `discountBase ` | 수수료 할인 최소 수량 |
