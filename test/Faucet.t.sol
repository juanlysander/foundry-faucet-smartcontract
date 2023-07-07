// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployFaucet} from "../script/DeployFaucet.s.sol";
import {Faucet} from "../src/Faucet.sol";

contract FaucetTest is Test {
    DeployFaucet public deployer;
    Faucet public faucet;

    address public SOMEONE = makeAddr("someone");
    uint256 public constant STARTING_BALANCE = 10 ether;

    function setUp() public {
        deployer = new DeployFaucet();
        faucet = deployer.run();
        vm.deal(SOMEONE, STARTING_BALANCE);
    }

    function testSendEtherToContractWithNoEther() public {
        vm.prank(SOMEONE);
        vm.expectRevert(Faucet.Faucet__ZeroEtherSent.selector);
        faucet.sendEtherToContract{value: 0}();
    }

    modifier userFunded() {
        vm.prank(SOMEONE);
        faucet.sendEtherToContract{value: 2 ether}();
        _;
    }

    function testSendEtherToContract() public {
        vm.prank(SOMEONE);
        faucet.sendEtherToContract{value: 1 ether}();
    }

    function testUserSeeContractBalance() public userFunded {
        assertEq(faucet.getContractBalance(), 2 ether);
    }

    function testUserRequestEtherFromFaucet() public userFunded {
        vm.prank(SOMEONE);
        faucet.giveMe1Ether();
        console.log(address(faucet).balance);
        assertEq(faucet.getContractBalance(), 1 ether);
    }

    function testFaucetHasNoMoreEther() public {
        vm.prank(SOMEONE);
        faucet.sendEtherToContract{value: 1 ether}();
        vm.prank(SOMEONE);
        vm.expectRevert(Faucet.Faucet__FaucetHasBeenDepleted.selector);
        faucet.giveMe1Ether();
    }
}
