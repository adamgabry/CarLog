import 'package:flutter/material.dart';

class AdminFilter extends StatefulWidget {
  final void Function(bool) onChanged;
  const AdminFilter({super.key, required this.onChanged});

  @override
  State<AdminFilter> createState() => _AdminFilterState();
}

class _AdminFilterState extends State<AdminFilter> {
  bool _isAdminFilterOn = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Admins',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Switch(
            value: _isAdminFilterOn,
            onChanged: (value) {
              setState(() {
                _isAdminFilterOn = value;
              });
              widget.onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}
