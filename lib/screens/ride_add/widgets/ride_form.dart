import 'package:car_log/model/ride.dart';
import 'package:car_log/model/user.dart';
import 'package:car_log/screens/ride_add/widgets/base_action_button.dart';
import 'package:car_log/screens/ride_add/widgets/user_dropdown.dart';
import 'package:car_log/screens/ride_edit/utils/build_card_section.dart';
import 'package:car_log/screens/ride_edit/utils/ride_form_constants.dart';
import 'package:car_log/screens/ride_edit/widget/dialog_helper.dart';
import 'package:car_log/screens/ride_edit/widget/ride_form_field_list.dart';
import 'package:car_log/screens/ride_edit/widget/save_ride_button.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/services/ride_service.dart';
import 'package:car_log/services/user_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_map/flutter_map.dart' as flutterMap;

class RideForm extends StatefulWidget {
  const RideForm({Key? key}) : super(key: key);

  @override
  State<RideForm> createState() => _RideFormState();
}

class _RideFormState extends State<RideForm> {
  final _locationStartController = TextEditingController();
  final _locationEndController = TextEditingController();
  final _distanceController = TextEditingController();
  final _rideTypeController = TextEditingController();

  DateTime? _selectedStartDateTime;
  DateTime? _selectedFinishDateTime;
  User? _selectedUser;

  late flutterMap.MapController _mapController;

  final _userService = get<UserService>();
  final _rideService = get<RideService>();
  final _carService = get<CarService>();

  @override
  void initState() {
    super.initState();
    _mapController = flutterMap.MapController();
    _selectedUser = _userService.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (_userService.currentUser!.isAdmin)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(height: 20),
                    UserDropdown(
                      userStream: _userService.users,
                      onUserSelected: (user) {
                        if (mounted) {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              _selectedUser = user!;
                            });
                          });
                        }
                        // _saveSelectedUser(user2);
                      },
                    ),
                  ],
                ),
              ),
            ),
          RideFormFieldList(
            locationStartController: _locationStartController,
            locationEndController: _locationEndController,
            distanceController: _distanceController,
            mapController: _mapController,
            rideTypeController: _rideTypeController,
            onDatesChanged: (DateTime? start, DateTime? finish) {
              setState(() {
                _selectedStartDateTime = start;
                _selectedFinishDateTime = finish;
              });
            },
          ),
          const SizedBox(height: RideFormConstants.SECTION_VERTICAL_MARGIN),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BaseActionButton(
                onPressed: _saveRide,
                isDeleteButton: false,
                buttonLabel: 'Create Ride',
                buttonIcon: const Icon(Icons.save),
              ),
              const SizedBox(width: RideFormConstants.FIELD_SPACING),
              BaseActionButton(
                onPressed: _deleteRide,
                isDeleteButton: true,
                buttonLabel: '',
                buttonIcon: const Icon(Icons.delete),
              ),
            ],
          ),
          const SizedBox(height: RideFormConstants.SECTION_VERTICAL_MARGIN),
        ],
      ),
    );
  }

  void _saveSelectedUser(User user) {
    setState(() {
      _selectedUser = user;
    });
  }

  void _saveRide() {
    if (_distanceController.text.isEmpty || !_isValidTime()) {
      return;
    }

    final newRide = Ride(
      userId: _selectedUser?.id ?? _userService.currentUser!.id,
      userName: _selectedUser?.name ?? _userService.currentUser!.name,
      startedAt: _selectedStartDateTime,
      finishedAt: _selectedFinishDateTime,
      rideType: _rideTypeController.text,
      distance: int.parse(_distanceController.text),
      locationStart: _locationStartController.text,
      locationEnd: _locationEndController.text,
    );

    _rideService.saveRide(newRide, _carService.activeCar.id).listen((_) {
      if (mounted) {
        final newOdometerValue =
            int.parse(_carService.activeCar.odometerStatus) + newRide.distance;
        _carService.updateOdometer(newOdometerValue);

        DialogHelper.showSnackBar(
          context,
          RideFormConstants.RIDE_SAVED_MESSAGE,
        );
        _clearFormAndPop();
      }
    }).onError((error) {
      if (mounted) {
        DialogHelper.showSnackBar(context, 'Failed to save ride: $error');
      }
    });
  }

  void _deleteRide() {
    _clearFormAndPop();
  }

  bool _isValidTime() {
    if (_selectedStartDateTime != null &&
        _selectedFinishDateTime != null &&
        _selectedStartDateTime!.isBefore(_selectedFinishDateTime!)) {
      return true;
    } else if (_selectedStartDateTime == null &&
        _selectedFinishDateTime == null) {
      return true;
    }
    DialogHelper.showErrorDialog(
      context,
      RideFormConstants.INVALID_TIME_TITLE,
      RideFormConstants.INVALID_TIME_MESSAGE,
    );
    return false;
  }

  void _clearFormAndPop() {
    setState(() {
      _locationStartController.clear();
      _locationEndController.clear();
      _distanceController.clear();
      _rideTypeController.clear();
      _selectedStartDateTime = null;
      _selectedFinishDateTime = null;
      _selectedUser = _userService.currentUser;
    });
    Navigator.pop(context);
  }
}
