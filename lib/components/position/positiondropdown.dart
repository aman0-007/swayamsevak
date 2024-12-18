import 'package:flutter/material.dart';

class PositionDropdown extends StatefulWidget {
  final TextEditingController controller;

  const PositionDropdown({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _PositionDropdownState createState() => _PositionDropdownState();
}

class _PositionDropdownState extends State<PositionDropdown> {
  final List<String> _positions = ["Participant", "Organizing"];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.controller.text.isNotEmpty ? widget.controller.text : null,
      decoration: const InputDecoration(
        labelText: "Position",
        border: OutlineInputBorder(),
      ),
      items: _positions
          .map((position) => DropdownMenuItem(
        value: position,
        child: Text(position),
      ))
          .toList(),
      onChanged: (value) {
        setState(() {
          widget.controller.text = value!;
        });
      },
    );
  }
}
