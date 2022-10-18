// SPDX-License-Identifier: GPL-3.0
                                                        /* Code non fini dsl ...    */

pragma solidity 0.8.17;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Voting is Ownable
{
                /* Structures */
    struct Voter
    {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal
    {
        string description;
        uint voteCount;
    }

    enum WorkflowStatus
    {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    WorkflowStatus public current_workflowStatus;

                 /*     Event       */
    event VoterRegistered(address voterAddress); 
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted (address voter, uint proposalId);

    mapping(address => Voter) public voters;

    //address private admin;

    Proposal[] public proposals;

            /*      je ne sais pas si cette partie est obligatoire ou pas       */
    
    /*constructor()
    {
        admin = msg.sender;   
    }*/

    modifier checkWhitelist()
    {
        require(voters[msg.sender].isRegistered == true, "You need to be in the Whitelist");
        _;
    }

            /*      On cree la whitelist en verifiant que le voter n'y soit deja pas        */
    function createWhitelist(address _addr) public onlyOwner
    {
        require(voters[_addr].isRegistered == false, "You already are in the Whitelist");
        voters[_addr].isRegistered == true;
        emit VoterRegistered(_addr);
    }

        /*      Fonction pour start la session d'enregistrement de propositions en verifiant qu'on ne soit pas toujours en session d'enregistrement de "voters        */
    function setProposalSessionStart() external onlyOwner
    {
        require(current_workflowStatus != WorkflowStatus.RegisteringVoters, "We are still registering voters right now, please try later");
        current_workflowStatus = WorkflowStatus.ProposalsRegistrationStarted;
        emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, WorkflowStatus.ProposalsRegistrationStarted);   // et on passe de la session d'enregistrement de voters a la session de proposition en emit
    }

            /*      On fait exactement la meme chose mais cette fois ci pour y mettre fin donc on iverse les start et end ainsi que dans l'emit     */
    function setProposalSessionEnd() external onlyOwner
    {
        require(current_workflowStatus == WorkflowStatus.ProposalsRegistrationStarted, "Voting Session has already Ended");
        current_workflowStatus = WorkflowStatus.ProposalsRegistrationEnded;
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, WorkflowStatus.ProposalsRegistrationEnded);
    }

            /* 2 fonctions similaires mais cette fois ci pour les debuts et fin de vote         */

    function setVotingSessionsStart() external onlyOwner
    {
        require(current_workflowStatus == WorkflowStatus.ProposalsRegistrationEnded, "Proposal registration is not over yet, please try later");
        current_workflowStatus = WorkflowStatus.VotingSessionStarted;
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.VotingSessionStarted);
    }

    function setVotingSessionEnd() external onlyOwner
    {
        require(current_workflowStatus == WorkflowStatus.VotingSessionStarted, "Voting Session has not started yet, please try later");
        current_workflowStatus = WorkflowStatus.VotingSessionEnded;
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted, WorkflowStatus.VotingSessionEnded);
    }

        /*  On retrieve la proposition des electeurs pendant que la session est active       */

    function createProposal(address _addr, string memory _description) public view
    {
        require(voters[_addr].isRegistered == true, "You are not allowed to Propose since you are not in the Whitelist !");
        require(current_workflowStatus == WorkflowStatus.ProposalsRegistrationEnded, "Can't do this right now !");
        Proposal memory proposal;
        proposal.description = _description;
        
    }

        /*      Les electeurs votent pour l'id proposal en question donc la proposition     */
    function Vote(address _addr) public view
    {
        require(voters[_addr].isRegistered == true, "You are not allowed to Vote since you are not in the Whitelist !");
        require(voters[_addr].hasVoted == false, "You are not allowed to Vote since you already did !");
        voters[_addr].hasVoted == true;
//        Proposal[].votecount += 1;            Ici on doit mettre l'id proposal en question pour ensuite incrementer le vote sur cette proposition mais pas fini ..
    }
}

