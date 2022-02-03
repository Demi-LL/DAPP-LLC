<template>
  <div class="container">
    <div class="row">
      <div class="container col-xs-12 col-sm-8 col-sm-push-2">
        <h1 class="text-center">ERC20 錢包列表</h1>
        <hr />
      </div>
    </div>
    <div class="row gap-2 mb-3" v-for="account in accounts" :key="account">
      <div class="container col-sm-8 col-sm-push-4 col-md-6 col-md-push-6">
        <h4 class="col">{{ account }}</h4>
        <span class="col">{{ $formatter.balance(getBalance(account)) }}</span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "List",
  data() {
    return {
      accounts: [],
      balances: [],
    };
  },
  created() {
    this.$web3.eth
      .getAccounts()
      .then((data) => {
        this.accounts = data;
      })
      .catch((err) => console.log("error: ", err));
  },
  methods: {
    getBalance(account) {
      return this.balances[account] ?? 0;
    },
  },
};
</script>
