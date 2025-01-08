import 'dart:async';
import 'package:car_log/model/ride.dart';
import 'package:car_log/model/ride_type.dart';
import 'package:car_log/screens/ride_edit/ride_map/ride_map_selector.dart';
import 'package:car_log/screens/ride_edit/utils/build_card_section.dart';
import 'package:car_log/screens/ride_edit/utils/ride_form_constants.dart';
import 'package:car_log/screens/ride_edit/widget/date_time_picker_tile.dart';
import 'package:car_log/screens/ride_edit/widget/dialog_helper.dart';
import 'package:car_log/screens/ride_edit/widget/save_ride_button.dart';
import 'package:car_log/services/car_service.dart';
import 'package:car_log/services/location_service.dart';
import 'package:car_log/services/ride_service.dart';
import 'package:car_log/set_up_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart' as flutterMap;
import 'package:latlong2/latlong.dart';

class RideForm extends StatefulWidget {
  final Ride ride;

  const RideForm({Key? key, required this.ride}) : super(key: key);

  @override
  _RideFormState createState() => _RideFormState();
}

class _RideFormState extends State<RideForm> {
  late TextEditingController _rideTypeController;
  late TextEditingController _distanceController;
  late TextEditingController _userNameController;
  late TextEditingController _locationStartController;
  late TextEditingController _locationEndController;
  DateTime? _selectedStartDateTime;
  DateTime? _selectedFinishDateTime;

  final RideService rideService = get<RideService>();
  final LocationService locationService = get<LocationService>();
  late flutterMap.MapController _mapController;
  late StreamSubscription<String> _locationSubscription;
  bool _isUpdatingStartLocation = true;

  @override
  void initState() {
    super.initState();
    _rideTypeController = TextEditingController(text: widget.ride.rideType);
    _distanceController = TextEditingController(text: widget.ride.distance.toString());
    _userNameController = TextEditingController(text: widget.ride.userName);
    _locationStartController = TextEditingController(text: widget.ride.locationStart);
    _locationEndController = TextEditingController(text: widget.ride.locationEnd);
    _selectedStartDateTime = widget.ride.startedAt;
    _selectedFinishDateTime = widget.ride.finishedAt;
    _mapController = flutterMap.MapController();
    _locationSubscription = locationService.locationStream.listen((location) {
    });
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    _rideTypeController.dispose();
    _distanceController.dispose();
    _userNameController.dispose();
    _locationStartController.dispose();
    _locationEndController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BuildCardSection(
            context: context,
            title: RideFormConstants.LOCATION_DETAILS_TITLE,
            children: [
              RideFormMapField(
                controller: _locationStartController,
                mapController: _mapController,
                label: RideFormConstants.START_LOCATION_LABEL,
                isStartLocation: true,
                onLocationSelected: (LatLng point) {
                  locationService.reverseGeocode(point).then((address) {
                    _locationStartController.text = address;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Start location updated to $address.')),
                    );
                  }).catchError((_) {
                    _locationStartController.text = '${point.latitude}, ${point.longitude}';
                  });
                },
              ),
              const SizedBox(height: RideFormConstants.FIELD_SPACING),
              RideFormMapField(
                controller: _locationEndController,
                mapController: _mapController,
                label: RideFormConstants.END_LOCATION_LABEL,
                isStartLocation: false,
                onLocationSelected: (LatLng point) {
                  locationService.reverseGeocode(point).then((address) {
                    _locationEndController.text = address;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('End location updated to $address.')),
                    );
                  }).catchError((_) {
                    _locationEndController.text = '${point.latitude}, ${point.longitude}';
                  });
                },
              ),
            ],
          ),
          BuildCardSection(
            context: context,
            title: RideFormConstants.RIDE_DETAILS_TITLE,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _distanceController,
                      decoration: const InputDecoration(
                        labelText: RideFormConstants.DISTANCE_LABEL,
                        prefixIcon: Icon(Icons.directions_car),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<RideType>(
                      value: stringToRideType(_rideTypeController.text),  // Convert initial string to enum
                      decoration: const InputDecoration(
                        labelText: 'Ride Type',
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: RideType.values.map((RideType type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.toString().split('.').last),  // Display readable enum values
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _rideTypeController.text = newValue.toString().split('.').last;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),

          BuildCardSection(
            context: context,
            title: RideFormConstants.TIME_DETAILS_TITLE,
            children: [
              DateTimePickerTile(
                label: RideFormConstants.STARTED_AT_LABEL,
                dateTime: _selectedStartDateTime,
                onTap: () => _selectDateTime(context, true),
              ),
              DateTimePickerTile(
                label: RideFormConstants.FINISHED_AT_LABEL,
                dateTime: _selectedFinishDateTime,
                onTap: () => _selectDateTime(context, false),
              ),
            ],
          ),
          const SizedBox(height: RideFormConstants.SECTION_VERTICAL_MARGIN),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BaseActionRideButton(
                onPressed: _saveOrUpdateRide,
                isDeleteButton: false,
              ),
              const SizedBox(width: RideFormConstants.FIELD_SPACING),
              BaseActionRideButton(
                onPressed: _deleteRide,
                isDeleteButton: true,
              ),
            ],
          ),
          const SizedBox(height: RideFormConstants.SECTION_VERTICAL_MARGIN),
        ],
      ),
    );
  }

  void _deleteRide() {
    final carService = get<CarService>();
    final rideDistance = widget.ride.distance;

    rideService.deleteRide(carService.activeCar.id, widget.ride.id).listen((_) {
      if (mounted) {
        final newOdometerValue = int.parse(carService.activeCar.odometerStatus) - rideDistance;
        carService.updateOdometer(newOdometerValue < 0 ? 0 : newOdometerValue);

        DialogHelper.showSnackBar(context, RideFormConstants.RIDE_DELETED_MESSAGE);
        Navigator.pop(context);
      }
    }).onError((_) {
      if (mounted) {
        DialogHelper.showSnackBar(context, 'Failed to delete ride.');
      }
    });
  }

  void _saveOrUpdateRide() {
    if (_distanceController.text.isEmpty || !_isValidTime()) return;

    final updatedRide = widget.ride.copyWith(
      startedAt: _selectedStartDateTime,
      finishedAt: _selectedFinishDateTime,
      rideType: _rideTypeController.text,
      distance: int.parse(_distanceController.text),
      locationStart: _locationStartController.text,
      locationEnd: _locationEndController.text,
    );

    rideService.saveRide(updatedRide, get<CarService>().activeCar.id).listen((_) {
      if (mounted) {
        // Explicitly update odometer after ride save
        final newOdometerValue = int.parse(get<CarService>().activeCar.odometerStatus) + updatedRide.distance;
        get<CarService>().updateOdometer(newOdometerValue);

        DialogHelper.showSnackBar(context, RideFormConstants.RIDE_SAVED_MESSAGE);
        Navigator.pop(context);
      }
    }).onError((_) {
      if (mounted) {
        DialogHelper.showSnackBar(context, 'Failed to save ride.');
      }
    });
  }

  bool _isValidTime() {
    if (_selectedStartDateTime != null && _selectedFinishDateTime != null &&
        _selectedStartDateTime!.isBefore(_selectedFinishDateTime!)) {
      return true;
    }
    DialogHelper.showErrorDialog(
      context,
      RideFormConstants.INVALID_TIME_TITLE,
      RideFormConstants.INVALID_TIME_MESSAGE,
    );
    return false;
  }

  void _requestLocation(bool isStartLocation) {
    _isUpdatingStartLocation = isStartLocation;
    _locationSubscription = locationService.locationStream.listen((location) {
      if (mounted) {
        setState(() => _isUpdatingStartLocation
            ? _locationStartController.text = location
            : _locationEndController.text = location);
        DialogHelper.showSnackBar(context, RideFormConstants.LOCATION_UPDATED_MESSAGE);
      }
    });
    locationService.requestLocation();
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartDateTime) async {
    final initialDate = isStartDateTime ? _selectedStartDateTime : _selectedFinishDateTime;
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(RideFormConstants.FIRST_YEAR),
      lastDate: DateTime(RideFormConstants.LAST_YEAR),
    );
    if (selectedDate == null) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate ?? DateTime.now()),
    );
    if (selectedTime == null) return;

    final selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    setState(() => isStartDateTime
        ? _selectedStartDateTime = selectedDateTime
        : _selectedFinishDateTime = selectedDateTime
    );
  }
}
