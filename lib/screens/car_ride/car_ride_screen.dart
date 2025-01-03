import 'package:car_log/model/car.dart';
import 'package:car_log/services/Routes.dart';
import 'package:car_log/widgets/theme/application_bar.dart';
import 'package:flutter/material.dart';

class CarRideScreen extends StatelessWidget {
  const CarRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final car = ModalRoute.of(context)?.settings.arguments as Car;
    return Scaffold(
      appBar:
          ApplicationBar(title: car.name, userDetailRoute: Routes.userDetail),
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          child: Text(car.name, style: TextStyle(color: Colors.black)),
          color: Colors.red,
        ),
      ),
    );
  }
}
