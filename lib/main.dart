import 'package:flutter/material.dart';
import 'package:password_manager/Screens/homepage.dart';
import 'package:password_manager/Screens/setMasterPass.dart';
import 'package:password_manager/User.dart';
import 'package:password_manager/Userprovider.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/splash.dart';
import 'package:provider/provider.dart';

import 'Screens/Welcome/welcome_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: UserProvider.initialize())
        ],
        child: MyApp()),
  );
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light
      ),
      //theme: ThemeData.dark(),
      home: ProviderPage(),
    );
  }
}

class ProviderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context,UserProvider auth,child){
          switch(auth.status){
            case Status.Uninitialized :
              return SplashScreen();
            case Status.Authenticating:
            case Status.Unauthenticated:
              return WelcomeScreen();
            case Status.Authenticated:
              return home();
          }
    },);
  }
}




