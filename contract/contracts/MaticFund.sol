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

import "./SafeMath.sol";
import "./AggregatorV3Interface.sol";

contract MaticFund {
    AggregatorV3Interface internal priceFeed;

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
    uint256 public constant TIME_STEP = 1 seconds;
    address payable public marketingAddress;
    address payable public projectAddress;
    address payable public devAdress;
    address payable public nAddress1;
    address payable public nAddress2;
    uint256 public totalInvestAmount;
    uint256 public totalInvestCount;
    uint256 public totalWithdrawn;
    uint256 public contractTradeProfit;
    uint256 public contractPercent = 5e1;
    uint256 public contractCreationTime;
    address public contractAddress;
    address[] private investorsCount;

    struct ReferralRules {
        uint256 percent;
        uint256 requiredAmount;
        uint24 requiredFirstLineCount;
        uint8 affiliateMultiple;
    }

    ReferralRules[] _NECESSARIES;
    struct Deposit {
        uint256 amount;
        uint256 withdrawn;
        uint256 start;
        uint256 usd_amount;
        uint256 usd_withdrawn;
        bool active;
    }
    struct User {
        Deposit[] deposits;
        uint256 checkpoint;
        address referrer;
        uint256 bonus;
        uint256 usd_bonus;
        uint256 totalDepositAmount;
        uint256 totalMissedAmount;
        uint256 totalTeamInvest;
        uint256 totalUsdDepositAmount;
        uint24[12] refs;
        uint24 firstLineCount;
    }
    mapping(address => User) internal users;
    mapping(address => address) public uplinePartners;

    event Newbie(address user);
    event NewDeposit(address indexed user, uint amount, uint256 usdAmount);
    event Withdrawn(address indexed user, uint amount, uint256 usdAmount);
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
        address payable _nAddress1,
        address payable _nAddress2,
        address payable _priceFeedAddress
    ) {
        marketingAddress = marketingAddr;
        projectAddress = projectAddr;
        devAdress = devAddr;
        contractCreationTime = block.timestamp;
        nAddress1 = _nAddress1;
        nAddress2 = _nAddress2;
        owner = msg.sender;
        NECESSARIES[0] = ReferralRules(1e3, 1e18, 0, 1);
        NECESSARIES[1] = ReferralRules(2e2, 5e18, 1, 2);
        NECESSARIES[2] = ReferralRules(1e2, 1e19, 1, 2);
        NECESSARIES[3] = ReferralRules(1e2, 1e19, 1, 2);
        NECESSARIES[4] = ReferralRules(1e2, 1e19, 1, 2);
        NECESSARIES[5] = ReferralRules(1e2, 1e19, 6, 6);
        NECESSARIES[6] = ReferralRules(1e2, 15e18, 7, 7);
        NECESSARIES[7] = ReferralRules(1e2, 16e18, 8, 8);
        NECESSARIES[8] = ReferralRules(1e2, 17e18, 9, 9);
        NECESSARIES[9] = ReferralRules(1e2, 18e18, 10, 10);
        NECESSARIES[10] = ReferralRules(1e2, 19e18, 11, 10);
        NECESSARIES[11] = ReferralRules(1e2, 2e19, 12, 10);
        priceFeed = AggregatorV3Interface(_priceFeedAddress);
    }

    function getLatestPrice() public view returns (uint256) {
        (, int256 price, , uint timeStamp, ) = priceFeed.latestRoundData();
        require(timeStamp > 0, "Round not complete");
        return uint256(price).mul(1e10);
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
        uint256 _contractbalance = getContractBalance();
        uint256 totalAmount;
        uint256 total_USD_Amount;
        uint256 dividends;
        uint32 multiplier = 2;
        uint256 current_price = uint256(getLatestPrice());

        require(_contractbalance > 0, "Contract Balance : Zero");
        for (uint256 i = 0; i < user.deposits.length; i++) {
            if (
                uint256(user.deposits[i].withdrawn) <
                uint256(user.deposits[i].amount).mul(multiplier)
            ) {
                if (
                    uint256(user.deposits[i].usd_withdrawn) <
                    uint256(user.deposits[i].usd_amount).mul(multiplier)
                ) {
                    uint256 userdepositsamount = uint256(
                        user.deposits[i].amount
                    );

                    if (user.deposits[i].start > user.checkpoint) {
                        dividends = (
                            userdepositsamount.mul(userPercentRate).div(
                                PERCENTS_DIVIDER
                            )
                        )
                            .mul(
                                block.timestamp.sub(
                                    uint256(user.deposits[i].start)
                                )
                            )
                            .div(TIME_STEP);
                    } else {
                        dividends = (
                            userdepositsamount.mul(userPercentRate).div(
                                PERCENTS_DIVIDER
                            )
                        )
                            .mul(block.timestamp.sub(uint256(user.checkpoint)))
                            .div(TIME_STEP);
                    }

                    if (
                        uint256(user.deposits[i].withdrawn).add(dividends) >
                        uint256(user.deposits[i].amount).mul(multiplier)
                    ) {
                        dividends = (
                            uint256(user.deposits[i].amount).mul(multiplier)
                        ).sub(uint256(user.deposits[i].withdrawn));
                        user.deposits[i].active = false;
                    }

                    if (totalAmount.add(dividends) > _contractbalance) {
                        dividends = _contractbalance.sub(totalAmount);
                    }
                    uint256 USD_dividends = uint256(
                        dividends.mul(current_price)
                    ).div(1e18);
                    uint256 current_USD_dividends = uint256(
                        user.deposits[i].usd_withdrawn
                    ).add(USD_dividends);
                    uint256 max_USD_dividends = uint256(
                        user.deposits[i].usd_amount
                    ).mul(multiplier);
                    if (current_USD_dividends > max_USD_dividends) {
                        uint256 USD_difference = current_USD_dividends.sub(
                            max_USD_dividends
                        );
                        if (USD_difference > 0) {
                            uint256 Ether_difference = uint256(
                                USD_difference.mul(1e18)
                            ).div(current_price);
                            if (dividends > Ether_difference) {
                                dividends = dividends.sub(Ether_difference);
                            }
                            USD_dividends = uint256(
                                dividends.mul(current_price)
                            ).div(1e18);
                            user.deposits[i].active = false;
                        }
                    }

                    user.deposits[i].withdrawn = uint256(
                        uint256(user.deposits[i].withdrawn).add(dividends)
                    );
                    user.deposits[i].usd_withdrawn = uint256(
                        uint256(user.deposits[i].usd_withdrawn).add(
                            (dividends.mul(current_price)).div(1e18)
                        )
                    );
                    totalAmount = uint256(totalAmount.add(dividends));
                    total_USD_Amount = uint256(
                        total_USD_Amount.add(
                            (dividends.mul(current_price)).div(1e18)
                        )
                    );
                }
            }
        }

        require(totalAmount > 0, "User has no dividends");
        user.checkpoint = uint256(block.timestamp);
        payable(msg.sender).transfer(totalAmount);
        totalWithdrawn = totalWithdrawn.add(totalAmount);
        emit Withdrawn(msg.sender, totalAmount, total_USD_Amount);
    }

    function invest(address payable userRefAddress) public payable {
        address payable referrer;
        uint256 _amount = msg.value;
        uint256 usdPrice = getLatestPrice();
        uint256 usdAmount = usdPrice.mul(_amount).div(1e18);

        if (userRefAddress == address(0)) {
            userRefAddress = payable(contractAddress);
        }

        address upline = getUplinePartner();
        if (upline == address(0)) {
            referrer = userRefAddress;
            setUplinePartner(userRefAddress);
        } else {
            referrer = payable(upline);
        }

        require(msg.sender == tx.origin, "tx origin = msg.sender");
        require(
            usdAmount >= INVEST_MIN_AMOUNT && usdAmount <= INVEST_MAX_AMOUNT,
            "Invest amount must be between $1 and $1.000.000"
        );

        User storage user = users[msg.sender];

        require(
            user.deposits.length < DEPOSITS_MAX,
            "Maximum 300 deposits from address"
        );

        if (user.deposits.length == 0) {
            user.referrer = referrer;
        }

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
        if (
            user.checkpoint != 0 && getUserTotalActiveDeposits(msg.sender) == 0
        ) {
            user.checkpoint = uint256(block.timestamp);
        }
        if (user.referrer == contractAddress) {
            missedAmount = _amount.mul(22).div(100);
        } else {
            for (uint256 i = 0; i < 12; i++) {
                uint256 amount = _amount.mul(NECESSARIES[i].percent).div(
                    PERCENTS_DIVIDER
                );
                if (amount > 0) {
                    if (referrer != address(0)) {
                        if (
                            getUserAffiliateDepth(referrer) >= i &&
                            users[referrer].bonus <
                            uint256(getUserTotalDeposits(referrer)).mul(
                                NECESSARIES[i].affiliateMultiple
                            )
                        ) {
                            referrer.transfer(amount);
                            users[referrer].bonus = uint256(
                                uint256(users[referrer].bonus).add(amount)
                            );
                            users[referrer].usd_bonus = uint256(
                                uint256(users[referrer].usd_bonus).add(amount)
                            );
                            emit RefBonus(referrer, msg.sender, i, amount);
                        } else {
                            missedAmount += amount;
                            users[referrer].totalMissedAmount += amount;

                            emit RefBonusMissed(
                                referrer,
                                msg.sender,
                                i,
                                amount
                            );
                        }

                        users[referrer].refs[i]++;
                        users[referrer].totalTeamInvest += _amount;
                        referrer = payable(users[referrer].referrer);
                    } else {
                        missedAmount += amount;
                    }
                }
            }
        }

        if (missedAmount > 0) {
            uint256 sendingAmount = missedAmount.div(2);
            nAddress1.transfer(sendingAmount);
            nAddress2.transfer(sendingAmount);
        }
        uint256 _useractivedeposit = getUserTotalActiveDeposits(msg.sender);
        uint256 _useractiveusddeposit = getUserTotalUsdActiveDeposits(
            msg.sender
        );
        if (_useractivedeposit == 0 || _useractiveusddeposit == 0) {
            user.checkpoint = uint256(block.timestamp);
        }
        if (user.deposits.length == 0) {
            user.checkpoint = uint256(block.timestamp);
            users[user.referrer].firstLineCount += 1;
            emit Newbie(msg.sender);
            investorsCount.push(msg.sender);
        }

        user.deposits.push(
            Deposit(
                uint256(_amount),
                0,
                uint256(block.timestamp),
                usdAmount,
                0,
                true
            )
        );
        user.totalDepositAmount += uint256(_amount);
        user.totalUsdDepositAmount += uint256(usdAmount);

        totalInvestAmount += uint256(_amount);
        totalInvestCount++;

        emit NewDeposit(msg.sender, _amount, usdAmount);
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

    function getSiteStats()
        public
        view
        returns (uint256, uint256, uint256, uint256, uint256)
    {
        return (
            totalInvestAmount,
            totalInvestCount,
            contractAddress.balance,
            contractPercent,
            getContractTradeProfit()
        );
    }

    function setContractAddress(address addr) public onlyOwner {
        contractAddress = payable(addr);
    }

    function getContractAddress() public view returns (address) {
        return contractAddress;
    }

    function getUserDepositStats(
        address userAddress
    )
        public
        view
        returns (uint256, uint256, uint256, uint256, Deposit[] memory)
    {
        return (
            getUserTotalDeposits(userAddress),
            getUserUsdTotalDeposits(userAddress),
            getUserTotalUsdActiveDeposits(userAddress),
            getUserCountOfDeposits(userAddress),
            getUserDeposits(userAddress)
        );
    }

    function getAccountStats(
        address userAddress
    ) public view returns (uint256, uint256) {
        return (getUserPercentRate(userAddress), getUserAvailable(userAddress));
    }

    function getUserWithdrawStats(
        address userAddress
    ) public view returns (uint256, uint256) {
        return (
            getUserTotalWithdrawn(userAddress),
            getUserTotalUsdWithdrawn(userAddress)
        );
    }

    function getUserReferralsStats(
        address userAddress
    )
        public
        view
        returns (
            address,
            uint256,
            uint256,
            uint256,
            uint24[12] memory,
            uint256,
            uint256
        )
    {
        User storage user = users[userAddress];
        return (
            user.referrer,
            user.bonus,
            user.usd_bonus,
            user.firstLineCount,
            user.refs,
            getuserTotalTeamCount(userAddress),
            getuserTotalTeamInvest(userAddress)
        );
    }

    function getUserPercentRate(
        address userAddress
    ) private view returns (uint256) {
        User storage user = users[userAddress];
        if (
            isActive(userAddress) && getUserTotalActiveDeposits(userAddress) > 0
        ) {
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
        uint256 multiplier = 2;
        for (uint256 i = 0; i < user.deposits.length; i++) {
            if (
                uint256(user.deposits[i].withdrawn) <
                uint256(user.deposits[i].amount).mul(multiplier)
            ) {
                if (
                    uint256(user.deposits[i].usd_withdrawn) <
                    uint256(user.deposits[i].usd_amount).mul(multiplier)
                ) {
                    if (user.deposits[i].start > user.checkpoint) {
                        dividends = (
                            uint256(user.deposits[i].amount)
                                .mul(userPercentRate)
                                .div(PERCENTS_DIVIDER)
                        )
                            .mul(
                                block.timestamp.sub(
                                    uint256(user.deposits[i].start)
                                )
                            )
                            .div(TIME_STEP);
                    } else {
                        dividends = (
                            uint256(user.deposits[i].amount)
                                .mul(userPercentRate)
                                .div(PERCENTS_DIVIDER)
                        )
                            .mul(block.timestamp.sub(uint256(user.checkpoint)))
                            .div(TIME_STEP);
                    }

                    if (
                        uint256(user.deposits[i].withdrawn).add(dividends) >
                        uint256(user.deposits[i].amount).mul(multiplier)
                    ) {
                        dividends = (
                            uint256(user.deposits[i].amount).mul(multiplier)
                        ).sub(uint256(user.deposits[i].withdrawn));
                    }

                    totalDividends = totalDividends.add(dividends);
                }
            }
        }

        return totalDividends;
    }

    function setUplinePartner(address uplinePartner) private {
        address walletAddress = msg.sender;
        if (uplinePartner == address(0)) {
            uplinePartner = contractAddress;
        }
        require(
            walletAddress != uplinePartner,
            "Cannot set self as upline partner"
        );
        require(
            uplinePartners[walletAddress] == address(0),
            "Upline partner already set"
        );
        if (isActive(uplinePartner)) {
            uplinePartners[walletAddress] = uplinePartner;
        } else {
            uplinePartners[walletAddress] = contractAddress;
        }

        emit UplinePartnerSet(walletAddress, uplinePartner);
    }

    function getUplinePartner() private view returns (address) {
        return uplinePartners[msg.sender];
    }

    function getUserCountOfDeposits(
        address userAddress
    ) private view returns (uint256) {
        return users[userAddress].deposits.length;
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

    function getUserUsdTotalDeposits(
        address userAddress
    ) private view returns (uint256) {
        User storage user = users[userAddress];

        uint256 usd_amount;

        for (uint256 i = 0; i < user.deposits.length; i++) {
            usd_amount = usd_amount.add(uint256(user.deposits[i].usd_amount));
        }

        return usd_amount;
    }

    function getUserTotalActiveDeposits(
        address userAddress
    ) private view returns (uint256) {
        User storage user = users[userAddress];

        uint256 amount;

        for (uint256 i = 0; i < user.deposits.length; i++) {
            if (user.deposits[i].active) {
                amount = amount.add(uint256(user.deposits[i].amount));
            }
        }

        return amount;
    }

    function getUserTotalUsdActiveDeposits(
        address userAddress
    ) private view returns (uint256) {
        User storage user = users[userAddress];

        uint256 usd_amount;

        for (uint256 i = 0; i < user.deposits.length; i++) {
            if (user.deposits[i].active) {
                usd_amount = usd_amount.add(
                    uint256(user.deposits[i].usd_amount)
                );
            }
        }

        return usd_amount;
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

    function getUserTotalUsdWithdrawn(
        address userAddress
    ) private view returns (uint256) {
        User storage user = users[userAddress];
        uint256 usd_amount = user.usd_bonus;
        for (uint256 i = 0; i < user.deposits.length; i++) {
            usd_amount = usd_amount.add(
                uint256(user.deposits[i].usd_withdrawn)
            );
        }
        return usd_amount;
    }

    function getUserDeposits(
        address userAddress
    ) public view returns (Deposit[] memory) {
        User memory user = users[userAddress];
        Deposit[] memory depositArray = new Deposit[](user.deposits.length);

        for (uint256 i = 0; i < user.deposits.length; i++) {
            depositArray[i] = Deposit(
                uint256(user.deposits[i].amount),
                uint256(user.deposits[i].withdrawn),
                uint256(user.deposits[i].start),
                uint256(user.deposits[i].usd_amount),
                uint256(user.deposits[i].usd_withdrawn),
                bool(user.deposits[i].active)
            );
        }

        return depositArray;
    }

    function getContractTradeProfit() private view returns (uint256) {
        uint256 userCount = investorsCount.length;
        uint256 amount = 0;
        for (uint256 i = 0; i < userCount; i++) {
            User storage user = users[investorsCount[i]];
            uint256 depositCount = user.deposits.length;
            for (uint256 a = 0; a < depositCount; a++) {
                Deposit storage deposit = user.deposits[a];
                if (!deposit.active) {
                    if (
                        uint256(deposit.withdrawn) <
                        uint256(deposit.amount.mul(2))
                    ) {
                        amount += deposit.amount.mul(2).sub(deposit.withdrawn);
                    }
                }
            }
        }
        return amount;
    }

    function getuserTotalTeamCount(
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

    function getUserAffiliateDepth(
        address userAddress
    ) private view returns (uint256 depth) {
        depth = 0;
        for (uint24 i = 0; i < 12; i++) {
            if (
                uint256(getUserTotalUsdActiveDeposits(userAddress)) >=
                NECESSARIES[i].requiredAmount &&
                users[userAddress].firstLineCount >=
                NECESSARIES[i].requiredFirstLineCount
            ) {
                depth = i;
            }
        }
    }

    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }
}
