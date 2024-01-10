import Link from "next/link";
import React from "react";
import { HiMenuAlt3 } from "react-icons/hi";

function MobileMenu() {
  return (
    <div className="flex items-end justify-end pb-6">
      <button className="relative z-30 lg:hidden peer transition">
        <HiMenuAlt3 color="#FFF" size="38px" />
      </button>

      <div className="z-20 fixed top-0 -left-96 lg:left-0 h-screen w-7/12 lg:w-72 bg-black/70 shadow-2xl peer-focus:left-0 peer:transition ease-out delay-300 duration-200 backdrop-blur-md">
        <nav role="navigation" className="p-6">
          <div className="mt-4 -mx-4 relative overflow-y-auto overflow-x-hidden h-[85vh] space-y-20">
            <span className="uppercase px-4 text-xl text-lime-500">Menu</span>
            <ul className="space-y-7 mb-12 px-4 mt-8">
              <li>
                <Link
                  href="/"
                  className="flex text-white text-2xl font-bold hover:underline transition">
                  Ana Sayfa
                </Link>
              </li>
              <li>
                <Link
                  href="/stake"
                  className="flex text-white text-2xl font-bold hover:underline transition">
                  Yatırım
                </Link>
              </li>
              <li>
                <Link
                  href="/tiers"
                  className="flex text-white text-2xl font-bold hover:underline transition">
                  Paketler
                </Link>
              </li>
            </ul>
          </div>
        </nav>
      </div>

      <div className="z-10 lg:hidden fixed top-0 left-0 bg-gray-900 bg-opacity-30 opacity-0 peer-focus:opacity-100 peer:transition duration-200"></div>
    </div>
  );
}

export default MobileMenu;
