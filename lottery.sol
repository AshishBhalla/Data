// a small smart contract to mimic lottery system
pragma solidity ^0.4.17;

contract Lottery{
    address public manager;
    address[] public players;
    uint public totalStake;

    //store the address of the presn creating contract
    constructor() public{
        manager = msg.sender;
    }

    // players can enter with > .01 eth
    function enterInLottery() public payable{
        require(msg.value > .01 ether);
        totalStake += msg.value;
        players.push(msg.sender);
    }

    // get the list of all the players in lottery
    function getPlayers() public view returns(address[]){
        return players;
    }

    //   generate a pseudo random number using keccak256 algo
    function randomPlayer() private view returns(uint){
        return uint(keccak256(block.difficulty,now,players));
    }

    // choose the winner and initialize the contract to be re used
    function pickWinner() public onlyManagerCanCall{
        uint index = randomPlayer()%players.length;
        players[index].transfer(this.balance);
        players = new address[](0);
    }

    // a function modifier so that manager can call certain funcctions
    modifier onlyManagerCanCall(){
        msg.sender == manager;
        _;
    }
}
