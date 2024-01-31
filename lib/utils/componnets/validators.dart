class AppValidators {
  static String? Function(String?)? validator = (value) {
    if (value!.isEmpty) {
      return 'Required*';
    }
    return null;
  };
}
