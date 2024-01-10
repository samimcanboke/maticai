import "@/styles/globals.css";

import {
  ThirdwebProvider,
  metamaskWallet,
  coinbaseWallet,
  walletConnect,
  localWallet,
  trustWallet,
} from "@thirdweb-dev/react";

import { ToastContainer, toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

import Nav from "@/components/Nav";
import Footer from "@/components/Footer";
import { ContextWrapper } from "@/contexts/ContextWrapper";

import { ThemeProvider } from "next-themes";

export default function App({ Component, pageProps }) {
  return (
    <ThirdwebProvider
      activeChain="mumbai"
      clientId="fbc8ef239a4b71e1216f0105723f6142"
      supportedWallets={[
        metamaskWallet(),
        walletConnect(),
        trustWallet({ recommended: true }),
      ]}>
      <ContextWrapper>
        <ThemeProvider enableSystem={true} attribute="class">
          <div className="w-full h-auto bg-stake-800 dark:bg-dark-800">
            <div className="w-11/12 mx-auto">
              <Nav />
              <Component {...pageProps} />
              <Footer />
              <ToastContainer
                position="bottom-right"
                autoClose={5000}
                hideProgressBar={false}
                newestOnTop={false}
                closeOnClick
                rtl={false}
                pauseOnFocusLoss
                draggable
                pauseOnHover
                theme="dark"
              />
            </div>
          </div>
        </ThemeProvider>
      </ContextWrapper>
    </ThirdwebProvider>
  );
}
