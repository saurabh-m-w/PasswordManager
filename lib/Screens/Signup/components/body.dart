import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_manager/Screens/Login/login_screen.dart';
import 'package:password_manager/Screens/Signup/components/background.dart';
import 'package:password_manager/Screens/setMasterPass.dart';
import 'package:password_manager/Userprovider.dart';
import 'package:password_manager/apicalls.dart';
import 'package:password_manager/components/already_have_an_account_acheck.dart';
import 'package:password_manager/components/rounded_button.dart';
import 'package:password_manager/components/rounded_input_field.dart';
import 'package:password_manager/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:password_manager/constants.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  String name;
  String email;
  String phone;
  String password;

  @override
  Widget build(BuildContext context) {
    final userauth=Provider.of<UserProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      width: size.width>500?500:size.width,
      child: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "SIGNUP",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/signup.svg",
                height: size.height * 0.25,
              ),
              RoundedInputField(
                hintText: "Your Name",
                onChanged: (value) {
                    setState(() {
                      name=value;
                    });
                },
              ),
              RoundedInputField(
                hintText: "Your Email",
                onChanged: (value) {
                  setState(() {
                    email=value;
                  });
                },
              ),
              RoundedInputField(
                hintText: "Your Phone",
                onChanged: (value) {
                    setState(() {
                      phone=value;
                    });
                },
              ),
              RoundedPasswordField(
                onChanged: (value) {
                  password=value;
                },
              ),
              RoundedButton(
                text: "SIGNUP",
                press: () async {
                      Map<String,String> body={
                        "name":name,
                        "email":email,
                        "phone":phone,
                        "password":password,
                      };
                      showLoaderDialog(context);
                      List<dynamic> response=await register(body);
                      Navigator.pop(context);

                      if(response[0])
                        {
                          Fluttertoast.showToast(
                              msg: response[1],
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                          List<dynamic> response2 =await userauth.login(email,password);

                          Navigator.pop(context);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SetMasterPassword()));
                        }
                          else{
                            Fluttertoast.showToast(
                            msg: response[1],
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                            );
                          }

                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
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


            ],
          ),
        ),
      ),
    );
  }
}
