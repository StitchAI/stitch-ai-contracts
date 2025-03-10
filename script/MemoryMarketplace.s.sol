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

        // Output verification command to console
        console.log("\n=== To verify the contract, run the following command ===\n");

        console.log(
            string.concat(
                "forge verify-contract ",
                vm.toString(address(marketplace)),
                " src/MemoryMarketplace.sol:MemoryMarketplace",
                " --rpc-url https://testnet-rpc.monad.xyz"
                " --verifier sourcify",
                " --verifier-url https://sourcify-api-monad.blockvision.org",
                " --constructor-args $(cast abi-encode 'constructor(address)' ",
                vm.toString(paymentToken),
                ")",
                " --optimizer-runs 200",
                " --via-ir"
            )
        );

        console.log("\n=====================================================\n");
    }
}