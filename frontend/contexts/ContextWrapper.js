import { CONTRACT_ABI, CONTRACT_ADDRESS } from "@/constants";
import { useCallback, useState } from "react";
import AppContext from "./AppContext";

export function ContextWrapper({ children }) {
  const [testValue] = useState();

  return (
    <AppContext.Provider
      value={{
        testValue,
      }}>
      {children}
    </AppContext.Provider>
  );
}
