// Task:
// Develop logic of set balance and get balance methods
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from openzeppelin.access.ownable import Ownable
from starkware.starknet.common.syscalls import get_caller_address

// Define a storage variable.
@storage_var
func balance() -> (res: felt) {
}

// Returns the current balance.
@view
func get_balance{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}() -> (res: felt) {
    let (bal_) = balance.read();
    return (res = bal_);
}

// Sets the balance to amount
@external
func set_balance{
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(amount: felt) {
    let (owner) = Ownable.owner();
    let (caller) = get_caller_address();
    //assert owner = caller;
    Ownable.assert_only_owner();

    //with_attr error_message("Ownable: caller is not the owner") {
    //    assert owner = caller;
    //}
    //%{ print(f"Owner = {ids.owner}, Caller = {ids.caller}") %}
    balance.write(amount);
    return ();
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(addr : felt) {
    balance.write(0);
    %{ print(f"Calling constructor\n Owner = {ids.addr}") %}
    //let (caller) = get_caller_address();
    Ownable.initializer(addr);
    return ();
}