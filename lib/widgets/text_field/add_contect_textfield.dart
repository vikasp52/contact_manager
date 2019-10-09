import 'package:flutter/material.dart';

class AddContactTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final int maxLine;
  final ValueChanged<String> onChange;
  final Stream stream;
  final TextInputType keyboardType;
  final String initialValue;

  AddContactTextField(
      {this.label,
      this.maxLine = 1,
      this.onChange,
      this.initialValue,
      this.stream,
      this.keyboardType = TextInputType.text,
      this.hintText});

  @override
  _AddContactTextFieldState createState() => _AddContactTextFieldState();
}

class _AddContactTextFieldState extends State<AddContactTextField> {
  Widget buildTextBox({String data, String error}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        maxLines: widget.maxLine,
        onChanged: widget.onChange,
        //controller: _controller,
        textAlign: TextAlign.start,
        keyboardType: widget.keyboardType,
        style: TextStyle(fontSize: 22, color: Colors.black),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          errorText: error,
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.grey)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: widget.stream,
        builder: (context, snapshotData) {
          print('Date: ${snapshotData.data}');
          return buildTextBox(data: snapshotData.data, error: snapshotData.error);
        });
  }
}
