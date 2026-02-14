enum EmailCheckContext {
  signUp('sign_up'),
  signIn('sign_in'),
  forgotPassword('forgot_password'),
  addPassword('add_password');

  final String value;
  const EmailCheckContext(this.value);
}

enum OtpContext {
  signUp('sign_up'),
  forgotPassword('forgot_password');

  final String value;
  const OtpContext(this.value);
}
