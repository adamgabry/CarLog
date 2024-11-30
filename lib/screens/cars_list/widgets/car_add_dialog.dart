import 'package:car_log/screens/cars_list/widgets/car_add_field.dart';
import 'package:car_log/screens/cars_list/widgets/car_add_field_list.dart';
import 'package:car_log/screens/cars_list/widgets/fuel_type_dropdown.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CarAddDialog extends StatefulWidget {
  const CarAddDialog({super.key});

  @override
  State<CarAddDialog> createState() => _CarAddDialogState();
}

class _CarAddDialogState extends State<CarAddDialog> {
  final Map<String, TextEditingController> _controllers = {
    'Name': TextEditingController(),
    'Alias': TextEditingController(),
    'License Plate': TextEditingController(),
    'Insurance Contact': TextEditingController(),
    'Odometer Status': TextEditingController(),
    'Description': TextEditingController(),
  };

  final CarService carService = get<CarService>();

  final List<String> _fuelTypes = [
    'Gasoline',
    'Diesel',
    'Electric',
    'Hybrid',
    'LPG',
    'CNG',
    'Other'
  ];

  final List<IconData> _carIcons = [
    Icons.directions_car,
    Icons.directions_bus,
    Icons.local_shipping
  ];

  int _selectedCarIcon = 0;
  String _selectedFuelType = 'Gasoline';

  final Map<String, String?> _errorMessages = {};
  final Map<String, String> _carFields = {};

  bool _isSubmitting = false;

  void _submitForm() {
    setState(() {
      _isSubmitting = true;
    });

    carService.addCar(
        _carFields['Name']!,
        _carFields['Alias']!,
        _selectedFuelType,
        _carFields['License Plate']!,
        _carFields['Insurance Contact']!,
        _carFields['Odometer Status']!,
        _carFields['Description']!,
        _selectedCarIcon);

    Future.delayed(const Duration(seconds: 2), () {
      _isSubmitting = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Icon(Icons.add, color: Theme.of(context).colorScheme.onSecondary),
      onPressed: () => {_showAddCarDialog(context)},
      heroTag: 'addCarFAB',
    );
  }

  void _showAddCarDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: _isSubmitting ? Text("New car added") : Text('Add Car'),
              content: _isSubmitting
                  ? Lottie.asset('assets/animations/add_car.json',
                      width: 150, height: 150, repeat: false)
                  : CarAddFieldList(
                      controllers: _controllers,
                      errorMessages: _errorMessages,
                      fuelTypes: _fuelTypes,
                      selectedFuelType: _selectedFuelType,
                      carIcons: _carIcons,
                      selectedCarIcon: _selectedCarIcon,
                      onFuelTypeChanged: (newValue) {
                        setState(() {
                          _selectedFuelType = newValue!;
                        });
                      },
                      onCarIconChanged: (value) {
                        setState(() {
                          _selectedCarIcon = value as int;
                        });
                      },
                    ),
              actions: _isSubmitting
                  ? []
                  : [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _clearAllErrorMessages();
                          _clearAllControllers();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _validateFieldsAndSubmit();
                          });
                        },
                        child: Text('Submit'),
                      ),
                    ],
            );
          });
        }).then((_) {
      _clearAllErrorMessages();
      _clearAllControllers();
    });
  }

  void _validateFieldsAndSubmit() {
    bool isValid = true;
    _clearAllErrorMessages();
    for (var entry in _controllers.entries) {
      if (entry.value.text.trim().isEmpty) {
        _errorMessages[entry.key] =
            entry.value.text.trim().isEmpty ? '${entry.key} is required' : null;
        isValid = false;
      } else {
        _carFields[entry.key] = entry.value.text.trim();
      }
    }

    if (isValid) {
      setState(() {
        _submitForm();
      });
    }
  }

  void _clearAllErrorMessages() {
    _errorMessages.clear();
  }

  void _clearAllControllers() {
    for (final controller in _controllers.values) {
      controller.clear();
    }
  }
}
