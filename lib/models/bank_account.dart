class BankAccount{
  late String accountNumber;
  final String holderName;
  double balance;
  String? bankBranch;

  BankAccount({
    required this.holderName,
    this.balance = 0.0,
    this.bankBranch,
  });

  bool _isInitialized = false;

  void initializeAccount(String number) {
    accountNumber = number;
    _isInitialized = true;
  }
  bool isAccountNumberSet() => _isInitialized;
  
  String getDisplayAccountNumber() {
    return _isInitialized ? accountNumber : 'Account uninitialized';
  }
}