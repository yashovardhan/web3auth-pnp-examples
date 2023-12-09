import React from "react";

import web3AuthLogoWhite from "../assets/web3authLogoWhite.svg";
import { useWeb3Auth } from "../services/web3auth";

const ConnectWeb3AuthButton = () => {
  const { provider, logout } = useWeb3Auth();

  if (provider) {
    return (
      <div
        className="flex flex-row rounded-full px-6 py-3 text-white justify-center align-center cursor-pointer"
        style={{ backgroundColor: "#0364ff" }}
        onClick={logout}
      >
        <img src={web3AuthLogoWhite} className="headerLogo" />
        Disconnect
      </div>
    );
  }
  return null;
};
export default ConnectWeb3AuthButton;
