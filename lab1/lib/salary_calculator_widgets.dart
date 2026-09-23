import 'package:flutter/material.dart';

import 'salary_calculator.dart';

class SalaryCalculatorForm extends StatelessWidget {
  const SalaryCalculatorForm({
    super.key,
    required this.controller,
    required this.taxType,
    required this.error,
    required this.onChanged,
    required this.onSubmitted,
    required this.onTaxTypeChanged,
    required this.onCalculate,
  });

  final TextEditingController controller;
  final TaxType taxType;
  final String? error;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<TaxType> onTaxTypeChanged;
  final VoidCallback onCalculate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            labelText: 'Salariul brut',
            hintText: 'De exemplu, 10000',
            suffixText: 'lei',
            errorText: error,
          ),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<TaxType>(
          value: taxType,
          decoration: const InputDecoration(
            labelText: 'Tipul de impozitare',
          ),
          items: TaxType.values
              .map(
                (type) => DropdownMenuItem(
                  value: type,
                  child: Text('${type.label} · ${type.percent}%'),
                ),
              )
              .toList(),
          onChanged: (type) {
            if (type != null) onTaxTypeChanged(type);
          },
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: onCalculate,
            child: const Text(
              'Calculează',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

class SalaryResultCard extends StatelessWidget {
  const SalaryResultCard({super.key, required this.result});

  final SalaryResult? result;

  String _money(double value) =>
      '${value.toStringAsFixed(2).replaceAll('.', ',')} lei';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SALARIUL NET',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            result == null ? '—' : _money(result!.net),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          ),
          if (result != null) ...[
            const SizedBox(height: 16),
            Text('Salariu brut: ${_money(result!.gross)}'),
            const SizedBox(height: 8),
            Text('Impozite: ${_money(result!.tax)}'),
          ],
        ],
      ),
    );
  }
}
