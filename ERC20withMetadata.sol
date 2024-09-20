// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20withMetadata is ERC20 {
    string private _image;
    address private _creator;
    string private _metadata;
    uint8 private immutable _decimals = 18;
    uint256 private _createdBlock;

    modifier onlyCreator() internal {
        require(msg.sender == _creator, "Only token creator is authorized");
        _;
    }

    event MetadataUpdated(string newMetadata);

    constructor(
        address creator_,
        uint256 initialSupply_,
        string memory name_,
        string memory symbol_,
        string memory image_,
        string memory metadata_
    ) ERC20(name_, symbol_) {
        _createdBlock = block.number;
        _creator = creator_;
        _image = image_;
        setMetadata(metadata_);
        _mint(address(this), initialSupply_ * (10 ** _decimals));
    }

    function decimals() public pure override returns (uint8) {
        return _decimals;
    }

    function image() external view virtual returns (string memory) {
        return _image;
    }

    function creator() public view virtual returns (address) {
        return _creator;
    }
    
    function createdBlock() external view virtual returns (uint256) {
        return _createdBlock;
    }

    function metadata() external view virtual returns (string memory) {
        return _metadata;
    }

    function setMetadata(string memory metadata_) public onlyCreator {
        _metadata = metadata_;
        emit MetadataUpdated(metadata_);
    }
}
