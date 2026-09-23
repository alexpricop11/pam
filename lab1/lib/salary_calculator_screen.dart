import 'package:flutter/material.dart';

import 'salary_calculator.dart';
import 'salary_calculator_widgets.dart';

class SalaryCalculatorScreen extends StatefulWidget {
  const SalaryCalculatorScreen({super.key});

  @override
  State<SalaryCalculatorScreen> createState() => _SalaryCalculatorScreenState();
}

class _SalaryCalculatorScreenState extends State<SalaryCalculatorScreen> {
  final _salaryController = TextEditingController();
  TaxType _taxType = TaxType.standard;
  SalaryResult? _result;
  String? _error;

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }

  void _calculate() {
    final gross = SalaryCalculator.parseSalary(_salaryController.text);
    setState(() {
      _error = gross == null
          ? 'Introdu o sumă validă.'
          : null;
      _result = gross == null
          ? null
          : SalaryCalculator.calculate(gross, _taxType);
    });
    if (gross != null) FocusScope.of(context).unfocus();
  }

  void _clearResult() {
    setState(() {
      _result = null;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 36,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Calculator salariu',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Află cât rămâne din salariul brut.'),
                  const SizedBox(height: 28),
                  SalaryCalculatorForm(
                    controller: _salaryController,
                    taxType: _taxType,
                    error: _error,
                    onChanged: (_) => _clearResult(),
                    onSubmitted: (_) => _calculate(),
                    onTaxTypeChanged: (type) {
                      _taxType = type;
                      _clearResult();
                    },
                    onCalculate: _calculate,
                  ),
                  const SizedBox(height: 28),
                  SalaryResultCard(result: _result),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
