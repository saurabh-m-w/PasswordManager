import 'package:flutter/material.dart';
import 'package:password_manager/Screens/Login/login_screen.dart';
import 'package:password_manager/Screens/Signup/signup_screen.dart';
import 'package:password_manager/Screens/Welcome/components/background.dart';
import 'package:password_manager/components/rounded_button.dart';
import 'package:password_manager/constants.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Container( 
      padding: EdgeInsets.all(10),
      width: size.width>500?500:size.width,
      child: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "WELCOME TO KeepSafe",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
              ),
              SizedBox(height: size.height * 0.05),
              SvgPicture.asset(
                "assets/icons/chat.svg",
                height: size.height * 0.45,
              ),
              SizedBox(height: size.height * 0.05),
              RoundedButton(
                text: "LOGIN",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
              ),
              RoundedButton(
                text: "SIGN UP",
                color: kPrimaryLightColor,
                textColor: Colors.black,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
