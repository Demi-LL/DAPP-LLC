import BigNumber from "bignumber.js";
export default {
  /**
   * 大數需要另外使用套件處理，否則會出現溢位錯誤
   */
  decimalsToWei(num, decimals = 18) {
    return new BigNumber(parseFloat(num) * 10 ** decimals);
  },
  weiToDecimals(num, decimals = 18) {
    return parseFloat(num) / 10 ** decimals;
  },
};
