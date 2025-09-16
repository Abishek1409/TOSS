// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract DonationRegistry {
    event DonationReceived(uint256 indexed campaignId, address indexed donor, uint256 amount);

    struct Donation { address donor; uint256 amount; uint256 timestamp; }

    mapping(uint256 => Donation[]) public campaignDonations;

    function donate(uint256 campaignId) external payable {
        require(msg.value > 0, "amount=0");
        campaignDonations[campaignId].push(Donation({
            donor: msg.sender,
            amount: msg.value,
            timestamp: block.timestamp
        }));
        emit DonationReceived(campaignId, msg.sender, msg.value);
    }

    function getDonations(uint256 campaignId) external view returns (Donation[] memory) {
        return campaignDonations[campaignId];
    }
}
