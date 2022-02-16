import Utils from 'web3-utils';

export default {
  /**
   * 大數需要另外使用套件處理，否則會出現溢位錯誤
   * 2022-02-17 使用 bignumber.js 套件，在本地 MAC 開發成功，但使用 Linux 會出現 invalid BigNumber value 錯誤
   */
  decimalsToWei(num) {
    return Utils.toWei(num);
  },
  weiToDecimals(num, decimals = 18) {
    return parseFloat(num) / 10 ** decimals;
  },
};
