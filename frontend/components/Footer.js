import Link from "next/link";
import React from "react";
import {
  BsFacebook,
  BsTwitter,
  BsYoutube,
  BsLinkedin,
  BsArrowUp,
  BsGithub,
} from "react-icons/bs";

function Footer() {
  return (
    <div className="w-full h-full md:w-10/12 py-20 mx-auto bg-transparent space-y-5">
      <div className="flex justify-center items-center space-x-6">
        <div className="p-2 border border-stake-700 rounded-md">
          <Link href="#" target="_blank">
            <BsGithub className="text-gray-300 cursor-pointer" size={18} />
          </Link>
        </div>
        <div className="p-2 border border-stake-700 rounded-md">
          <a href="#" target="_blank">
            <BsFacebook className="text-gray-300 cursor-pointer" size={18} />
          </a>
        </div>
        <div className="p-2 border border-stake-700 rounded-md">
          <Link href="#">
            <BsLinkedin className="text-gray-300 cursor-pointer" size={18} />
          </Link>
        </div>
        <div className="p-2 border border-stake-700 rounded-md">
          <Link href="#">
            <BsTwitter className="text-gray-300 cursor-pointer" size={18} />
          </Link>
        </div>
      </div>
      <div className="flex justify-center items-center space-x-6 text-gray-300">
        <div className="p-2 cursor-pointer">
          <Link href="/">Ana Sayfa</Link>
        </div>
        <div className="p-2 cursor-pointer">
          <Link href="/about">Hakkında</Link>
        </div>
        <div className="p-2 cursor-pointer">
          <Link href="/stake">Yatırım</Link>
        </div>
        <div className="p-2 cursor-pointer">
          <Link href="/tiers">Paketler</Link>
        </div>
      </div>
      <div className="flex justify-center items-center space-x-6 text-gray-300">
        <p className="text-center text-gray-300 text-sm">
          ©2023 MaticFundAI Sotfware Team
        </p>
      </div>
      <div className="flex justify-center items-center space-x-6 text-white pt-20">
        <div className="cursor-pointer p-2 border border-lime-500 rounded-md hover:bg-stake-700">
          <BsArrowUp
            onClick={() => {
              window.scrollTo({ top: 0, left: 0, behavior: "smooth" });
            }}
            className="text-white"
            size={20}
          />
        </div>
      </div>
    </div>
  );
}

export default Footer;
