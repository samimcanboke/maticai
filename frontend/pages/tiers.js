import React from "react";

function Tiers() {
  return (
    <div className="w-full md:w-10/12 mb-20 mx-auto">
      <div className="flex flex-wrap">
        <div className="w-full md:w-4/12 bg-stake-700 text-center text-white my-3 p-6 h-auto border-8 border-dashed border-stake-800 rounded-4xl dark:bg-dark-700 dark:border-dark-800">
          <p className="text-2xl font-bold mb-6">Paket 1</p>
          <p className="text-lg font-semibold mb-8">Bronze</p>
          <p className="text-lg font-semibold mb-2 text-stake-500">
            Kilit Süresi
          </p>
          <p className="text-lg font-semibold mb-8">30 Gün</p>
          <p className="text-lg font-semibold mb-2 text-stake-500">
            Yıllık Yüzdesel Getiri
          </p>
          <p className="text-lg font-semibold mb-4">7%</p>
        </div>
        <div className="w-full md:w-4/12 bg-stake-700 text-center text-white my-3 p-6 h-96 border-8 border-dashed border-stake-800 rounded-4xl dark:bg-dark-700 dark:border-dark-800">
          <p className="text-2xl font-bold mb-6">Paket 2</p>
          <p className="text-lg font-semibold mb-8">Gümüş</p>
          <p className="text-lg font-semibold mb-2 text-stake-500">
            Kilit Süresi
          </p>
          <p className="text-lg font-semibold mb-8">90 Gün</p>
          <p className="text-lg font-semibold mb-2 text-stake-500">
            Yıllık Yüzdesel Getiri
          </p>
          <p className="text-lg font-semibold mb-4">10%</p>
        </div>
        <div className="w-full md:w-4/12 bg-stake-700 text-center text-white my-3 p-6 h-96 border-8 border-dashed border-stake-800 rounded-4xl dark:bg-dark-700 dark:border-dark-800">
          <p className="text-2xl font-bold mb-6">Paket 3</p>
          <p className="text-lg font-semibold mb-8">Altın</p>
          <p className="text-lg font-semibold mb-2 text-stake-500">
            Kilit Süresi
          </p>
          <p className="text-lg font-semibold mb-8">180 Gün</p>
          <p className="text-lg font-semibold mb-2 text-stake-500">
            Yıllık Yüzdesel Getiri
          </p>
          <p className="text-lg font-semibold mb-4">12%</p>
        </div>
      </div>
    </div>
  );
}

export default Tiers;
