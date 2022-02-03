export default {
  balance(num, decimals = 18) {
    return parseFloat(num).toFixed(decimals);
  },
};
