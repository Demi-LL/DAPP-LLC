export default {
  weiToDecimals(num, decimals = 18) {
    return parseFloat(num) / 10 ** decimals;
  },
};
