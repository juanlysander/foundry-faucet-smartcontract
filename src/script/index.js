//connect metamask
let account;
const connectMetamask = async () => {
    if(window.ethereum !== "undefined") {
        const accounts = await ethereum.request({method: "eth_requestAccounts"});
        account = accounts[0];
        const slicedAccount = account.slice(0, 5) + "..." + account.slice(-4);
        document.getElementById("accountArea").innerHTML = slicedAccount;
    }
}

//connect to smart contract
const connectContract = async () => {
    const ABI = [
        {
            "inputs": [],
            "name": "Faucet__FaucetHasBeenDepleted",
            "type": "error"
        },
        {
            "inputs": [],
            "name": "Faucet__ZeroEtherSent",
            "type": "error"
        },
        {
            "inputs": [],
            "name": "giveMeEther",
            "outputs": [],
            "stateMutability": "payable",
            "type": "function"
        },
        {
            "inputs": [],
            "name": "sendEtherToContract",
            "outputs": [],
            "stateMutability": "payable",
            "type": "function"
        },
        {
            "stateMutability": "payable",
            "type": "fallback"
        },
        {
            "stateMutability": "payable",
            "type": "receive"
        },
        {
            "inputs": [],
            "name": "getContractBalance",
            "outputs": [
                {
                    "internalType": "uint256",
                    "name": "",
                    "type": "uint256"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        }
    ];
    const Address = "0xb6a26b26ECC57d8d29292aC187dA314cBb3EB662";
    window.web3 = await new Web3(window.ethereum);
    window.contract = await new window.web3.eth.Contract(ABI, Address);
    document.getElementById("contractArea").innerHTML = "Connected";
}

//getBalance
const getContractBalance = async () => {
    const data = await window.contract.methods.getContractBalance().call();
    const balance = Number(data) / 1e18;
    document.getElementById("contractBalance").innerHTML = `${balance} ETH`;
}

//sending ethereum to contract
const sendEtherToContract = async () => {
    const donationAmount = parseFloat(document.getElementById("donate-input").value);
  
    if (donationAmount <= 0) {
        return;
    }
  
    try {
        await window.contract.methods.sendEtherToContract().send({ from: account, value: web3.utils.toWei(donationAmount.toString(), 'ether') });
        console.log('Donation successful');
        window.alert('Donation successful');
    } catch (error) {
        console.error('Failed to send Ether to contract:', error);
        window.alert('Failed to send Ether to contract');
    }
};

const giveMeEther = async () => {
    try {
        await contract.methods.giveMeEther().send({from: account});
        console.log('Ether sent successfully');
        window.alert('Ether sent successfully');
    } catch (error) {
        console.error('Failed to send ether:', error);
        window.alert('Failed to send ether')
    }
}