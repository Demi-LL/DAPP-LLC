<template>
  <div class="container">
    <div class="row">
      <div class="container col-xs-12 col-sm-8 col-sm-push-2">
        <h1 class="text-center">ERC20 錢包</h1>
        <hr />
        <br />
      </div>
    </div>
    <div class="row">
      <div class="container col-sm-8 col-sm-push-4 col-md-6 col-md-push-6">
        <div class="row gap-2 mb-3">
          <h4 class="col">錢包餘額：</h4>
          <span class="col">{{ formatBalance }}</span>
        </div>
        <div class="row gap-2 mb-3">
          <h4>轉帳</h4>
          <input type="text" class="form-control" placeholder="轉帳對象地址" />
          <input type="text" class="form-control" placeholder="轉帳金額 (LLC)" />
          <button class="btn btn-primary" id="transferButton" type="button">發送</button>
        </div>
        <div class="row gap-2 mb-3">
          <h4>鑄造 LLC</h4>
          <input type="text" class="form-control" placeholder="鑄造發送對象地址" />
          <input type="text" class="form-control" placeholder="鑄造金額 (LLC)" />
          <button class="btn btn-primary" id="mintButton" type="button">鑄造</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap";

import Web3 from "web3";

export default {
  name: "Index",
  data() {
    return {
      balance: 0,
      decimals: 18,
      web3: null,
    };
  },
  async created() {
    // 取得網頁上的 web3 物件，若無法取得，預設抓取 ganache 上的資料，取得型別為陣列，需要再解析
    this.web3 = typeof window.web3 !== "undefined" ? new Web3(window.web3.currentProvider) : new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
    console.log(window.ethereum);
    console.log(await this.web3.eth.getAccounts());
  },
  computed: {
    formatBalance() {
      return this.balance.toFixed(this.decimals);
    },
  },
  methods: {
    isAddress(address) {
      return this.web3.isAddress(address);
    },
  },
};
</script>
