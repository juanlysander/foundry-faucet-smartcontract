// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Faucet {
    error Faucet__ZeroEtherSent();
    error Faucet__FaucetHasBeenDepleted();

    //send ether to faucet
    function sendEtherToContract() public payable {
        if (msg.value <= 0) {
            revert Faucet__ZeroEtherSent();
        }
        payable(address(this)).transfer(msg.value);
    }

    // see contract balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // Send 1 ether to msg.sender
    function giveMeEther() public payable {
        if (address(this).balance <= 1e17) {
            revert Faucet__FaucetHasBeenDepleted();
        }
        payable(msg.sender).transfer(1e17);
    }

    receive() external payable {}

    fallback() external payable {}
}
