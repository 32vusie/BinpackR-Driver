import 'dart:math';

class BankingInfoGenerator {
  static final _random = Random();
  static int _counter = 0;

  // Helper to generate random digits
  static String _generateRandomDigits(int length) {
    String result = '';
    for (int i = 0; i < length; i++) {
      result += _random.nextInt(10).toString(); // Numbers between 0 and 9
    }
    return result;
  }

  // Generate a unique account number
  static String generateAccountNumber() {
    _counter++;
    String timestampPart = DateTime.now().millisecondsSinceEpoch.toString();
    String counterPart = _counter.toString().padLeft(4, '0');
    return timestampPart + counterPart;
  }

  // Generate a unique card number
  static String generateCardNumber(int length) {
    return _generateRandomDigits(length - 8) + generateAccountNumber().substring(5); // Use last 8 digits of account number
  }

  // Generate card expiry date
  static String generateCardExpiry() {
    return '01/${DateTime.now().year + 3}';
  }

  // Generate a unique card CSV
  static String generateCardCSV() {
    return _generateRandomDigits(3);
  }

  // Generate a unique PIN
  static String generatePIN() {
    return _generateRandomDigits(4);
  }
}