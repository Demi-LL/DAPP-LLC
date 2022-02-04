pragma solidity ^0.8.0;

import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol';

contract LLC is IERC20, IERC20Metadata, Ownable {
  string private _name;
  string private _symbol;
  uint8 private _decimals;
  uint256 private _supplyLimit;
  uint256 private _totalSupply;

  mapping(address => uint256) private _balances;
  mapping(address => mapping(address => uint256)) private _allowances;

  constructor(string memory coin_symbol) {
    _name = 'LLC';
    _symbol = coin_symbol;
    _decimals = 18; // 10 ^ 18 = 1 LLC
    _supplyLimit = 1024 * (10 ** _decimals); // maximum supply = 1024 LLC = 1024 * (10**18) wei
    _totalSupply = 0;
  }

  /**
    * @dev Returns the name of the token.
    */
  function name() external view virtual override returns (string memory) {
    return _name;
  }

  /**
    * @dev Returns the symbol of the token.
    */
  function symbol() external view virtual override returns (string memory) {
    return _symbol;
  }

  /**
    * @dev Returns the decimals places of the token.
    */
  function decimals() external view virtual override returns (uint8) {
    return _decimals;
  }

  /**
    * @dev Returns the amount of tokens in existence.
    */
  function totalSupply() external view virtual override returns (uint256) {
    return _totalSupply;
  }

  /**
    * @dev Returns the amount of tokens owned by `account`.
    */
  function balanceOf(address account) external view virtual override returns (uint256) {
    return _balances[account];
  }

  modifier validAddress(address to) {
    require(to != address(0), '');
    _;
  }

  /**
    * @dev Moves `amount` tokens from the caller's account to `recipient`.
    *
    * Returns a boolean value indicating whether the operation succeeded.
    *
    * Emits a {Transfer} event.
    */
  function transfer(address to, uint256 amount) public virtual override validAddress(to) returns (bool) {
      require(_balances[msg.sender] >= amount, 'Transfer amount is larger than the balance of wallet.');

    _balances[msg.sender] -= amount;
    _balances[to] += amount;

    emit Transfer(msg.sender, to, amount);
    
    return true;
  }

  /**
    * @dev Returns the remaining number of tokens that `spender` will be
    * allowed to spend on behalf of `owner` through {transferFrom}. This is
    * zero by default.
    *
    * This value changes when {approve} or {transferFrom} are called.
    */
  function allowance(address owner, address spender) external view virtual override returns (uint256) {
    return _allowances[owner][spender];
  }

  /**
    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
    *
    * Returns a boolean value indicating whether the operation succeeded.
    *
    * IMPORTANT: Beware that changing an allowance with this method brings the risk
    * that someone may use both the old and the new allowance by unfortunate
    * transaction ordering. One possible solution to mitigate this race
    * condition is to first reduce the spender's allowance to 0 and set the
    * desired value afterwards:
    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    *
    * Emits an {Approval} event.
    */
  function approve(address spender, uint256 amount) external virtual override validAddress(spender) returns (bool) {
    address owner = msg.sender;
    _allowances[owner][spender] = amount;

    emit Approval(owner, spender, amount);

    return true;
  }

  /**
    * @dev Moves `amount` tokens from `sender` to `recipient` using the
    * allowance mechanism. `amount` is then deducted from the caller's
    * allowance.
    *
    * Returns a boolean value indicating whether the operation succeeded.
    *
    * Emits a {Transfer} event.
    */
  function transferFrom(
    address owner,
    address to,
    uint256 amount
  ) external validAddress(owner) validAddress(to) returns (bool) {
    require(_allowances[owner][msg.sender] >= amount, '');
    require(_balances[owner] >= amount, '');

    _allowances[owner][msg.sender] -= amount;
    _balances[owner] -= amount;
    _balances[to] -= amount;

    emit Transfer(owner, to, amount);
    return true;
  }

  function mint(address to, uint amount) public onlyOwner {
    require(amount + _totalSupply <= _supplyLimit, string(bytes.concat(bytes('LLC can not mint more than '), bytes(Strings.toString(_supplyLimit)))));
    
    _totalSupply += amount;
    _balances[to] += amount;
  }
}
