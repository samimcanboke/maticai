import { CONTRACT_ABI, CONTRACT_ADDRESS } from "@/constants";
import { useCallback, useState } from "react";
import AppContext from "./AppContext";

export function ContextWrapper({ children }) {
  const [address, setAddress] = useState();

  return (
    <AppContext.Provider
      value={{
        address,
        setAddress,
      }}>
      {children}
    </AppContext.Provider>
  );
}
