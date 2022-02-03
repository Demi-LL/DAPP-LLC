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
// 取得網頁上的 web3 物件，若無法取得，預設抓取 ganache 上的資料，取得型別為陣列，需要再解析
app.config.globalProperties.$web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
// typeof window.ethereum !== "undefined" ? new Web3(window.ethereum) : new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

assertor.vm = app;
app.config.globalProperties.$assertor = assertor;
app.config.globalProperties.$transfer = transfer;
app.config.globalProperties.$formatter = formatter;

app.use(router).mount("#app");
