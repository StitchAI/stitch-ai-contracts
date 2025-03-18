// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/MemoryMarketplace.sol";

contract DeployMemoryMarketplace is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address paymentToken = vm.envAddress("PAYMENT_TOKEN_ADDRESS");

        vm.startBroadcast(deployerPrivateKey);

        // Deploy MemoryMarketplace
        MemoryMarketplace marketplace = new MemoryMarketplace(paymentToken);
        console.log("MemoryMarketplace deployed at:", address(marketplace));

        vm.stopBroadcast();

        console.log("\n=====================================================\n");
    }
}