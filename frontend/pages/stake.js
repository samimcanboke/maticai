import React, { useEffect, useState } from "react";
import { ethers } from "ethers";

import { toEther, toWei, notify } from "../utils/helpers";
import { useRouter } from "next/router";
import { CONTRACT_ABI, CONTRACT_ADDRESS } from "../constants";
import {
  useAddress,
  useBalance,
  useContract,
  useContractWrite,
} from "@thirdweb-dev/react";
import { NATIVE_TOKEN_ADDRESS } from "@thirdweb-dev/sdk";
import {} from "@thirdweb-dev/react";

function Stake() {
  const address = useAddress();
  const [balance, setBalance] = useState(0);
  const [investAmount, setInvestAmount] = useState(0);
  const { data, isLoading } = useBalance(NATIVE_TOKEN_ADDRESS);
  const { contract } = useContract(
    "0x0FEc05d5326E18AE7aCD102b80c71132e115771A"
  );

  const { mutateAsync: invest } = useContractWrite(contract, "invest");

  useEffect(() => {
    if (address && !isLoading) {
      setBalance(data.displayValue);
    }
  }, [address, isLoading]);

  const investRate = (rate) => {
    if (rate == 100) {
      setInvestAmount((balance * (rate / 100) - 1).toFixed(4));
      return;
    }
    setInvestAmount((balance * (rate / 100)).toFixed(4));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const data = await invest({
        args: [
          toWei(investAmount),
          "0x0c938a95B2fd4250dDD273FF31357bA8E63dfbCC",
        ],
      });
      console.info("contract call successs", data);
    } catch (err) {
      console.error("contract call failure", err);
    }
  };

  return (
    <div className="w-full md:w-10/12 mb-20 mx-auto">
      <div className="flex flex-row flex-wrap">
        <div className="bg-[#272459]  p-10 w-full mb-4 md:w-2/3 rounded-[20px] md:mt-0 md:mb-4 md:p-16 md:space-y-4 dark:bg-dark-700 dark:border-dark-800">
          {address ? (
            <>
              <div>
                <p className="text-2xl text-white font-extrabold md:text-4xl md:my-4">
                  Stake MaticFund
                </p>
                <div className="flex flex-wrap justify-start items-center my-6">
                  <button
                    onClick={() => {
                      investRate(10);
                    }}
                    className="text-white font-bold px-3 py-2 mr-4 my-2 first:ml-0 border border-lime-500 rounded-lg hover:bg-[#19173f] md:px-5 md:py-3 bg-gradient-to-br from-lime-500 to-blue-500">
                    10 %
                  </button>
                  <button
                    onClick={() => {
                      investRate(25);
                    }}
                    className="text-white font-bold px-3 py-2 mr-4 my-2 first:ml-0 border border-lime-500 rounded-lg hover:bg-[#19173f] md:px-5 md:py-3 bg-gradient-to-br from-lime-500 to-blue-500">
                    25 %
                  </button>
                  <button
                    onClick={() => {
                      investRate(50);
                    }}
                    className="text-white font-bold px-3 py-2 mr-4 my-2 first:ml-0 border border-lime-500 rounded-lg hover:bg-[#19173f] md:px-5 md:py-3 bg-gradient-to-br from-lime-500 to-blue-500">
                    50 %
                  </button>
                  <button
                    onClick={() => {
                      investRate(75);
                    }}
                    className="text-white font-bold px-3 py-2 mr-4 my-2 first:ml-0 border border-lime-500 rounded-lg hover:bg-[#19173f] md:px-5 md:py-3 bg-gradient-to-br from-lime-500 to-blue-500">
                    75 %
                  </button>
                  <button
                    onClick={() => {
                      investRate(100);
                    }}
                    className="text-white font-bold px-3 py-2 mr-4 my-2 first:ml-0 border border-lime-500 rounded-lg hover:bg-[#19173f] md:px-5 md:py-3 bg-gradient-to-br from-lime-500 to-blue-500">
                    100 %
                  </button>
                </div>
              </div>

              {/* Staking info area */}
              <div className="flex justify-between items-center my-6">
                <div className="flex flex-col">
                  <p className="text-white my-2">
                    <span className="font-bold">Kilitleme Süresi:</span> 365 Gün
                  </p>
                </div>
                <div className="flex flex-col">
                  <p className="text-white text-right my-2 text-5xl font-bold">
                    200%
                  </p>
                  <p className="text-white text-right my-2">
                    Yatırımınızın 2 katı çekim yaptığınızda <br /> paketiniz
                    sonlanır.
                  </p>
                </div>
              </div>

              {/* Staking input */}
              <div className="my-6">
                <form>
                  <div className="w-full md:w-2/3 md:inline-block">
                    <input
                      onChange={(e) => setInvestAmount(e.target.value)}
                      className="w-full my-4 text-white text-md border border-white bg-transparent rounded-md p-3 hover:bg-[#19173f] focus:bg-[#19173f] focus:border-0 focus:outline-none focus-visible:outline-white"
                      type="text"
                      value={investAmount}
                    />
                  </div>
                  <div className="w-full md:w-1/3 md:inline-block">
                    <button
                      onClick={(e) => handleSubmit(e)}
                      className="w-full my-4 bg-gradient-to-br from-[#0047ff] to-[#57048a] px-10 py-4 rounded-xl text-white font-black hover:bg-red-300 md:ml-4">
                      Yatırım Yap
                    </button>
                  </div>
                  <div className="w-full md-w-3/3 md:inline-block">
                    <p className="text-base/6">
                      Cüzdanınızda komisyonlar için minimum ekstra 1 Matic
                      bırakmalısınız.
                    </p>
                  </div>
                </form>
              </div>
            </>
          ) : (
            <div className="text-white text-center text-2xl font-bold p-4 border rounded-xl">
              Connnect wallet to Stake
            </div>
          )}
        </div>
        <div className="flex-col w-full md:w-1/3">
          <div className="bg-[#272459] p-10 rounded-[20px] md:mt-0 mb-4 md:mr-0 md:ml-4 md:px-10 md:py-5 md:space-y-4 dark:bg-dark-700 dark:border-dark-800">
            <h4 className="text-lg mb-4 font-bold uppercase text-white">
              instructions
            </h4>
            <ol className="text-white text-md font-thin">
              <li>1. Select staking duration</li>
              <li>2. Enter amount to stake</li>
              <li>3. Stake! Easy!</li>
            </ol>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Stake;
