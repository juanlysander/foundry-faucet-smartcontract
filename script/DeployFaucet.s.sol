// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Faucet} from "../src/smartcontract/Faucet.sol";

contract DeployFaucet is Script {
    function run() external returns (Faucet) {
        vm.startBroadcast();
        Faucet faucet = new Faucet();
        vm.stopBroadcast();
        return faucet;
    }
}
