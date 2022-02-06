pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

contract LLC is IERC20, IERC20Metadata, Ownable {
  string private _name; // 貨幣名稱
  string private _symbol; // 貨幣代稱
  uint8 private _decimals; // 支援到小數後幾位
  uint256 private _supplyLimit; // 最大提供上限
  uint256 private _totalSupply; // 目前已發放數量

  mapping(address => uint256) private _balances; // 各個帳號所擁有的貨幣數量
  mapping(address => mapping(address => uint256)) private _allowances; // 授權其他帳號操作的貨幣數量

  constructor(string memory coinName,string memory coinSymbol) {
    _name = coinName;
    _symbol = coinSymbol;
    _decimals = 18; // 10 ^ 18 = 1 LLC
    _supplyLimit = 1024 * (10 ** _decimals); // maximum supply = 1024 LLC = 1024 * (10**18) wei
    _totalSupply = 0;
  }

  /**
    * 取得虛擬貨幣名稱
    */
  function name() external view virtual override returns (string memory) {
    return _name;
  }

  /**
    * 取得虛擬貨幣代號
    */
  function symbol() external view virtual override returns (string memory) {
    return _symbol;
  }

  /**
    * 取得虛擬貨幣支援到小數點後幾位
    */
  function decimals() external view virtual override returns (uint8) {
    return _decimals;
  }

  /**
    * 取得當前已鑄造的虛擬貨幣數量
    */
  function totalSupply() external view virtual override returns (uint256) {
    return _totalSupply;
  }

  /**
    * 取得特定錢包的貨幣數量
    */
  function balanceOf(address account) external view virtual override returns (uint256) {
    return _balances[account];
  }

  /**
    * owner 帳號允許 spender 帳號操作的貨幣數量
    */
  function allowance(address owner, address spender) external view virtual override returns (uint256) {
    return _allowances[owner][spender];
  }

  /**
    * 基本的帳戶地址檢查
    */
  modifier validAddress(address to) {
    require(to != address(0), "");
    _;
  }

  /**
    * 將當前帳號內的貨幣轉換到 to 帳號內
    */
  function transfer(address to, uint256 amount) public virtual override validAddress(to) returns (bool) {
    require(_balances[msg.sender] >= amount, "Transfer amount is larger than the balance of wallet.");

    _balances[msg.sender] -= amount;
    _balances[to] += amount;

    emit Transfer(msg.sender, to, amount);
    
    return true;
  }

  /**
    * 第三方帳戶，根據 _allowances 記錄的授權數量，將貨幣轉換到 to 帳號內
    */
  function transferFrom(
    address owner,
    address to,
    uint256 amount
  ) external validAddress(owner) validAddress(to) returns (bool) {
    require(_allowances[owner][msg.sender] >= amount, "Over supply limit.");
    require(_balances[owner] >= amount, "Account balance is insufficient.");

    _allowances[owner][msg.sender] -= amount;
    _balances[owner] -= amount;
    _balances[to] += amount;

    emit Transfer(owner, to, amount);

    return true;
  }

  /**
    * 設定 _allowances，記錄授權第三方操作帳號的貨幣數量
    */
  function approve(address spender, uint256 amount) external virtual override validAddress(spender) returns (bool) {
    address owner = msg.sender;
    _allowances[owner][spender] = amount;

    emit Approval(owner, spender, amount);

    return true;
  }

  /**
    * 鑄造貨幣
    * 只開放合約部署者操作
    */
  function mint(address to, uint amount) public onlyOwner {
    require(amount + _totalSupply <= _supplyLimit, string(bytes.concat(bytes("LLC cannot be minted more than "), bytes(Strings.toString(_supplyLimit)))));
    
    _totalSupply += amount;
    _balances[to] += amount;
  }
}
