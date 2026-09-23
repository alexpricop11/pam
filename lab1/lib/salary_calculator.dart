enum TaxType {
  standard('Standard', 12),
  reduced('Redusă', 6),
  exempt('Scutit', 0);

  const TaxType(this.label, this.percent);

  final String label;
  final int percent;
}

class SalaryResult {
  const SalaryResult({required this.gross, required this.tax});

  final double gross;
  final double tax;

  double get net => gross - tax;
}

class SalaryCalculator {
  static double? parseSalary(String input) {
    final value = double.tryParse(input.trim().replaceAll(',', '.'));
    if (value == null || value < 0) return null;
    return value;
  }

  static SalaryResult calculate(double gross, TaxType type) {
    final tax = gross * type.percent / 100;
    return SalaryResult(gross: gross, tax: tax);
  }
}
