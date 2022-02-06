import router from "./router";
import { createApp } from "vue";

import Web3 from "web3";
import App from "./App.vue";

import assertor from "../libraries/assertor.js";
import transfer from "../libraries/transfer.js";
import formatter from "../libraries/formatter.js";
import "bootstrap";
import "bootstrap/dist/css/bootstrap.min.css";

const app = createApp(App);
// 取得網頁上的 web3 物件，若無法取得，預設抓取本機 ganache
if (typeof window.ethereum === "undefined") {
  app.config.globalProperties.$web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
} else {
  // 與 metamask 的連線需要授權，若未經過 enable() 的授權同意，狐狸錢包無法透過 web3.js 取得資料
  window.ethereum.enable();
  app.config.globalProperties.$web3 = new Web3(window.ethereum);
}

assertor.vm = app;
app.config.globalProperties.$assertor = assertor;
app.config.globalProperties.$transfer = transfer;
app.config.globalProperties.$formatter = formatter;

app.use(router).mount("#app");
