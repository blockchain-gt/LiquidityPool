// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {BGT} from "../src/BGT.sol";
import {USDC} from "../src/USDC.sol";
import {IFactory} from "../src/interfaces/IFactory.sol";
import {IRouter} from "../src/interfaces/IRouter.sol";
import {console} from "forge-std/console.sol";

contract DeployScript is Script {
    address V2_FACTORY = 0xF62c03E08ada871A0bEb309762E260a7a6a880E6;
    address V2_ROUTER = 0xeE567Fe1712Faf6149d80dA1E6934E354124CfE3;

    function setUp() public {}

    function run() public returns (BGT, USDC) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address deployer = vm.addr(deployerPrivateKey);
        console.log("Deployer: %s", deployer);

        // Deploy the contract
        BGT bgt = new BGT();
        USDC usdc = new USDC();

        // Create pair
        IFactory(V2_FACTORY).createPair(address(bgt), address(usdc));

        // Approve tokens
        bgt.approve(V2_ROUTER, type(uint256).max);
        usdc.approve(V2_ROUTER, type(uint256).max);

        // Add Liquidity
        IRouter(V2_ROUTER).addLiquidity(
            address(bgt), address(usdc), 1000000e18, 500000e18, 0, 0, deployer, block.timestamp + 60 * 60
        );

        // Swap tokens
        address[] memory path = new address[](2);
        path[0] = address(usdc);
        path[1] = address(bgt);
        IRouter(V2_ROUTER).swapExactTokensForTokens(500e18, 0, path, deployer, block.timestamp + 60 * 60);

        vm.stopBroadcast();
        return (bgt, usdc);
    }
}
