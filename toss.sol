pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

// Interface for the main registry
interface IVerifiedRegistry {
    function verifiedAdmins(address) external view returns (bool);
    function verifiedDoctors(address) external view returns (bool);
}

// NEW Contract: Manages the on-chain record of verified doctor certificates
contract DoctorCertificateRegistry is Ownable {
    // Mapping from doctor's wallet address to the hash of their verified certificate details
    mapping(address => bytes32) public verifiedCertificateHashes;

    event CertificateVerified(address indexed doctorAddress, bytes32 certificateHash);

    constructor() Ownable(msg.sender) {}

    /**
     * @dev Records the hash of a verified doctor's certificate. Only callable by the owner.
     * @param _doctorAddress The wallet address of the doctor.
     * @param _certificateHash A unique hash representing the verified certificate details
     * (e.g., keccak256(abi.encodePacked(licenseNumber, doctorName, expiryDate))).
     * The hash calculation MUST be done consistently off-chain by the Verification Authority.
     */
    function addVerifiedCertificate(address _doctorAddress, bytes32 _certificateHash) public onlyOwner {
        require(_doctorAddress != address(0), "Cannot add zero address");
        require(_certificateHash != bytes32(0), "Certificate hash cannot be empty");
        verifiedCertificateHashes[_doctorAddress] = _certificateHash;
        emit CertificateVerified(_doctorAddress, _certificateHash);
    }

    /**
     * @dev Retrieves the verified certificate hash associated with a doctor's address.
     * Returns bytes32(0) if no certificate is recorded for the address.
     */
    function getCertificateHash(address _doctorAddress) public view returns (bytes32) {
        return verifiedCertificateHashes[_doctorAddress];
    }
}


// Contract 1: The Gatekeeper for Verified Roles (Remains largely the same)
contract VerifiedRegistry is Ownable {
    mapping(address => bool) public verifiedAdmins;
    mapping(address => bool) public verifiedDoctors;

    event AdminAdded(address indexed admin);
    event AdminRemoved(address indexed admin);
    event DoctorAdded(address indexed doctor);
    event DoctorRemoved(address indexed doctor);

    // Keep track of the certificate registry for potential future checks
    DoctorCertificateRegistry public certificateRegistry;

    constructor(address _certificateRegistryAddress) Ownable(msg.sender) {
         // Link to the deployed DoctorCertificateRegistry
        certificateRegistry = DoctorCertificateRegistry(_certificateRegistryAddress);
    }

    function addAdmin(address _admin) public onlyOwner {
        require(_admin != address(0), "VerifiedRegistry: Cannot add the zero address");
        verifiedAdmins[_admin] = true;
        emit AdminAdded(_admin);
    }

    function removeAdmin(address _admin) public onlyOwner {
        verifiedAdmins[_admin] = false;
        emit AdminRemoved(_admin);
    }

    /**
     * @dev Adds a doctor to the verified list.
     * IMPORTANT: The owner should ONLY call this AFTER adding the doctor's
     * certificate hash to the DoctorCertificateRegistry.
     */
    function addDoctor(address _doctor) public onlyOwner {
        require(_doctor != address(0), "VerifiedRegistry: Cannot add the zero address");
        // Optional stronger check: Ensure certificate hash exists before adding doctor role
        // require(certificateRegistry.getCertificateHash(_doctor) != bytes32(0), "Certificate must be verified first");
        verifiedDoctors[_doctor] = true;
        emit DoctorAdded(_doctor);
    }

    function removeDoctor(address _doctor) public onlyOwner {
        verifiedDoctors[_doctor] = false;
        emit DoctorRemoved(_doctor);
    }
}

// Contract 2: The Main Application Logic (Minor change in constructor)
contract TOSSCore {
    IVerifiedRegistry public registry; // This remains the primary check for actions

    // ... (Structs, State Variables, Events remain the same) ...
    struct ChildProfile {
        uint256 childId; string name; uint256 age; string story; bool exists;
    }
    struct DoctorReport {
        uint256 reportId; uint256 childId; string diagnosis; uint256 estimatedCost; string ipfsCID; address doctorAddress;
    }
     struct FundingRequest {
        uint256 requestId; uint256 childId; uint256 reportId; uint256 amountNeeded; uint256 amountRaised; string status; address[] donors;
    }
    uint256 public nextChildId = 101;
    uint256 public nextReportId = 1;
    uint256 public nextRequestId = 1;
    mapping(uint256 => ChildProfile) public childProfiles;
    mapping(uint256 => DoctorReport) public doctorReports;
    mapping(uint256 => FundingRequest) public fundingRequests;
    event ChildProfileCreated(uint256 indexed childId, string name);
    event DoctorReportCreated(uint256 indexed reportId, uint256 indexed childId, string ipfsCID);
    event FundingRequestCreated(uint256 indexed requestId, uint256 indexed childId, uint256 amountNeeded);
    event DonationMade(uint256 indexed requestId, address indexed donor, uint256 amount);


    // Constructor now takes the address of the main VerifiedRegistry
    constructor(address _registryAddress) {
        registry = IVerifiedRegistry(_registryAddress);
    }

    modifier onlyAdmin() {
        require(registry.verifiedAdmins(msg.sender), "Caller is not a verified admin");
        _;
    }

    modifier onlyDoctor() {
        require(registry.verifiedDoctors(msg.sender), "Caller is not a verified doctor");
        _;
    }

    // --- Core Functions (remain the same, rely on VerifiedRegistry) ---
    function createChildProfile(string memory _name, uint256 _age, string memory _story) public onlyAdmin {
        childProfiles[nextChildId] = ChildProfile(nextChildId, _name, _age, _story, true);
        emit ChildProfileCreated(nextChildId, _name);
        nextChildId++;
    }

    function createDoctorReport(uint256 _childId, string memory _diagnosis, uint256 _estimatedCost, string memory _ipfsCID) public onlyDoctor {
        require(childProfiles[_childId].exists, "Child profile does not exist");
        doctorReports[nextReportId] = DoctorReport(nextReportId, _childId, _diagnosis, _estimatedCost, _ipfsCID, msg.sender);
        emit DoctorReportCreated(nextReportId, _childId, _ipfsCID);
        nextReportId++;
    }

     function createFundingRequest(uint256 _childId, uint256 _reportId) public onlyAdmin {
        require(childProfiles[_childId].exists, "Child profile does not exist");
        require(doctorReports[_reportId].reportId != 0, "Doctor report does not exist");
        require(doctorReports[_reportId].childId == _childId, "Report does not match child");

        fundingRequests[nextRequestId] = FundingRequest({
            requestId: nextRequestId,
            childId: _childId,
            reportId: _reportId,
            amountNeeded: doctorReports[_reportId].estimatedCost,
            amountRaised: 0,
            status: "FUNDING",
            donors: new address[](0)
        });
        emit FundingRequestCreated(nextRequestId, _childId, doctorReports[_reportId].estimatedCost);
        nextRequestId++;
    }

    function donate(uint256 _requestId) public payable {
        FundingRequest storage request = fundingRequests[_requestId];
        require(request.requestId != 0, "Request does not exist");
        require(keccak256(abi.encodePacked(request.status)) == keccak256(abi.encodePacked("FUNDING")), "Request is not active");
        require(msg.value > 0, "Donation must be greater than zero");

        request.amountRaised += msg.value;
        request.donors.push(msg.sender);
        
        if (request.amountRaised >= request.amountNeeded) {
            request.status = "FUNDED";
        }

        emit DonationMade(_requestId, msg.sender, msg.value);
    }
    
    // --- View Function (remains the same) ---
     function getAllFundingRequests() public view returns (FundingRequest[] memory) {
        uint256 count = 0;
        for (uint256 i = 1; i < nextRequestId; i++) {
            if (keccak256(abi.encodePacked(fundingRequests[i].status)) == keccak256(abi.encodePacked("FUNDING"))) {
                count++;
            }
        }
        
        FundingRequest[] memory activeRequests = new FundingRequest[](count);
        uint256 index = 0;
        for (uint256 i = 1; i < nextRequestId; i++) {
             if (keccak256(abi.encodePacked(fundingRequests[i].status)) == keccak256(abi.encodePacked("FUNDING"))) {
                 activeRequests[index] = fundingRequests[i];
                 index++;
             }
        }
        return activeRequests;
    }
}
