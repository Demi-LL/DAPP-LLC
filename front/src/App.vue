<template>
  <router-view />
</template>

<script>
import { provide } from "vue";
import contract from "../libraries/contract";
export default {
  async created() {
    if (!this.$web3.eth.currentProvider) {
      alert("請連接錢包");
    }

    contract.setProvider(this.$web3.eth.currentProvider);

    provide("contract", contract.deployed());
  },
};
</script>
