export default {
  vm: null,
  globalProperties() {
    return this.vm.config.globalProperties;
  },
  isAddress(address) {
    return address && this.globalProperties().$web3.utils.isAddress(address);
  },
};
