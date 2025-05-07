class AiCheckerService {
  // Add your custom "legit patterns" here (can be improved later)
  static final List<String> legitPatterns = [
    "Certificate of Authentication",
    "Issued by DigiLock University",
    "Signature:",
    "Date of Issue:"
  ];

  static Future<bool> isCertificateLegit(String extractedText) async {
    // Simulate 5-second AI processing delay
    await Future.delayed(const Duration(seconds: 5));

    // Check if all patterns are present in the PDF text
    for (final pattern in legitPatterns) {
      if (!extractedText.contains(pattern)) {
        return false;
      }
    }
    return true;
  }
}
