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
          <h4 class="col">錢包位址：</h4>
          <span class="col">{{ account }}</span>
        </div>
        <div class="row gap-2 mb-3">
          <h4 class="col">錢包餘額：</h4>
          <span class="col">{{ $formatter.balance(balance) }}</span>
          <span class="col">({{ name }})</span>
        </div>
        <div class="row gap-2 mb-3">
          <h4>轉帳</h4>
          <input v-model="transferTo" type="text" class="form-control" placeholder="轉帳對象地址" />
          <input v-model="transferAmount" type="text" class="form-control" placeholder="轉帳金額 (LLC)" />
          <button @click="transfer()" class="container col-3 btn btn-primary" id="transferButton" type="button">發送</button>
        </div>
        <div class="row gap-2 mb-3">
          <h4>鑄造 {{ name }}</h4>
          <input v-model="mintTo" type="text" class="form-control" placeholder="鑄造發送對象地址" />
          <input v-model="mintAmount" type="text" class="form-control" placeholder="鑄造金額 (LLC)" />
          <button @click="mint()" class="container col-3 btn btn-primary" type="button">鑄造</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { inject } from "vue";

const GAS_LIMIT = 5500000
export default {
  name: "Index",
  setup() {
    return { contract: inject("contract") };
  },
  data() {
    return {
      name: "",
      account: "",
      balance: 0,
      transferTo: "",
      transferAmount: "",
      mintTo: "",
      mintAmount: "",
    };
  },
  async created() {
    this.contract.then((obj) => obj.name()).then((str) => (this.name = str));

    this.getAccount();
  },
  methods: {
    getAccount() {
      this.$web3.eth
        .getAccounts()
        .then((data) => (this.account = data[0]))
        .then(() => this.getBalance())
        .catch((err) => console.log("err:", err));
    },
    /**
     * 取得帳戶 LLC 餘額，單位為 wei
     */
    getBalance() {
      if (this.$assertor.isAddress(this.account)) {
        this.contract
          .then((obj) => obj.balanceOf(this.account))
          .then((balance) => (this.balance = this.$transfer.weiToDecimals(balance)))
          .catch((err) => console.log("err:", err));
      }
    },
    transfer() {
      if (!this.$assertor.isAddress(this.transferTo)) {
        return alert("請輸入正確的地址格式");
      }

      if (this.transferAmount <= 0) {
        return alert("請輸入正確的轉帳數量");
      }

      this.contract
        .then((obj) => obj.transfer(this.transferTo, this.$transfer.decimalsToWei(this.transferAmount), { from: this.account, gas: GAS_LIMIT }))
        .then(() => alert(`成功轉帳 ${this.transferAmount} 個 ${this.name}`))
        .then(() => this.getBalance())
        .catch((err) => alert(err));
    },
    mint() {
      if (!this.$assertor.isAddress(this.mintTo)) {
        return alert("請輸入正確的地址格式");
      }

      if (this.mintAmount <= 0) {
        return alert("請輸入正確的鑄造數量");
      }

      this.contract
        .then((obj) => obj.mint(this.mintTo, this.$transfer.decimalsToWei(this.mintAmount), { from: this.account, gas: GAS_LIMIT }))
        .then(() => alert(`成功鑄造 ${this.mintAmount} 個 ${this.name}`))
        .then(() => this.getBalance())
        .catch((err) => alert(err));
    },
    /**
     * 取得帳戶 ETH 餘額，單位為 wei
     */
    // getETHBalance(account) {
    //   this.$web3.eth
    //     .getBalance(account)
    //     .then((data) => {
    //       console.log("bal:", data);
    //       this.balance = data;
    //     })
    //     .catch((err) => console.log("err:", err));
    // },
  },
};
</script>
