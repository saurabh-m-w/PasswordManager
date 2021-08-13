import 'package:flutter/material.dart';
import 'package:password_manager/PassModel.dart';
import 'package:password_manager/Screens/addpassword.dart';
import 'package:password_manager/Screens/viewpassword.dart';
import 'package:password_manager/Userprovider.dart';
import 'package:provider/provider.dart';

import '../apicalls.dart';
import '../constants.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
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

 // final bloc = PasswordBloc();


  @override
  void dispose() {
   // bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userauth=Provider.of<UserProvider>(context);
    var size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;

    // print(iconNames.indexOf('Icon 10'));

    void changeBrightness() {
      // DynamicTheme.of(context).setBrightness(
          Theme.of(context).brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark;

    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        elevation: 0,
        backgroundColor: kPrimaryLightColor,
        title: Text(
          "KeepSafe",
          style: TextStyle(
              fontFamily: "Title",
              fontSize: 32,
              color: primaryColor),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.wb_sunny,
              color: primaryColor,
            ),
            onPressed: () {
              changeBrightness();
            },
          ),
          PopupMenuButton<String>(
            color: kPrimaryLightColor,
            icon: Icon(Icons.more_vert,color: primaryColor,),

            onSelected: (String value) async {
              switch (value) {
                case 'Logout':
                  await userauth.signout();
                  break;
                case 'Settings':
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),

        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Expanded(
            child: FutureBuilder<List<dynamic>>(
              //stream: bloc.passwords,


              future: fetchmypasswords(userauth.uid,userauth.token),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        //Password password = snapshot.data[index];
                        int i = 0;
                        i = iconNames.indexOf(snapshot.data[index]["icon"]);
                        Color color = Colors.blue;//hexToColor(snapshot.data[index]["color"]);
                        return InkWell(
                          onTap: () {
                            Passmodel passmodel=new Passmodel(id:snapshot.data[index]["_id"],username:snapshot.data[index]["username"],appname:snapshot.data[index]["appname"],password:snapshot.data[index]["encryptedpass"],icon:snapshot.data[index]["icon"],color:snapshot.data[index]["color"]);
                            Navigator.push(context,MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ViewPassword(
                                          password: passmodel,
                                        )));
                          },
                          child: ListTile(

                            title: Text(
                              snapshot.data[index]["appname"],
                              style: TextStyle(
                                fontFamily: 'Title',
                              ),
                            ),
                            leading: Container(
                                height: 48,
                                width: 48,
                                child: CircleAvatar(
                                    backgroundColor: color, child: icons[i])),

                            subtitle: snapshot.data[index]["username"] != ""
                                ? Text(
                              snapshot.data[index]["username"],
                              style: TextStyle(
                                fontFamily: 'Subtitle',
                              ),
                            )
                                : Text(
                              "No username specified",
                              style: TextStyle(
                                fontFamily: 'Subtitle',
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        "No Passwords Saved. \nClick \"+\" button to add a password",
                        textAlign: TextAlign.center,
                        // style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AddPassword()));
          setState(() {

          });
        },
      ),
    );
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 9), radix: 16) + 0xFF000000);
  }
}
