<template>
  <router-view />
</template>

<script>
import { provide } from "vue";
import contract from "../libraries/contract";
export default {
  async created() {
    if (!this.$web3?.eth?.currentProvider) {
      alert("請連接錢包");

      return this.$router.go();
    }

    contract.setProvider(this.$web3.eth.currentProvider);

    // 利用 composition API 傳遞已部署合約的參數到其他需要使用的頁面
    provide("contract", contract.deployed());
  },
};
</script>
