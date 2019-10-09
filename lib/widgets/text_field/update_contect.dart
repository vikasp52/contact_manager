import 'package:flutter/material.dart';

class UpdateContactTextField extends StatefulWidget {
  final String label;
  final int maxLine;
  final TextInputType keyboardType;


  //final ValueChanged<String> onChange;
  //final Stream stream;
  final TextEditingController controller;

  //final String initialValue;

  UpdateContactTextField({this.label, this.maxLine = 1, this.controller,this.keyboardType = TextInputType.text,});

  @override
  _UpdateContactTextFieldState createState() => _UpdateContactTextFieldState();
}

class _UpdateContactTextFieldState extends State<UpdateContactTextField> {

  String validateData(String value) {
    if (value.isEmpty)
      return 'Field cannot be empty';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLines: widget.maxLine,
        //onChanged: widget.onChange,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 22, color: Colors.black),
        validator: (value) => validateData(value),
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
}
