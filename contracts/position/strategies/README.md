# Strategies

# ๐ Description

> It is a contract that is executed based on Position.

## ๐ [Standard](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/position/strategies/Standard)

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

# ๐ Description

> Position์ ๊ธฐ๋ฐํ์ฌ ์คํํ๋ contract์๋๋ค.

## ๐ [Standard](https://github.com/bifrost-platform/BiFi-X/blob/main/contracts/position/strategies/Standard)

- BiFi์ flashloan์ ์ฌ์ฉํ์ฌ BiFi์ ์๊ธ๊ณผ ๋์ถ์ ์๊ธ ๋๋น ๋์ ๊ธ์ก์ผ๋ก ์์น ๋ฐ ๋์ถ์ ํ์ฌ Reward ๋ฐ ์์ต๋ฅ ์ ๊ทน๋ํ ์ํฌ ์ ์์ต๋๋ค.
- Earn, Long, Short์ ์ง์ํฉ๋๋ค.
- Long, Short์ ํ์ํ ์์ฐ ๊ตํ์ Uniswap V2์ ์ด์ฉํด ์งํํฉ๋๋ค.

<br>
<br>

์ฌ์ฉ์์๊ฒ ์ง์ํ๋ ๊ธฐ๋ฅ์ ์๋์ ๊ฐ์ต๋๋ค.

``` solidity
startStrategy(bytes memory params)
```

์ฌ์ฉ์๊ฐ Position์ ์์ฑํ  ๋ ํธ์ถ๋๋ฉฐ, ์ด๋ฅผ ํตํด BiFi์ Deposit, Borrow๋ฅผ ์งํํฉ๋๋ค.

<br>

``` solidity
endStrategy(bytes memory params)
```

์ฌ์ฉ์๊ฐ Position์ ์ข๋ฃํ  ๋ ํธ์ถํ๋ฉฐ, ์ด๋ฅผ ํตํด ์ฌ์ฉ์์ ์๊ธ ๋ฐ Reward Token์ ์ถ๊ธํ  ์ ์์ผ๋ฉฐ,
Position Contract๋ฅผ ์ ๊ฑฐํฉ๋๋ค.

<br>

``` solidity
endStrategyWithTransfer(uint256 amount, bytes memory params)
```

endStrategy์ ๋์ผํ ์ญํ ์ ํ์ง๋ง, ์ด์ ํน์ ์ธ๋ถ์ ์์ธ์ผ๋ก ์ธํ์ฌ ์ถ๊ธ์ด ๋ถ๊ฐํ  ๋
์ถ๊ฐ์ ์ธ ์๊ธ์ ํตํ์ฌ Position์ ์ข๋ฃํ  ๋ ์ฌ์ฉํฉ๋๋ค.

<br>

``` solidity
rewardClaim()
```

Position์ ์ข๋ฃํ์ง ์๊ณ  ๊ธฐ์กด์ ์์ธ Reward Token์ ์๋ นํฉ๋๋ค.
