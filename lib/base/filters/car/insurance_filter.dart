import 'package:car_log/base/models/car.dart';
import 'package:flutter/material.dart';

class InsuranceFilter extends StatelessWidget {
  final Set<String> selectedInsurance;
  final ValueChanged<Set<String>> onSelectionChanged;
  final List<Car> cars;

  const InsuranceFilter({
    super.key,
    required this.onSelectionChanged,
    required this.cars,
    required this.selectedInsurance,
  });

  @override
  Widget build(BuildContext context) {
    final uniqueInsurances = cars
        .map((car) => car.insurance.trim())
        .where((responsiblePerson) => responsiblePerson.isNotEmpty)
        .toSet()
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Insurance',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        Divider(thickness: 1.0, color: Theme.of(context).primaryColor),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: uniqueInsurances.map((insurance) {
            return _buildFilterChip(insurance);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      selected: selectedInsurance.contains(label),
      elevation: 3,
      pressElevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      onSelected: (isSelected) {
        final newSelection = Set<String>.from(selectedInsurance);
        if (isSelected) {
          newSelection.add(label);
        } else {
          newSelection.remove(label);
        }
        onSelectionChanged(newSelection);
      },
    );
  }
}
