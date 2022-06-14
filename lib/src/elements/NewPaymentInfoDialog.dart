import 'package:flutter/material.dart';
import 'package:smarthire/src/models/CardInfo.dart';

class NewVehicleDialog extends StatefulWidget {
  final VoidCallback onChanged;
  CardInfo cardInfo;
  NewVehicleDialog({Key key, this.onChanged,this.cardInfo}) : super(key: key);

  @override
  _NewVehicleDialogState createState() => _NewVehicleDialogState();
}

class _NewVehicleDialogState extends State<NewVehicleDialog> {
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }
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
                    Icon(Icons.credit_card),
                    SizedBox(width: 10),
                    Text(
                    "New Payment Info",
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
                          initialValue: widget.cardInfo.card,
                          decoration: getInputDecoration(hintText: "Mobile", labelText: "Mobile"),
                          validator: (input) => input.trim().length < 8 ? "Enter Mobile" : null,
                          onSaved: (input) => widget.cardInfo.card = input,
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
       widget.cardInfo.id==null? "Add":"Edit",
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
