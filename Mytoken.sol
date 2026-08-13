// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// ============================================
// CUSTOM ERRORS
// ============================================

error ERC20__ZeroAddress();
error ERC20__ZeroAmount();
error ERC20__InsufficientBalance(
    uint256 available,
    uint256 required
);
error ERC20__ExceedsAllowance(
    uint256 allowance,
    uint256 required
);
error ERC20__InvalidSpender();
error ERC20__BurnExceedsBalance(
    uint256 balance,
    uint256 amount
);
error ERC20__MintToZeroAddress();

// ============================================
// ERC20 TOKEN
// ============================================

contract MyToken {
    // ============================================
    // STATE VARIABLES
    // ============================================

    string public name;
    string public symbol;
    uint8 public decimals;

    uint256 public totalSupply;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256))
        private _allowances;

    // ============================================
    // EVENTS
    // ============================================

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    // ============================================
    // CONSTRUCTOR
    // ============================================

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply_
    ) {
        if (initialSupply_ == 0) {
            revert ERC20__ZeroAmount();
        }

        name = name_;
        symbol = symbol_;
        decimals = 18;

        _mint(msg.sender, initialSupply_);
    }

    // ============================================
    // BALANCE OF
    // ============================================

    function balanceOf(
        address account
    )
        external
        view
        returns (uint256)
    {
        return _balances[account];
    }

    // ============================================
    // ALLOWANCE
    // ============================================

    function allowance(
        address owner,
        address spender
    )
        external
        view
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    // ============================================
    // TRANSFER
    // ============================================

    function transfer(
        address to,
        uint256 amount
    )
        external
        returns (bool)
    {
        if (to == address(0)) {
            revert ERC20__ZeroAddress();
        }

        if (amount == 0) {
            revert ERC20__ZeroAmount();
        }

        if (_balances[msg.sender] < amount) {
            revert ERC20__InsufficientBalance(
                _balances[msg.sender],
                amount
            );
        }

        _transfer(
            msg.sender,
            to,
            amount
        );

        return true;
    }

    // ============================================
    // APPROVE
    // ============================================

    function approve(
        address spender,
        uint256 amount
    )
        external
        returns (bool)
    {
        if (spender == address(0)) {
            revert ERC20__InvalidSpender();
        }

        _allowances[msg.sender][spender] = amount;

        emit Approval(
            msg.sender,
            spender,
            amount
        );

        return true;
    }

    // ============================================
    // TRANSFER FROM
    // ============================================

    function transferFrom(
        address from,
        address to,
        uint256 amount
    )
        external
        returns (bool)
    {
        if (from == address(0)) {
            revert ERC20__ZeroAddress();
        }

        if (to == address(0)) {
            revert ERC20__ZeroAddress();
        }

        if (amount == 0) {
            revert ERC20__ZeroAmount();
        }

        uint256 currentAllowance =
            _allowances[from][msg.sender];

        if (currentAllowance < amount) {
            revert ERC20__ExceedsAllowance(
                currentAllowance,
                amount
            );
        }

        _allowances[from][msg.sender] =
            currentAllowance - amount;

        _transfer(
            from,
            to,
            amount
        );

        return true;
    }

    // ============================================
    // BURN
    // ============================================

    function burn(
        uint256 amount
    )
        external
    {
        if (amount == 0) {
            revert ERC20__ZeroAmount();
        }

        if (_balances[msg.sender] < amount) {
            revert ERC20__BurnExceedsBalance(
                _balances[msg.sender],
                amount
            );
        }

        _burn(
            msg.sender,
            amount
        );
    }

    // ============================================
    // INTERNAL TRANSFER
    // ============================================

    function _transfer(
        address from,
        address to,
        uint256 amount
    )
        internal
    {
        _balances[from] -= amount;
        _balances[to] += amount;

        emit Transfer(
            from,
            to,
            amount
        );
    }

    // ============================================
    // INTERNAL MINT
    // ============================================

    function _mint(
        address account,
        uint256 amount
    )
        internal
    {
        if (account == address(0)) {
            revert ERC20__MintToZeroAddress();
        }

        totalSupply += amount;
        _balances[account] += amount;

        emit Transfer(
            address(0),
            account,
            amount
        );
    }

    // ============================================
    // INTERNAL BURN
    // ============================================

    function _burn(
        address account,
        uint256 amount
    )
        internal
    {
        _balances[account] -= amount;
        totalSupply -= amount;

        emit Transfer(
            account,
            address(0),
            amount
        );
    }
}