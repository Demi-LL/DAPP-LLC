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
          <span class="col">{{ $formatter.balance($transfer.toWei(balance)) }}</span>
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
export default {
  name: "Index",
  data() {
    return {
      account: "",
      balance: 0,
    };
  },
  async created() {
    console.log("eth:", await this.$web3.eth.getAccounts());
    this.getAccount();
  },
  computed: {},
  watch: {
    account() {
      console.log("account: ", this.account);
      if (this.$assertor.isAddress(this.account)) {
        this.getBalance(this.account);
      }
    },
  },
  methods: {
    getAccount() {
      this.$web3.eth
        .getAccounts()
        .then((data) => (this.account = data[0]))
        .catch((err) => console.log("err:", err));
    },
    getBalance(account) {
      this.$web3.eth
        .getBalance(account)
        .then((data) => {
          console.log("bal:", data);
          this.balance = data;
        })
        .catch((err) => console.log("err:", err));
    },
  },
};
</script>
