import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_manager/Userprovider.dart';
//import 'package:local_auth/local_auth.dart';
import 'package:password_manager/apicalls.dart';
import 'package:password_manager/constants.dart';
import 'package:password_manager/random_string.dart';
import 'package:password_strength/password_strength.dart';
//import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class AddPassword extends StatefulWidget {
  AddPassword({Key key}) : super(key: key);

  _AddPasswordState createState() => _AddPasswordState();
}

class _AddPasswordState extends State<AddPassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController appNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  Color pickedColor;
  //var localAuth = LocalAuthentication();

  encrypt.Encrypted encrypted;
  String keyString = "";
  String encryptedString = "";
  String decryptedString = "";
  String masterPassString = "";
  int pickedIcon;

  List<Icon> icons = [
    Icon(Icons.account_circle, size: 28, color: Colors.white),
    Icon(Icons.add, size: 28, color: Colors.white),
    Icon(Icons.access_alarms, size: 28, color: Colors.white),
    Icon(Icons.ac_unit, size: 28, color: Colors.white),
    Icon(Icons.accessible, size: 28, color: Colors.white),
    Icon(Icons.account_balance, size: 28, color: Colors.white),
    Icon(Icons.add_circle_outline, size: 28, color: Colors.white),
    Icon(Icons.airline_seat_individual_suite, size: 28, color: Colors.white),
    Icon(Icons.arrow_drop_down_circle, size: 28, color: Colors.white),
    Icon(Icons.assessment, size: 28, color: Colors.white),
  ];

  List<String> iconNames = [
    "Icon 1",
    "Icon 2",
    "Icon 3",
    "Icon 4",
    "Icon 5",
    "Icon 6",
    "Icon 7",
    "Icon 8",
    "Icon 9",
    "Icon 10",
  ];

  List<Color> colors = [
    Colors.red,
    // Color(0xffd5563a),
    Color(0xffcf5a3b),
    // Color(0xffca5d3c),
    // Color(0xffc6603d),
    // Color(0xffc0643d),
    Color(0xffba673e),
    // Color(0xffb66a3f),
    // Color(0xffb36c3f),
    // Color(0xffaf6e40),
    Color(0xffa87341),
    // Color(0xffa47642),
    Color(0xffa07842),
    // Color(0xff9b7b43),
    // Color(0xff967f44),
    // Color(0xff908245),
    Color(0xff8b8646),
    // Color(0xff858a47),
    Color(0xff808d47),
    // Color(0xff799249),
    // Color(0xff769349),
    // Color(0xff72964a),
    Color(0xff6d994a),
    // Color(0xff6c9a4a),
    // Color(0xff659e4c),
    // Color(0xff639f4c),
    Color(0xff5ea34d),
    // Color(0xff5ba44d),
    Color(0xff58a64e),
    // Color(0xff53aa4e),
    Colors.green
  ];

  // Future<Null> getMasterPass() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String masterPass = prefs.getString('master') ?? "";
  //   masterPassString = masterPass;
  // }

  Future<Null> getMasterPass() async {
    final storage = new FlutterSecureStorage();
    String masterPass = await storage.read(key: 'masterpass') ?? '';
    masterPassString = masterPass;
    //print(masterPassString);
  }

  // authenticate() async {
  //   try {
  //     var localAuth = LocalAuthentication();
  //     print(await localAuth.getAvailableBiometrics());
  //     bool didAuthenticate = await localAuth.authenticateWithBiometrics(
  //       localizedReason: 'Please authenticate to add new password',
  //     );
  //
  //     print(didAuthenticate);
  //
  //     if (didAuthenticate == false) {
  //       Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(
  //               builder: (BuildContext context) => PasswordHomepage()),
  //               (Route<dynamic> route) => false);
  //     }
  //   } on PlatformException catch (e) {
  //     if (e.code == auth_error.notAvailable) {
  //       // Handle this exception here.
  //     }
  //   }
  // }

  double passwordStrength = 0.0;
  Color passwordStrengthBarColor = Colors.red;
  bool obscureText = true;
  String show_hide = 'Show Password';
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    pickedColor = Colors.red;
    getMasterPass();

    pickedIcon = 0;
    // authenticate();
    super.initState();
  }

  checkPassStrength(String pass) {
    setState(() {
      passwordStrength = estimatePasswordStrength(pass);
      Color passwordStrengthBarColor = Colors.red;
      if (passwordStrength < 0.4) {
        passwordStrengthBarColor = Colors.red;
      } else if (passwordStrength > 0.4 && passwordStrength < 0.7) {
        passwordStrengthBarColor = Colors.deepOrangeAccent;
      } else if (passwordStrength < 0.7) {
        passwordStrengthBarColor = Colors.orange;
      } else if (passwordStrength > 0.7 || passwordStrength == 0.7) {
        passwordStrengthBarColor = Colors.green;
      }
      setState(() {
        this.passwordStrengthBarColor = passwordStrengthBarColor;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;
    final userauth=Provider.of<UserProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                margin: EdgeInsets.only(top: size.height * 0.05),
                child: Text(
                  "Add Password",
                  style: TextStyle(
                      fontFamily: "Title", fontSize: 32, color: primaryColor),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter valid title';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: TextStyle(fontFamily: "Subtitle"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16))),
                      controller: appNameController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter valid Username';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "User Name/Email (if available)",
                          labelStyle: TextStyle(fontFamily: "Subtitle"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16))),
                      controller: userNameController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      // validator: (value) {
                      //   if (value.isEmpty) {
                      //     return 'Please enter valid password';
                      //   }
                      // },
                      onChanged: (pass) {
                        checkPassStrength(pass);
                      },
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        // errorText: 'Please enter valid password',
                        labelText: "Password",
                        labelStyle: TextStyle(fontFamily: "Subtitle"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      controller: passwordController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            String pass = randomAlphaNumeric(10);
                            passwordController.text = pass;
                            checkPassStrength(pass);
                          },
                          child: Text('Generate'),
                        ),
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                              if (obscureText) {
                                show_hide = 'Show Password';
                              } else {
                                show_hide = 'Hide Password';
                              }
                            });
                          },
                          child: Text(show_hide),
                        ),
                        FlatButton(
                          onPressed: () {
                            Clipboard.setData(new ClipboardData(
                                text: passwordController.text));
                            scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Copied to Clipboard"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Text('Copy'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text('Strength '),
                          Container(
                            height: 10,
                            width: passwordStrength == 0
                                ? 5
                                : MediaQuery.of(context).size.width *
                                passwordStrength,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: passwordStrengthBarColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0),
                          child: Text(
                            "Pick an Icon",
                            style: TextStyle(
                                fontFamily: 'Title',
                                fontSize: 20,
                                color: primaryColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0),
                          child: Material(
                            shape: CircleBorder(),
                            elevation: 4.0,
                            child: CircleAvatar(
                                backgroundColor: pickedColor,
                                radius: 25,
                                child: icons[pickedIcon]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0, 24, 10),
                    child: GridView.count(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 5,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 15,
                        childAspectRatio: 1.3,
                        children: List.generate(icons.length, (index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                pickedIcon = index;
                              });
                            },
                            child: Material(
                                elevation: 0.0,
                                color: pickedColor,
                                shape: CircleBorder(),
                                child: icons[index]),
                          );
                        })),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Pick a Color",
                            style: TextStyle(
                                fontFamily: 'Title',
                                fontSize: 20,
                                color: primaryColor),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _openColorPicker();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0),
                            child: Material(
                                shape: CircleBorder(),
                                elevation: 4.0,
                                child: CircleAvatar(
                                  backgroundColor: pickedColor,
                                  radius: 25,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 100,
        backgroundColor: primaryColor,
        icon: Icon(Icons.add),
        label: Text('Add'),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            encryptPass(passwordController.text);
            Map<String,String> pass={
              "id":userauth.uid,
              "username":userNameController.text,
              "appname": appNameController.text,
              "icon": iconNames[pickedIcon],
              "color": "#" + pickedColor.value.toRadixString(16),
              "encryptedpass": encryptedString
            };
            showLoaderDialog(context);
           bool isstored=await storepassword(pass,userauth.token);
           Navigator.pop(context);
           if(isstored)
             {
               Fluttertoast.showToast(
                   msg: "Password stored successfully",
                   toastLength: Toast.LENGTH_SHORT,
                   gravity: ToastGravity.CENTER,
                   timeInSecForIosWeb: 1,
                   backgroundColor: Colors.green,
                   textColor: Colors.white,
                   fontSize: 16.0
               );

               Navigator.pop(context);
             }
            // DBProvider.db.newPassword(password);
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //         builder: (BuildContext context) => PasswordHomepage()),
            //         (Route<dynamic> route) => false);
          } else {
            // print(Theme.of(context).accentColor);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _openColorPicker() async {
    Color _tempShadeColor = pickedColor;
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text("Color picker"),
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  pickedColor = _tempShadeColor;
                });
              },
            ),
          ],
          content: MaterialColorPicker(
            allowShades: true,
            selectedColor: _tempShadeColor,
            onColorChange: (color) => setState(() => _tempShadeColor = color),
            onMainColorChange: (color) =>
                setState(() => _tempShadeColor = color),
          ),
        );
      },
    );
  }

  encryptPass(String text) {
    keyString = masterPassString;

    if (keyString.length < 32) {
      int count = 32 - keyString.length;
      for (var i = 0; i < count; i++) {
        keyString += ".";
      }
    }
    final key = encrypt.Key.fromUtf8(keyString);
    final plainText = text;
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final e = encrypter.encrypt(plainText, iv: iv);
    encryptedString = e.base64.toString();
  }
}
