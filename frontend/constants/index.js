export const CONTRACT_ADDRESS = "0xf6FFcf2f006615E53681CE8AE0A39129DA824B95";
export const CONTRACT_ABI = [
  {
    type: "constructor",
    name: "",
    inputs: [
      {
        type: "address",
        name: "marketingAddr",
        internalType: "address payable",
      },
      {
        type: "address",
        name: "projectAddr",
        internalType: "address payable",
      },
      {
        type: "address",
        name: "devAddr",
        internalType: "address payable",
      },
      {
        type: "address",
        name: "_defaultAdress",
        internalType: "address payable",
      },
      {
        type: "address",
        name: "_nAddress1",
        internalType: "address payable",
      },
      {
        type: "address",
        name: "_nAddress2",
        internalType: "address payable",
      },
    ],
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "event",
    name: "FeePayed",
    inputs: [
      {
        type: "address",
        name: "user",
        indexed: true,
        internalType: "address",
      },
      {
        type: "uint256",
        name: "totalAmount",
        indexed: false,
        internalType: "uint256",
      },
    ],
    outputs: [],
    anonymous: false,
  },
  {
    type: "event",
    name: "NewDeposit",
    inputs: [
      {
        type: "address",
        name: "user",
        indexed: true,
        internalType: "address",
      },
      {
        type: "uint256",
        name: "amount",
        indexed: false,
        internalType: "uint256",
      },
    ],
    outputs: [],
    anonymous: false,
  },
  {
    type: "event",
    name: "Newbie",
    inputs: [
      {
        type: "address",
        name: "user",
        indexed: false,
        internalType: "address",
      },
    ],
    outputs: [],
    anonymous: false,
  },
  {
    type: "event",
    name: "RefBack",
    inputs: [
      {
        type: "address",
        name: "referrer",
        indexed: true,
        internalType: "address",
      },
      {
        type: "address",
        name: "referral",
        indexed: true,
        internalType: "address",
      },
      {
        type: "uint256",
        name: "amount",
        indexed: false,
        internalType: "uint256",
      },
    ],
    outputs: [],
    anonymous: false,
  },
  {
    type: "event",
    name: "RefBonus",
    inputs: [
      {
        type: "address",
        name: "referrer",
        indexed: true,
        internalType: "address",
      },
      {
        type: "address",
        name: "referral",
        indexed: true,
        internalType: "address",
      },
      {
        type: "uint256",
        name: "level",
        indexed: true,
        internalType: "uint256",
      },
      {
        type: "uint256",
        name: "amount",
        indexed: false,
        internalType: "uint256",
      },
    ],
    outputs: [],
    anonymous: false,
  },
  {
    type: "event",
    name: "RefBonusMissed",
    inputs: [
      {
        type: "address",
        name: "referrer",
        indexed: true,
        internalType: "address",
      },
      {
        type: "address",
        name: "referral",
        indexed: true,
        internalType: "address",
      },
      {
        type: "uint256",
        name: "level",
        indexed: true,
        internalType: "uint256",
      },
      {
        type: "uint256",
        name: "amount",
        indexed: false,
        internalType: "uint256",
      },
    ],
    outputs: [],
    anonymous: false,
  },
  {
    type: "event",
    name: "UplinePartnerSet",
    inputs: [
      {
        type: "address",
        name: "walletAddress",
        indexed: true,
        internalType: "address",
      },
      {
        type: "address",
        name: "uplinePartner",
        indexed: true,
        internalType: "address",
      },
    ],
    outputs: [],
    anonymous: false,
  },
  {
    type: "event",
    name: "Withdrawn",
    inputs: [
      {
        type: "address",
        name: "user",
        indexed: true,
        internalType: "address",
      },
      {
        type: "uint256",
        name: "amount",
        indexed: false,
        internalType: "uint256",
      },
    ],
    outputs: [],
    anonymous: false,
  },
  {
    type: "function",
    name: "DEPOSITS_MAX",
    inputs: [],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "Dev_Fee",
    inputs: [],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "INVEST_MAX_AMOUNT",
    inputs: [],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "INVEST_MIN_AMOUNT",
    inputs: [],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "MARKETING_FEE",
    inputs: [],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "MAX_HOLD_PERCENT",
    inputs: [],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "PERCENTS_DIVIDER",
    inputs: [],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "PROJECT_FEE",
    inputs: [],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "TIME_STEP",
    inputs: [],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "contractAddress",
    inputs: [],
    outputs: [
      {
        type: "address",
        name: "",
        internalType: "address",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "contractCreationTime",
    inputs: [],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "contractPercent",
    inputs: [],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "defaultAddress",
    inputs: [],
    outputs: [
      {
        type: "address",
        name: "",
        internalType: "address payable",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "devAdress",
    inputs: [],
    outputs: [
      {
        type: "address",
        name: "",
        internalType: "address payable",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "getContractAddress",
    inputs: [],
    outputs: [
      {
        type: "address",
        name: "",
        internalType: "address",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "getContractBalance",
    inputs: [],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "getSiteStats",
    inputs: [],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "getTotalDepositAmount",
    inputs: [
      {
        type: "address",
        name: "userAddress",
        internalType: "address",
      },
    ],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "getTotalMissedAmount",
    inputs: [
      {
        type: "address",
        name: "userAddress",
        internalType: "address",
      },
    ],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "getUplinePartner",
    inputs: [],
    outputs: [
      {
        type: "address",
        name: "",
        internalType: "address",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "getUserDeposits",
    inputs: [
      {
        type: "address",
        name: "userAddress",
        internalType: "address",
      },
      {
        type: "uint256",
        name: "last",
        internalType: "uint256",
      },
      {
        type: "uint256",
        name: "first",
        internalType: "uint256",
      },
    ],
    outputs: [
      {
        type: "uint256[]",
        name: "",
        internalType: "uint256[]",
      },
      {
        type: "uint256[]",
        name: "",
        internalType: "uint256[]",
      },
      {
        type: "uint256[]",
        name: "",
        internalType: "uint256[]",
      },
      {
        type: "uint256[]",
        name: "",
        internalType: "uint256[]",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "getUserLastDeposit",
    inputs: [
      {
        type: "address",
        name: "userAddress",
        internalType: "address",
      },
    ],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "getUserReferralsStats",
    inputs: [
      {
        type: "address",
        name: "userAddress",
        internalType: "address",
      },
    ],
    outputs: [
      {
        type: "address",
        name: "",
        internalType: "address",
      },
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
      {
        type: "uint24[12]",
        name: "",
        internalType: "uint24[12]",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "getUserStats",
    inputs: [
      {
        type: "address",
        name: "userAddress",
        internalType: "address",
      },
    ],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "invest",
    inputs: [
      {
        type: "address",
        name: "userRefAddress",
        internalType: "address payable",
      },
    ],
    outputs: [],
    stateMutability: "payable",
  },
  {
    type: "function",
    name: "isActive",
    inputs: [
      {
        type: "address",
        name: "userAddress",
        internalType: "address",
      },
    ],
    outputs: [
      {
        type: "bool",
        name: "",
        internalType: "bool",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "marketingAddress",
    inputs: [],
    outputs: [
      {
        type: "address",
        name: "",
        internalType: "address payable",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "nAddress1",
    inputs: [],
    outputs: [
      {
        type: "address",
        name: "",
        internalType: "address payable",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "nAddress2",
    inputs: [],
    outputs: [
      {
        type: "address",
        name: "",
        internalType: "address payable",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "owner",
    inputs: [],
    outputs: [
      {
        type: "address",
        name: "",
        internalType: "address",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "projectAddress",
    inputs: [],
    outputs: [
      {
        type: "address",
        name: "",
        internalType: "address payable",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "setContractAddress",
    inputs: [
      {
        type: "address",
        name: "addr",
        internalType: "address",
      },
    ],
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    name: "totalInvestAmount",
    inputs: [],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "totalInvestCount",
    inputs: [],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "totalWithdrawn",
    inputs: [],
    outputs: [
      {
        type: "uint256",
        name: "",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "uplinePartners",
    inputs: [
      {
        type: "address",
        name: "",
        internalType: "address",
      },
    ],
    outputs: [
      {
        type: "address",
        name: "",
        internalType: "address",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "withdraw",
    inputs: [],
    outputs: [],
    stateMutability: "nonpayable",
  },
];
