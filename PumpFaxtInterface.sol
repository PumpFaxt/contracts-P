// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./PumpFaxtToken.sol";

contract PumpFaxtInterface is Ownable, ReentrancyGuard {
    mapping(address => bool) private _validTokens;
    IERC20 private _frax;

    uint256 private _deploymentCharge = 0;
    uint256 private _initialVirtualReserve = 0;

    uint256 private _minimumInitialSupply = 0;
    uint256 private _maximumInitialSupply = 0;

    mapping(address => uint16) private _userDisplayPictureIndex;

    event Launch(address indexed creator, address token);

    constructor(address fraxAddress_) Ownable(_msgSender()) {
        _frax = IERC20(fraxAddress_);
    }

    function deployNewToken(
        uint256 initialSupply_,
        string calldata name_,
        string calldata symbol_,
        string calldata image_,
        string calldata metadata_
    ) public returns (address) {
        require(
            _minimumInitialSupply <= initialSupply_ * (10**18),
            "Not enough initial supply"
        );
        require(
            initialSupply_ * (10**18) <= _maximumInitialSupply,
            "Initial supply must be less that maximum allowed supply"
        );

        if (_deploymentCharge > 0)
            frax.transferFrom(msg.sender, address(this), _deploymentCharge);

        PumpFaxtToken newToken = new PumpFaxtToken(
            msg.sender,
            initialSupply_,
            name_,
            symbol_,
            image_,
            metadata_,
            _initialVirtualReserve
        );
        address newTokenAddress = address(newToken);

        _validTokens[newTokenAddress] = true;

        emit Launch(msg.sender, newTokenAddress);

        return newTokenAddress;
    }

    function minimumInitialSupply() public view returns (uint256) {
        return _minimumInitialSupply;
    }

    function maximumInitialSupply() public view returns (uint256) {
        return _maximumInitialSupply;
    }

    function deploymentCharge() public view returns (uint256) {
        return _deploymentCharge;
    }

    function setDeploymentCharge(uint256 newCharge_) public onlyOwner {
        _deploymentCharge = newCharge_;
    }

    function withdraw(
        address token_,
        address addr_,
        uint256 amount_
    ) public onlyOwner nonReentrant {
        IERC20(token_).transfer(addr_, amount_);
    }

    function isTokenValid(address addr_) public view returns (bool) {
        return _validTokens[addr_];
    }

    function displayPictureIndex(address user_) public view returns (uint16) {
        return _userDisplayPictureIndex[user_];
    }

    function setDisplayPictureIndex(uint16 index) public {
        _userDisplayPictureIndex[msg.sender] = index;
    }

    function setMinimumInitialSupply(uint256 newMinimum_) public onlyOwner {
        _minimumInitialSupply = newMinimum_;
    }

    function setMaximumInitialSupply(uint256 newMaxium_) public onlyOwner {
        _maximumInitialSupply = newMaxium_;
    }

    function setInitialVirtualReserve(uint256 initialVirtualReserve_)
        public
        onlyOwner
    {
        _initialVirtualReserve = initialVirtualReserve_ * (10 ** _frax.decimals());
    }

    function disableTrading(address token_) public onlyOwner {
        require(_validTokens[token_], "Invalid Token Address");
        PumpFaxtToken(token_).disableTrading();
    }

    function enableTrading(address token_) public onlyOwner {
        require(_validTokens[token_], "Invalid Token Address");
        PumpFaxtToken(token_).enableTrading();
    }
}
