import React from "react";
import { useLocation, useNavigate } from "react-router-dom";

import { useWeb3Auth } from "../services/web3auth";

interface DrawerProps {
  isOpen: boolean;
  setOpen: any;
}
const Drawer = ({ isOpen, setOpen }: DrawerProps) => {
  const { provider, user, logout, login } = useWeb3Auth();

  const navigate = useNavigate();
  function goToHome() {
    navigate("/");
  }
  function goToTransaction() {
    navigate("/transaction");
  }
  function goToContract() {
    navigate("/contract");
  }
  function goToNft() {
    navigate("/nft");
  }
  function goToServerSideVerification() {
    navigate("/server-side-verification");
  }
  const location = useLocation();
  function linktoGo(label: string, path: any) {
    return (
      <div
        onClick={() => path()}
        className="flex items-center px-4 py-2 mb-2 text-gray-500 rounded-lg hover:bg-gray-100 hover:text-primary  cursor-pointer"
      >
        <span className="text-sm font-normal">{label}</span>
      </div>
    );
  }
  function activePage(label: string) {
    return (
      <div className="flex items-center px-4 py-2 mb-2 rounded-lg bg-gray-100 text-primary  cursor-pointer">
        <span className="text-sm font-bold">{label}</span>
      </div>
    );
  }
  function userProfile() {
    if (provider) {
      try {
        return (
          <div className="sticky px-4 inset-x-0 bottom-0 border-t border-gray-100">
            <div className="flex items-center justify-flex-start py-4 shrink-0 overflow-hidden">
              <img className="object-cover w-10 h-10 rounded-full" src={user.profileImage} referrerPolicy="no-referrer" />

              <div className="ml-1.5">
                <p className="text-xs">
                  <strong className="block font-medium">{user.name as string}</strong>
                  <span>{user.email as string}</span>
                </p>
              </div>
            </div>
          </div>
        );
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  if (isOpen) {
    return (
      <div className="fixed flex w-full h-full  lg:hidden">
        <div onClick={() => setOpen(false)} className="w-full h-full bg-black/[.4]"></div>
        <div className="flex right-0 flex-col justify-between h-screen p-5 bg-white w-80">
          <div className="py-2">
            <strong className="px-4 block p-1 text-xs font-medium text-gray-400 uppercase">MENU</strong>
            <nav className="flex flex-col mt-6">
              {location.pathname === "/" ? activePage("Main Page") : linktoGo("Main Page", goToHome)}
              {location.pathname === "/transaction" ? activePage("Transactions") : linktoGo("Transactions", goToTransaction)}
              {location.pathname === "/contract" ? activePage("Smart Contract Interactions") : linktoGo("Smart Contract Interactions", goToContract)}
              {location.pathname === "/nft" ? activePage("NFT Interactions") : linktoGo("NFT Interactions", goToNft)}
              {location.pathname === "/server-side-verification"
                ? activePage("Server Side Verification")
                : linktoGo("Server Side Verification", goToServerSideVerification)}
              {provider ? (
                <div
                  onClick={() => {
                    setOpen(false);
                    logout();
                  }}
                  className="flex items-center px-4 py-2 mb-2 text-gray-500 rounded-lg hover:bg-gray-100 hover:text-primary  cursor-pointer"
                >
                  <span className="text-sm font-normal">Disconnect</span>
                </div>
              ) : (
                <div
                  onClick={() => {
                    setOpen(false);
                    login();
                  }}
                  className="flex items-center px-4 py-2 mb-2 rounded-lg bg-primary text-white hover:bg-gray-200 hover:text-primary cursor-pointer"
                >
                  <span className="text-sm font-bold">Connect to Web3Auth</span>
                </div>
              )}
            </nav>
          </div>
          {userProfile()}
        </div>
      </div>
    );
  }

  return null;
};

export default Drawer;
