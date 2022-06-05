from brownie import FundMe, accounts, network
from scripts.helpful_scripts import get_account


def fund():
    fund_me = FundMe[-1]
    account = get_account()
    min = fund_me.get_entrance_fee()
    print(min)
    print(f"The current entry fee is {min}")
    print("Funding")
    fund_me.pay({"from": account, "value": min * 2})


def withdraw():
    fund_me = FundMe[-1]
    account = get_account()
    fund_me.withdraw({"from": account})


def main():
    fund()
    withdraw()
