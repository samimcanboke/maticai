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

export default function Home() {
  const toWei = (ether) => ethers.utils.parseEther(ether);
  const toEther = (wei) => ethers.utils.formatEther(wei);

  const calcDaysRemaining = (unlockDate) => {
    const timeNow = Date.now() / 1000;
    const secondsRemaining = unlockDate - timeNow;
    return Math.max((secondsRemaining / 60 / 60 / 24).toFixed(0), 0);
  };

  useEffect(() => {
    console.log("asd");
  }, []);

  return (
    <div>
      <div className="w-full md:max-w-3xl mb-20 mx-auto">
        <p className="font-bold tracking-widest text-transparent text-sm mt-2 mb-12 uppercase bg-clip-text bg-gradient-to-r from-[#ffd900] to-[#39FF14] text-center md:mb-2 md:mt-18">
          POLYGON
        </p>
        <p className="p-2 text-5xl text-center font-black leading-snug md:text-6xl bg-clip-text text-white">
          MaticFundAI Defi Yatırımları
        </p>
        <p className="tracking-widest text-xg mt-12 text-center font-thin md:text-lg md:mt-10 animate-text bg-clip-text text-transparent bg-gradient-to-r from-sky-200 via-blue-500 to-blue-700">
          Maticlerinizi Arttırın.
        </p>

        {/* call to action */}
        <div className="flex w-full mt-24 justify-center items-center space-x-4">
          <Link
            href="/stake"
            className="bg-gradient-to-br from-[#0047ff] to-[#57048a] px-10 py-3 rounded-full text-white font-black hover:bg-red-300">
            Yatırım'a Başla
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
