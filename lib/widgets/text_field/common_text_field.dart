import 'package:flutter/material.dart';

class CommonTextField extends StatefulWidget {
  final String label;
  final int maxLine;
  final ValueChanged<String> onChange;
  final Stream stream;
  final TextEditingController controller;

  final String initialValue;

  CommonTextField({this.label, this.maxLine = 1, this.onChange, this.initialValue, this.stream, this.controller});

  @override
  _CommonTextFieldState createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  //TextEditingController _controller = TextEditingController();

  Widget buildTextBox({String data}) {
    if (widget.initialValue != null || widget.initialValue != '') {
      _controller.value = _controller.value.copyWith(
        text: widget.initialValue ?? data,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        maxLines: widget.maxLine,
        onChanged: widget.onChange,
        controller: _controller,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 22, color: Colors.black),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.teal)),
        ),
      ),
    );
  }

  TextEditingController _controller = TextEditingController(); // make a controller,

  Widget field() {
    return StreamBuilder(
      stream: widget.stream,
      builder: (context, snapshot) {
        _controller.value = TextEditingValue(text: "${snapshot.data}"); // assign value to controller this way
        return TextField(
          controller: _controller,
          style: TextStyle(fontSize: 15.0),
          onChanged: widget.onChange,
          decoration: InputDecoration(errorStyle: TextStyle(fontSize: 15.0), errorText: snapshot.error),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.stream,
        builder: (context, snapshotData) {
          var cursorPos = _controller.selection;
          if (cursorPos.start > _controller.text.length) {
            cursorPos = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
          }
          _controller.selection = cursorPos;
          return buildTextBox(data: snapshotData.data);
        });
  }
}
