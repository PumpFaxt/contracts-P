# Table of Contents

- [Table of Contents](#table-of-contents)
  - [ERC20withMetadata](#erc20withmetadata)
    - [constructor](#constructor)
    - [decimals()](#decimals)
    - [image()](#image)
    - [creator()](#creator)
    - [createdBlock()](#createdblock)
    - [metadata()](#metadata)
    - [setMetadata()](#setmetadata)
  - [PumpFaxtToken](#pumpfaxttoken)
    - [constructor](#constructor-1)
    - [allowance()](#allowance)
    - [tokenPrice()](#tokenprice)
    - [marketCap()](#marketcap)
    - [reserve()](#reserve)
    - [supply()](#supply)
    - [disableTrading()](#disabletrading)
    - [enableTrading()](#enabletrading)
    - [calculateBuyCostByTokenAmount()](#calculatebuycostbytokenamount)
    - [calculateSellRefundByTokenAmount()](#calculatesellrefundbytokenamount)
    - [calculateTokensByFraxRefundAmount()](#calculatetokensbyfraxrefundamount)
    - [calculateTokensReceivedByFraxAmount()](#calculatetokensreceivedbyfraxamount)
    - [reserveThreshold()](#reservethreshold)
    - [buy()](#buy)
    - [sell()](#sell)
  - [PumpFaxtInterface](#pumpfaxtinterface)
    - [Constructor](#constructor-2)
    - [deployNewToken()](#deploynewtoken)
    - [minimumInitialSupply()](#minimuminitialsupply)
    - [maximumInitialSupply()](#maximuminitialsupply)
    - [deploymentCharge()](#deploymentcharge)
    - [setDeploymentCharge()](#setdeploymentcharge)
    - [withdraw()](#withdraw)
    - [isTokenValid()](#istokenvalid)
    - [displayPictureIndex()](#displaypictureindex)
    - [setDisplayPictureIndex()](#setdisplaypictureindex)
    - [setMinimumInitialSupply()](#setminimuminitialsupply)
    - [setMaximumInitialSupply()](#setmaximuminitialsupply)
    - [setInitialVirtualReserve()](#setinitialvirtualreserve)
    - [disableTrading()](#disabletrading-1)
    - [enableTrading()](#enabletrading-1)


## ERC20withMetadata


### constructor
```
constructor(
    address creator_,
    uint256 initialSupply_,
    string memory name_,
    string memory symbol_,
    string memory image_,
    string memory metadata_
) 
```
> Initializes the ERC20 token with metadata. Sets the creator, initial supply, image, and metadata.


<br/>

### decimals()
```
function decimals() public pure override returns (uint8)

```
> Returns the number of decimals used by the token. Always returns 18 (fixed).


<br/>

### image()
```
function image() external view returns (string memory)
```
> Returns the image URL or data associated with the token.


<br/>

### creator()
```
function creator() public view returns (address)
```
> Returns the address of the token creator.


<br/>

### createdBlock()
```
function createdBlock() external view returns (uint256)
```
> Returns the block number when the token was created.


<br/>

### metadata()
```
function metadata() external view returns (string memory)
```
> Returns the metadata associated with the token.


<br/>

### setMetadata()
```
function setMetadata(string memory metadata_) public onlyCreator
```
> Allows the creator to update the metadata for the token.


<br/>

## PumpFaxtToken


### constructor
```
constructor(
    address creator_,
    uint256 initialSupply_,
    string memory name_,
    string memory symbol_,
    string memory image_,
    string memory metadata_,
    uint256 initialVirtualReserve_
)
```
> Initializes the PumpFaxtToken with an initial virtual reserve. It also sets the creator and related metadata.

<br/>

### allowance()
```
function allowance(
    address owner, 
    address spender
) public view override returns (uint256)
```
> Updates the token's reserve and supply, calculates the new display price, and adjusts the virtual reserve when certain thresholds are met.


<br/>

### tokenPrice()
```
function tokenPrice() public view returns (uint256)
```
> Returns the current token price based on the virtual reserve and supply.


<br/>

### marketCap()
```
function marketCap() public view returns (uint256)
```
> Returns the market cap of the token, excluding the virtual reserve.


<br/>

### reserve()
```
function reserve() public view returns (uint256)
```
> Returns the current reserve of the token.


<br/>

### supply()
```
function supply() public view returns (uint256)
```
> Returns the current supply of the token held by the contract.


<br/>

### disableTrading()
```
function disableTrading() public onlyInterface
```
> Disables trading of the token. Can only be called by the interface contract.


<br/>

### enableTrading()
```
function enableTrading() public onlyInterface
```
> Re-enables trading of the token. Can only be called by the interface contract.


<br/>

### calculateBuyCostByTokenAmount()
```
function calculateBuyCostByTokenAmount(uint256 amount_) public view returns (uint256)
```
> Calculates the cost (in Frax) to buy a specified amount of tokens based on the current supply and reserve.

<br/>




### calculateSellRefundByTokenAmount()
```
function calculateSellRefundByTokenAmount(uint256 amount_) public view returns (uint256)

```
> Calculates the refund (in Frax) for selling a specified amount of tokens based on the current reserve and supply.


<br/>


### calculateTokensByFraxRefundAmount()
```
function calculateTokensByFraxRefundAmount(uint256 amount_) public view returns (uint256)

```
> Calculates how many tokens you can buy by refunding a specified amount of Frax.


<br/>

### calculateTokensReceivedByFraxAmount()
```
function calculateTokensReceivedByFraxAmount(uint256 amount_) public view returns (uint256)

```
> Calculates how many tokens can be bought with a specified amount of Frax.


<br/>


### reserveThreshold()
```
function reserveThreshold() public view returns (uint256)

```
> Returns the reserve threshold, which is used to determine when virtual reserves should be burned.

<br/>


### buy()
```
function buy(uint256 amountIn_, uint256 amountOutMin_) external nonReentrant

```
> Allows users to buy tokens by sending Frax. Ensures that the transaction meets the minimum required output based on slippage tolerance.

<br/>


### sell()
```
function sell(uint256 amountIn_, uint256 amountOutMin_) external nonReentrant

```
> Allows users to sell tokens in exchange for Frax. Ensures that the transaction meets the minimum refund based on slippage tolerance.



<br/>
<br/>


## PumpFaxtInterface

### Constructor
```
constructor(address fraxAddress_) Ownable(_msgSender())
```
> Initializes the PumpFaxtInterface and sets the Frax token address.

<br/>


### deployNewToken()

```
function deployNewToken(
    uint256 initialSupply_,
    string calldata name_,
    string calldata symbol_,
    string calldata image_,
    string calldata metadata_
) external returns (address)

```
> Deploys a new PumpFaxtToken and adds it to the valid token list.

<br/>

### minimumInitialSupply()

```
function minimumInitialSupply() external view returns (uint256)

```
> Returns the minimum allowed initial supply for token deployment.

<br/>

### maximumInitialSupply()

```
function maximumInitialSupply() external view returns (uint256)


```
> Returns the maximum allowed initial supply for token deployment.


<br/>

### deploymentCharge()

```
function deploymentCharge() external view returns (uint256)
```
> Returns the current deployment charge required to deploy a new PumpFaxtToken.



<br/>

### setDeploymentCharge()

```
function setDeploymentCharge(uint256 newCharge_) external onlyOwner
```
> Updates the deployment charge for new tokens.



<br/>

### withdraw()

```
function withdraw(
    address token_,
    address addr_,
    uint256 amount_
) external onlyOwner nonReentrant

```
> Allows the contract owner to withdraw funds from the contract.


<br/>

### isTokenValid()

```
function isTokenValid(address addr_) external view returns (bool)
```
> Checks if the provided address is a valid PumpFaxtToken contract.



<br/>

### displayPictureIndex()
```
function displayPictureIndex(address user_) external view returns (uint16)
```
> Returns the display picture index for a user.


<br/>

### setDisplayPictureIndex()
```
function setDisplayPictureIndex(uint16 index) external
```
> Allows users to set their display picture index.


<br/>

### setMinimumInitialSupply()
```
function setMinimumInitialSupply(uint256 newMinimum_) external onlyOwner
```
> Updates the minimum allowed initial supply for token deployment.


<br/>

### setMaximumInitialSupply()
```
function setMaximumInitialSupply(uint256 newMaxium_) external onlyOwner
```
> Updates the maximum allowed initial supply for token deployment.


<br/>

### setInitialVirtualReserve()
```
function setInitialVirtualReserve(uint256 initialVirtualReserve_) external onlyOwner
```
> Updates the initial virtual reserve for new token deployments.


<br/>

### disableTrading()
```
function disableTrading(address token_) external onlyOwner
```
> Disables trading for a specific token.


<br/>

### enableTrading()
```
function enableTrading(address token_) external onlyOwner
```
> Enables trading for a specific token.