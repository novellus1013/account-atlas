sealed class AccountFailure implements Exception {
  final String message;
  const AccountFailure(this.message);
}

class AccountNotFound extends AccountFailure {
  const AccountNotFound() : super('Account not found');
}

class AccountStorageFailure extends AccountFailure {
  const AccountStorageFailure() : super('Failed to access local storage');
}
