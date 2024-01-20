import Head from "next/head";
import Image from "next/image";
import { Inter } from "@next/font/google";
import styles from "@/styles/Home.module.css";
import Link from "next/link";
import AssetCard from "@/components/assets/AssetCard";
import { useContext, useEffect, useState } from "react";
import AppContext from "@/contexts/AppContext";
import { CONTRACT_ABI, CONTRACT_ADDRESS } from "@/constants";
import { ethers } from "ethers";
import { notify } from "@/utils/helpers";
import { useContract, useContractRead } from "@thirdweb-dev/react";
import moment from "moment";

export default function Home({ address }) {
  const toWei = (ether) => ethers.utils.parseEther(ether);
  const toEther = (wei) => ethers.utils.formatEther(wei);

  // Stateler

  const [totalInvest, setTotalInvest] = useState(0.0);
  const [totalInvestCount, setTotalInvestCount] = useState(0);
  const [contractBalance, setContractBalance] = useState(0);
  const [deposits, setDeposits] = useState([]);

  const { contract } = useContract(CONTRACT_ADDRESS);
  const { data: isActive, isLoading: isActiveLoading } = useContractRead(
    contract,
    "isActive",
    [address]
  );
  const { data: totalInvestAmount, isLoading: totalInvestLoading } =
    useContractRead(contract, "totalInvestAmount");
  const { data: totalInvestCnt, isLoading: totalInvestCountLoading } =
    useContractRead(contract, "totalInvestCount");

  useEffect(() => {
    if (!totalInvestLoading) setTotalInvest(toEther(totalInvestAmount._hex));
  }, [totalInvestLoading]);

  useEffect(() => {
    if (!totalInvestCountLoading) {
      setTotalInvestCount(parseInt(totalInvestCnt._hex));
      contract
        .call("getContractBalance")
        .then((res) => setContractBalance(toEther(res._hex)))
        .catch(console.log);
    }
  }, [totalInvestCountLoading]);
  useEffect(() => {
    if (!isActiveLoading && isActive) {
      contract
        .call("getUserStats", [address])
        .then(async (response) => {
          let depositCount = parseInt(response[3]._hex, 16);
          let userDeposits = await contract.call("getUserDeposits", [
            address,
            0,
            depositCount,
          ]);
          let array = [];
          for (let i = 0; i < depositCount; i++) {
            array.push({
              amount: toEther(userDeposits[0][i]._hex),
              withdraw: toEther(userDeposits[1][i]._hex),
              start: moment(parseInt(userDeposits[3][i]._hex, 16)).format(
                "lll"
              ),
            });
          }
          // setDeposits(array);
          console.log(array);
        })
        .catch(console.log);
    }
  }, [isActiveLoading]);

  return (
    <div>
      <div className="w-full md:max-w-3xl mb-20 mx-auto">
        <p className="font-bold tracking-widest text-transparent text-sm mt-2 mb-12 uppercase bg-clip-text bg-gradient-to-r from-[#ffd900] to-[#39FF14] text-center md:mb-2 md:mt-18">
          POLYGON
        </p>
        <p className="p-2 text-5xl text-center font-black leading-snug md:text-6xl bg-clip-text text-white">
          Total Invest1 : {totalInvest}
          <br />
          Contract Balance : {contractBalance}
          <br />
          Referral Earning : {totalInvest * 0.22}
          <br />
          Total Invest Count : {totalInvestCount}
        </p>
        <p className="tracking-widest text-xg mt-12 text-center font-thin md:text-lg md:mt-10 animate-text bg-clip-text text-transparent bg-gradient-to-r from-sky-200 via-blue-500 to-blue-700">
          Maticlerinizi Arttırın. :
        </p>

        {/* call to action */}
        <div className="flex w-full mt-24 justify-center items-center space-x-4">
          <Link
            href="/stake"
            className="bg-gradient-to-br from-[#0047ff] to-[#57048a] px-10 py-3 rounded-full text-white font-black hover:bg-red-300">
            Yatırım&apos;a Başla
          </Link>
          <Link
            href="/about"
            className="bg-transparent border-2 border-white px-10 py-3 rounded-full text-white font-black">
            Daha Fazla Öğren
          </Link>
        </div>
      </div>

      {/* Portfolio */}
      <div className="w-full z-10 top-0 bg-transparent md:w-10/12 md:mx-auto">
        <p className="text-3xl text-white mb-12 md:text-3xl">Paketlerim</p>

        <div className="text-white text-center">Aktif Paket Yok</div>
      </div>
    </div>
  );
}
