import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthire/constants/colors.dart';
import 'package:smarthire/constants/globals.dart' as globals;
import 'package:smarthire/model/service.dart';
import 'package:smarthire/pages/productadd/SecondScreen.dart';
import 'package:smarthire/pages/productadd/ThirdScreen.dart';

class FirstScreen extends StatefulWidget {

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double height;
  double width;
  String selectedService;
  String methodSelectedValue;

  List<String> services = [];
  List<int> serviceids = [];

  String _categoryerror="";

  @override
  void initState() {
    // TODO: implement initState
    for (int i = 0; i < globals.services.length; i++) {
      if(globals.services[i].type==globals.productUploadModel.product_type.toLowerCase()){
        services.add(globals.services[i].service_name);
        serviceids.add(globals.services[i].id);
      }

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: globals.darkmode?Colors.black:Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          "Add "+globals.productUploadModel.product_type,
          style: TextStyle(color: smarthireBlue),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: smarthireDark,
              size: 30.0,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:8.0),
        child: SingleChildScrollView(

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:   Text(globals.productUploadModel.product_type+ " Details",style: TextStyle(color: smarthireDark,fontSize: 20.0,fontFamily: "mainfont"),),
              ),
              serviceFieldWidget(),
              Container(

                child: Text(
                  _categoryerror,
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
              Form(
key: _formKey,
                child: Column(children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: new InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: globals.productUploadModel.product_type+" name",
                          labelStyle: TextStyle(color: smarthireDark),
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          filled: true,

                          hintStyle: new TextStyle(
                              color: smarthireDark,
                              fontFamily: 'mainfont',
                              fontSize: 14.0),
                          hintText: globals.productUploadModel.product_type+ " name",
                          fillColor: smarthireWhite),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:8.0,horizontal: 8.0),
                    child: TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.multiline,
                      minLines: 5, //Normal textInputField will be displayed
                      maxLines: 10,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: new InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "Description",
                          labelStyle: TextStyle(color: smarthireDark),
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          filled: true,

                          hintStyle: new TextStyle(
                              color: smarthireDark,
                              fontFamily: 'mainfont',
                              fontSize: 14.0),
                          hintText: "Description",
                          fillColor: smarthireWhite),
                    ),
                  ),

                  SizedBox(height: height*0.2,),
                  RaisedButton(
                    color: smarthireBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      setState(() {
                        _categoryerror="";
                      });
                      if (_formKey.currentState.validate()) {
                       _formKey.currentState.save();

                       if(selectedService!=null){
                         globals.productUploadModel.description=descriptionController.text;
                         globals.productUploadModel.service_name=nameController.text;
                         globals.productUploadModel.category_id=findId(selectedService).id;
                         if(globals.productUploadModel.product_type.toLowerCase()=="product"){
                           Navigator.push(context,
                               CupertinoPageRoute(builder: (context) => SecondScreen()));
                         }
                         else{
                           globals.productUploadModel.unit="service";
                           globals.productUploadModel.price='0';
                           globals.productUploadModel.quantity=1.toString();
                           Navigator.push(context,
                               CupertinoPageRoute(builder: (context) => ThirdScreen()));
                         }
                       }

                       else{
                         setState(() {
                           _categoryerror="Please select a Category";
                         });
                       }

                      }
                    },
                    child: Text("Next",style: TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: "mainfont"),),
                  )
                ],),
              ),
            ],
          ),
        ),
      ),
    )

    ;
  }

  ServiceModel findId(String name) =>
      globals.services.firstWhere((book) => book.service_name == name);


  Widget serviceFieldWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "Category",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  prefixIcon:
                  Icon(Icons.shopping_basket, color: smarthireDark)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text(
                    "Category",
                    style: TextStyle(
                        fontFamily: "mainfont",
                        color: smarthireDark,
                        fontWeight: FontWeight.w700),
                  ),
                  value: selectedService,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      selectedService = newValue;
                    });
                    print(selectedService);
                  },
                  items: services.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value.toUpperCase(),
                        style: TextStyle(
                            fontFamily: "mainfont",
                            color: smarthireDark,
                            fontWeight: FontWeight.w700),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
