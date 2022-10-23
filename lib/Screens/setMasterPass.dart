import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_manager/Screens/homepage.dart';
import 'package:password_manager/Userprovider.dart';
import 'package:password_manager/apicalls.dart';
import 'package:password_manager/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class SetMasterPassword extends StatefulWidget {
  @override
  _SetMasterPasswordState createState() => _SetMasterPasswordState();
}

class _SetMasterPasswordState extends State<SetMasterPassword> {
  TextEditingController masterPassController = TextEditingController();

  Future<Null> getMasterPass() async {
    final storage = new FlutterSecureStorage();
    String masterPass = await storage.read(key: 'masterpass') ?? '';
    masterPassController.text = masterPass;
  }

  String hashpass(String pass) {
    var bytes = utf8.encode(pass); // data being hashed
    var digest = sha1.convert(bytes);

    //print("Digest as bytes: ${digest.bytes}");
    print("Digest as hex string: $digest");
    return digest.toString();
  }

  saveMasterPass(String masterPass) async {
    final storage = new FlutterSecureStorage();

    await storage.write(key: 'masterpass', value: masterPass);
  }

  // authenticate() async {
  //   var localAuth = LocalAuthentication();
  //   bool didAuthenticate = await localAuth.authenticateWithBiometrics(
  //       localizedReason: 'Please authenticate to change master password',
  //       stickyAuth: true);
  //
  //   if (!didAuthenticate) {
  //     Navigator.pop(context);
  //   }
  //
  //   print(didAuthenticate);
  // }

  @override
  void initState() {
    super.initState();
    //authenticate();
    getMasterPass();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;
    final userauth = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                margin: EdgeInsets.only(top: size.height * 0.05),
                child: Text("Master Password",
                    style: TextStyle(
                        fontFamily: "Title",
                        fontSize: 32,
                        color: primaryColor))),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                  "Set Master Passwords to encrypt your all passwords. Keep your Master Password safe with you. We never save your master password on cloud.",
                  style: TextStyle(
                      fontSize: 16,
                      // color: Colors.black54,
                      fontStyle: FontStyle.italic,
                      fontFamily: "Subtitle"))),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                obscureText: true,
                maxLength: 32,
                decoration: InputDecoration(
                    labelText: "Master Pass",
                    labelStyle: TextStyle(fontFamily: "Subtitle"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16))),
                controller: masterPassController,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SizedBox(
                width: size.width * 0.7,
                height: 60,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  color: primaryColor,
                  child: Text(
                    "CONFIRM",
                    style: TextStyle(color: Colors.white, fontFamily: "Title"),
                  ),
                  onPressed: () async {
                    if (masterPassController.text.isNotEmpty) {
                      String hasedpass =
                          hashpass(masterPassController.text.trim());
                      saveMasterPass(masterPassController.text.trim());

                      Map<String, String> body = {
                        "id": userauth.uid,
                        "hashmaster": hasedpass
                      };
                      showLoaderDialog(context);
                      bool isset = await setmasterpass(body);
                      Navigator.pop(context);

                      if (isset) {
                        Fluttertoast.showToast(
                            msg: "Master password has set successfully ",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => home()));
                      } else {
                        Fluttertoast.showToast(
                            msg: "Something went wrong",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "Error!",
                                style: TextStyle(fontFamily: "Title"),
                              ),
                              content: Text(
                                "Please enter valid Master Password.",
                                style: TextStyle(fontFamily: "Subtitle"),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text("CLOSE"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
