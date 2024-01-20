import React from "react";

function About() {
  return (
    <div>
      <h4 className="text-2xl font-bold mb-12 text-white">
        <span className="text-lime-500 underline">MaticFundAI</span> hakkında
        bilgiler
      </h4>
      <p className="text-white font-normal mb-3 justify-items-stretch">
        MATIC varlıklarınızdan pasif gelir elde etmek için mükemmel bir platform
        olan yeni kripto stake dApp&apos;ımız MaticFundAI&apos;ı tanıtın. DApp,
        kullanıcıların MATIC&apos;i seçilen bir süre boyunca stake etmelerine ve
        yatırımlarından yüksek bir yıllık yüzde getiri (APY) kazanmalarına
        olanak tanır.
      </p>
      <p className="text-white font-normal mb-3 justify-items-stretch">
        Kullanıcılar MATIC&apos;lerini çeşitli süre seçeneklerinden kolayca
        stake edebilirler. Staking süresinin tamamlanmasının ardından,
        kullanıcılar stake ettikleri MATIC&apos;i kazanılan faizle birlikte iade
        etmek için pozisyonlarını kapatabilirler. Ancak, bir kullanıcı seçilen
        sürenin sona ermesinden önce pozisyonunu kapatırsa, yatırımlarından
        kazanılan herhangi bir faiz almayacaktır.{" "}
      </p>
      <p className="text-white font-normal mb-3 justify-items-stretch">
        DApp&apos;ımız, yatırılan fonlarınızı güvende ve erişilebilir tutmak
        için güvenli ve güvenilir bir akıllı sözleşme kullanır. Kullanıcı dostu
        arayüzümüzle, herkes MATIC varlıklarından pasif gelir elde etmeye
        başlayabilir.{" "}
      </p>
      <p className="text-white font-normal mb-3 justify-items-stretch">
        Bugün başlayın ve yatırımınızdan yüksek bir APY kazanmaya başlayın!
      </p>
      <p className="text-white font-normal mb-3 justify-items-stretch">
        <span className="text-lime-500">
          <b>Not:</b>
        </span>{" "}
        APY oranı ve mevcut süre seçenekleri mevcut piyasa koşullarına bağlı
        olarak değişebilir, bu nedenle para yatırmadan önce dApp&apos;ı kontrol
        etmeniz önerilir.
      </p>
    </div>
  );
}

export default About;
