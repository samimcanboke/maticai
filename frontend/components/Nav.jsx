import Link from "next/link";
import React, { useEffect, useState } from "react";
import Image from "next/image";

import { RiMoonFill } from "react-icons/ri";
import { useIsMounted } from "../hooks/useIsMounted";
import { ConnectWallet } from "@thirdweb-dev/react";
import { useAddress, useDisconnect } from "@thirdweb-dev/react";

import MobileMenu from "./MobileMenu";
import ThemeChanger from "./ThemeChanger";

function Nav() {
  const mounted = useIsMounted();
  const address = useAddress();
  const disconnect = useDisconnect();

  useEffect(() => {}, []);

  return (
    <>
      <nav
        id="header"
        className="w-full z-10 top-0 bg-transparent relative pt-6 pb-12 md:w-10/12 md:mx-auto">
        <div className="flex justify-between items-center">
          <Image
            src="https://placehold.co/80x80"
            alt="Picture of the author"
            width={80}
            height={80}
          />
          <div className="flex justify-center items-center font-semibold space-x-2 hidden md:block">
            <Link href="/" className="text-white text-lg font-bold px-4">
              Ana Sayfa
            </Link>
            <Link href="/stake" className="text-white text-lg font-bold px-4">
              Yatırım
            </Link>
            <Link href="/tiers" className="text-white text-lg font-bold px-4">
              Paketler
            </Link>
          </div>

          <div className="flex items-center justify-center cursor-pointer space-x-2">
            {/* Toggle Theme Button */}
            <div className="flex justify-center items-center py-1 px-2">
              <ThemeChanger />
            </div>

            {/* Connection Status */}
            {address ? (
              <button onClick={disconnect}>{address}</button>
            ) : (
              <ConnectWallet theme={"dark"} modalSize={"wide"} />
            )}

            {/* Mobile Menu */}
            <div className="ml-2 md:hidden pt-6">
              <MobileMenu />
            </div>
          </div>
        </div>
      </nav>
    </>
  );
}

export default Nav;
