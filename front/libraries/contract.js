import * as contract from "@truffle/contract";
import contractInfo from "../../build/contracts/LLC.json";

const abi = contractInfo.abi;
const networks = contractInfo.networks;

export default contract({ abi, networks });
