import 'package:contact_manager/screens/add_new_contect/bloc/new_contact_bloc.dart';
import 'package:contact_manager/widgets/common_body.dart';
import 'package:contact_manager/widgets/text_field/add_contect_textfield.dart';
import 'package:contact_manager/widgets/text_field/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddNewContact extends StatefulWidget {
  @override
  _AddNewContactState createState() => _AddNewContactState();
}

class _AddNewContactState extends State<AddNewContact> {


  @override
  void initState() {
    super.initState();
    newContactBloc.init();
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
      newContactBloc.dobSink(formatted);
    }

    Widget header({String name, String email}) {
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
              stream: newContactBloc.profilePicStream,
      builder: (context, snapshotImageFile) {
                if(snapshotImageFile.hasData){
                  print('snapshotImageFile.hasData: ${snapshotImageFile.data}');
                }

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
                  onTap: newContactBloc.uploadImage,
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
                AddContactTextField(
                  label: 'Name',
                  stream: newContactBloc.nameStream,
                  onChange: newContactBloc.nameSink,
                ),
                GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: StreamBuilder(
                          stream: newContactBloc.dobStream,
                          builder: (context, snapshotDate) {
                        return CommonTextField(
                          label: 'Date of Birth',
                          initialValue: snapshotDate.hasData ? snapshotDate.data : '',
                        );
                      }),
                    )),
                AddContactTextField(
                  label: 'Mobile No',
                  keyboardType: TextInputType.number,
                  stream: newContactBloc.mobNoStream,
                  onChange: newContactBloc.mobNoSink,
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget saveButton() {
      return Padding(
        padding: EdgeInsets.all(20),
        child: StreamBuilder<bool>(
          stream: newContactBloc.submitCheck,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: !snapshot.data?null:() {
                  //addEventBloc.saveEvent();
                  newContactBloc.saveContactData();
                  Navigator.of(context).pop();
                },
                padding: EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                ),
                color: !snapshot.data?Colors.grey:Colors.black,
                child: Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              );
            }
            return CircularProgressIndicator();
          }
        ),
      );
    }

    return CommonBodyStructure(
      text: 'Add New Contacts',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[header(email: "v@v.com", name: 'Vikas'), buildContactForm(), saveButton()],
        ),
      ),
    );
  }
}
