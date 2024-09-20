// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "./PumpFaxtToken.sol";

contract PumpFaxtInterface is Context, Ownable, ReentrancyGuard {
    mapping(address => bool) private _validTokens;
    IERC20 private _frax;

    uint256 private _deploymentCharge = 0;
    uint256 private _initialVirtualReserve = 0;

    uint256 private _minimumInitialSupply = 0;
    uint256 private _maximumInitialSupply = 0;

    mapping(address => uint16) private _userDisplayPictureIndex;

    event Launch(address indexed creator, address token);
    event TradingStatusChanged(address indexed token, bool enabled);
    event DeploymentChargeChanged(uint256 newCharge);

    constructor(address fraxAddress_) Ownable(_msgSender()) {
        _frax = IERC20(fraxAddress_);
    }

    function deployNewToken(
        uint256 initialSupply_,
        string calldata name_,
        string calldata symbol_,
        string calldata image_,
        string calldata metadata_
    ) external returns (address) {
        require(
            _minimumInitialSupply <= initialSupply_ * (10**18),
            "Not enough initial supply"
        );
        require(
            initialSupply_ * (10**18) <= _maximumInitialSupply,
            "Initial supply must be less that maximum allowed supply"
        );

        if (_deploymentCharge > 0)
            frax.transferFrom(_msgSender(), address(this), _deploymentCharge);

        PumpFaxtToken newToken = new PumpFaxtToken(
            _msgSender(),
            initialSupply_,
            name_,
            symbol_,
            image_,
            metadata_,
            _initialVirtualReserve
        );
        address newTokenAddress = address(newToken);

        _validTokens[newTokenAddress] = true;

        emit Launch(_msgSender(), newTokenAddress);

        return newTokenAddress;
    }

    function minimumInitialSupply() external view returns (uint256) {
        return _minimumInitialSupply;
    }

    function maximumInitialSupply() external view returns (uint256) {
        return _maximumInitialSupply;
    }

    function deploymentCharge() external view returns (uint256) {
        return _deploymentCharge;
    }

    function setDeploymentCharge(uint256 newCharge_) external onlyOwner {
        _deploymentCharge = newCharge_;
        emit DeploymentChargeChanged(newCharge_);
    }

    function withdraw(
        address token_,
        address addr_,
        uint256 amount_
    ) external onlyOwner nonReentrant {
        IERC20(token_).transfer(addr_, amount_);
    }

    function isTokenValid(address addr_) external view returns (bool) {
        return _validTokens[addr_];
    }

    function displayPictureIndex(address user_) external view returns (uint16) {
        return _userDisplayPictureIndex[user_];
    }

    function setDisplayPictureIndex(uint16 index) external {
        _userDisplayPictureIndex[_msgSender()] = index;
    }

    function setMinimumInitialSupply(uint256 newMinimum_) external onlyOwner {
        _minimumInitialSupply = newMinimum_;
    }

    function setMaximumInitialSupply(uint256 newMaxium_) external onlyOwner {
        _maximumInitialSupply = newMaxium_;
    }

    function setInitialVirtualReserve(uint256 initialVirtualReserve_)
        external
        onlyOwner
    {
        _initialVirtualReserve = initialVirtualReserve_ * (10 ** _frax.decimals());
    }

    function disableTrading(address token_) external onlyOwner {
        require(_validTokens[token_], "Invalid Token Address");
        PumpFaxtToken(token_).disableTrading();
        emit TradingStatusChanged(token_, false);
    }

    function enableTrading(address token_) external onlyOwner {
        require(_validTokens[token_], "Invalid Token Address");
        PumpFaxtToken(token_).enableTrading();
        emit TradingStatusChanged(token_, true);
    }
}
