class EmailRepository {
  const EmailRepository();

  Future<bool> findByAddress(String emailAddress) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
