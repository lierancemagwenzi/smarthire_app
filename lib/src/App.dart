import 'package:flutter/material.dart';
import 'package:smarthire/pages/app/home_screen.dart';
import 'package:smarthire/pages/auth/login_screen.dart';
import 'package:smarthire/pages/auth/veriry_screen.dart';
import 'package:smarthire/src/Route_generator.dart';
import 'package:smarthire/src/pages/Home.dart';
import 'package:smarthire/src/repository/user_repository.dart';
import 'package:smarthire/storage/SharedPreferences.dart';
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {


  bool done = false;
  var var1;
  int time = 0;

  @override
  void initState() {
    super.initState();
    getAppuser();
  }

  LoaderFunction() {
    time++;
  }

  getAppuser() async {
    var1 = await SharedPreferencesTest.getAppUser();
    print("getting details" + var1.toString());
    print(var1.length);
    setState(() {
      done = true;
      if (var1.length > 0) {
        currentuser.value.id = int.parse(var1[3]);
        currentuser.value.name = var1[0];
        currentuser.value.mobile = var1[1];
        currentuser.value.profile_pic = var1[2];

        // currentuser.value.id = 3;
        // currentuser.value.name = "John Doe";
        // currentuser.value.mobile = "6337338383";
        // currentuser.value.profile_pic = var1[2];

      } else {
        // currentuser.value.id = 3;
        // currentuser.value.name = "John Doe";
        // currentuser.value.mobile = "+2782801353";
        // currentuser.value.profile_pic = "23456";


      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return
       MaterialApp(
         debugShowCheckedModeBanner: false,
         onGenerateRoute: RouteGenerator.generateRoute,
         home: Scaffold(
          // body: HomeScreenCustomer(),
          body:!done?Center(child: CircularProgressIndicator()):Home()
      ),
       );
  }
}
