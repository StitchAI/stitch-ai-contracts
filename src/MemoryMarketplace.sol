// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MemoryMarketplace {
    enum MemoryType { Agent, External }

    struct Memory {
        uint256 id;
        address seller;
        uint256 price;
        bool isListed;
        MemoryType memoryType;
    }

    struct Purchase {
        address buyer;
        uint256 timestamp;
    }

    mapping(uint256 => Memory) public memories;
    mapping(uint256 => Purchase[]) public memoryPurchases;
    uint256 private nextMemoryId;
    IERC20 public paymentToken;

    event MemoryListed(uint256 indexed memoryId, address seller, uint256 price, MemoryType memoryType);
    event MemoryPurchased(uint256 indexed memoryId, address buyer, uint256 price);

    constructor(address _paymentToken) {
        paymentToken = IERC20(_paymentToken);
    }

    function listMemory(uint256 _price, MemoryType _memoryType) public returns (uint256) {
        uint256 memoryId = nextMemoryId++;
        memories[memoryId] = Memory({
            id: memoryId,
            seller: msg.sender,
            price: _price,
            isListed: true,
            memoryType: _memoryType
        });

        emit MemoryListed(memoryId, msg.sender, _price, _memoryType);
        return memoryId;
    }

    function delistMemory(uint256 _memoryId) public {
        require(memories[_memoryId].seller == msg.sender, "Only the seller can delist their own memory");
        memories[_memoryId].isListed = false;
    }

    function buyMemory(uint256 _memoryId) public {
        Memory storage memory_ = memories[_memoryId];
        require(memory_.isListed, "Memory is not listed");
        
        require(paymentToken.transferFrom(msg.sender, memory_.seller, memory_.price), "Token transfer failed");

        memoryPurchases[_memoryId].push(Purchase({
            buyer: msg.sender,
            timestamp: block.timestamp
        }));
        
        emit MemoryPurchased(_memoryId, msg.sender, memory_.price);
    }

    function getMemoryPurchases(uint256 _memoryId) public view returns (Purchase[] memory) {
        return memoryPurchases[_memoryId];
    }
}
