import 'package:flutter/material.dart';
import 'package:smarthire/src/models/UserModel.dart';
import 'package:smarthire/src/repository/user_repository.dart';

class EditUserDialog extends StatefulWidget {
  final VoidCallback onChanged;
  UserModel userModel;


  EditUserDialog({Key key, this.onChanged,this.userModel}) : super(key:key);
      @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,
            useRootNavigator: false,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(
                      "Update Profile",
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          initialValue: widget.userModel.name,
                          decoration: getInputDecoration(hintText: "Full Name", labelText: "Full Name"),
                          validator: (input) => input.trim().length < 1 ? "Enter full name" : null,
                          onSaved: (input) => widget.userModel.name = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          initialValue: widget.userModel.mobile,
                          decoration: getInputDecoration(hintText: 'Silver', labelText: "Mobile"),
                          validator: (input) => input.trim().length < 3 ? "Mobile" : null,
                          onSaved: (input) => widget.userModel.mobile = input,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                      MaterialButton(
                        onPressed: _submit,
                        child: Text(
                          "Save",
                          style: TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  SizedBox(height: 10),
                ],
              );
            });
      },
      child: Text(
        "Edit",
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
        TextStyle(color: Theme.of(context).focusColor),
      ),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
        TextStyle(color: Theme.of(context).hintColor),
      ),
    );
  }

  void _submit() {
    if (_profileSettingsFormKey.currentState.validate()) {
      _profileSettingsFormKey.currentState.save();

      print("Calling");
      widget.onChanged();
      Navigator.of(context).pop();
    }
  }
}
