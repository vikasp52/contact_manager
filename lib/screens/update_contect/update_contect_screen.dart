import 'package:contact_manager/model/contect_model.dart';
import 'package:contact_manager/screens/add_new_contect/bloc/new_contact_bloc.dart';
import 'package:contact_manager/widgets/common_body.dart';
import 'package:contact_manager/widgets/text_field/add_contect_textfield.dart';
import 'package:contact_manager/widgets/text_field/common_text_field.dart';
import 'package:contact_manager/widgets/text_field/update_contect.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'bloc/update_contact_bloc.dart';

class UpdateContactScreen extends StatefulWidget {

  final ContactModel contactModel;

  const UpdateContactScreen({Key key, this.contactModel}) : super(key: key);
  
  @override
  _UpdateContactScreenState createState() => _UpdateContactScreenState();
}

class _UpdateContactScreenState extends State<UpdateContactScreen> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerMobNo = TextEditingController();

  @override
  void initState() {
    super.initState();
    getContactData();
  }

  getContactData() {
    _controllerName = TextEditingController(text: widget.contactModel.name);
    _controllerMobNo = TextEditingController(text: widget.contactModel.mobileNo);
  }

  addDataToSink() {
    updateContactBloc.nameSink(_controllerName.text);
    updateContactBloc.mobNoSink(_controllerMobNo.text);
  }


  @override
  Widget build(BuildContext context) {
    
    DateTime selectedDate = DateTime.now();

    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context, initialDate: selectedDate, firstDate: DateTime(1960, 1), lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate) selectedDate = picked;
      var formatter = new DateFormat('dd-MMMM-yyyy');
      String formatted = formatter.format(selectedDate);
      print('Select Date: $formatted');
      updateContactBloc.dobSink(formatted);
    }

    Widget header() {
      return Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 60.0, 8.0, 8.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              elevation: 15.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 90.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: StreamBuilder(
                stream: updateContactBloc.profilePicStream,
                builder: (context, snapshotImageFile) {
                  return Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: CircleAvatar(
                            radius: 60.0,
                            backgroundColor: !snapshotImageFile.hasData ? Colors.black : Colors.white,
                            backgroundImage: snapshotImageFile.hasData
                                ? FileImage(snapshotImageFile.data)
                                : snapshotImageFile.hasData ? NetworkImage(snapshotImageFile.data) : null,
                            child: !snapshotImageFile.hasData && !snapshotImageFile.hasData
                                ? const Icon(
                              Icons.person,
                              color: Colors.white,
                            )
                                : SizedBox()),
                      ),
                      Positioned(
                        left: 5.0,
                        child: Container(
                          decoration: ShapeDecoration(
                              shape: CircleBorder(side: BorderSide(color: Colors.white, width: 1.0))),
                          child: CircleAvatar(
                            radius: 15.0,
                            backgroundColor: Colors.black,
                            child: InkWell(
                              onTap: updateContactBloc.uploadImage,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ))
        ],
      );
    }

    Widget buildContactForm() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 10.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                UpdateContactTextField(
                  label: 'Name',
                  controller: _controllerName,
                ),
                GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: StreamBuilder(
                          stream: updateContactBloc.dobStream,
                          builder: (context, snapshotDate) {
                            return CommonTextField(
                              label: 'Date of Birth',
                              initialValue: snapshotDate.hasData ? snapshotDate.data : widget.contactModel.dob,
                            );
                          }),
                    )),
                UpdateContactTextField(
                  label: 'Mobile No',
                  keyboardType: TextInputType.number,
                  controller: _controllerMobNo,

                ),
              ],
            ),
          ),
        ),
      );
    }


    Widget updateButton() {
      return Padding(
        padding: EdgeInsets.all(20),
        child: StreamBuilder<bool>(
          initialData: true,
            stream: updateContactBloc.submitCheck,
            builder: (context, snapshot) {
              return RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: !snapshot.data?null:() {
                  addDataToSink();
                  updateContactBloc.updateContactData(contactId: widget.contactModel.contactId);
                  Navigator.of(context).pop();
                },
                padding: EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                ),
                color: !snapshot.data?Colors.grey:Colors.black,
                child: Text(
                  "Update",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              );
            }
        ),
      );
    }

    return CommonBodyStructure(
      text: 'Update Contact',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[header(), buildContactForm(), updateButton()],
        ),
      ),
    );
  }
}
