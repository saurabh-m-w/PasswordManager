
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:password_manager/constants.dart';

enum Status{ Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier{
  Status _status = Status.Uninitialized;


  String baseUrl="http://192.168.43.130:8080/";
  String _uid;
  String _token;

  Status get status => _status;
  String get uid => _uid;
  String get token => _token;

  UserProvider.initialize() {
    checkLogin();
  }

  Future<void> checkLogin() async {
    final storage = new FlutterSecureStorage();
    String token = await storage.read(key: "token");

    if(token==null)
      {
          print("no token found");
          _status=Status.Unauthenticated;
          notifyListeners();
      }
    else
      {
        _uid=await storage.read(key: "uid");
        print("token found");

          _status=Status.Authenticated;
          notifyListeners();
      }
  }

  Future<void> signout() async {
    final storage = new FlutterSecureStorage();
    await storage.deleteAll();
    print("signout");
    _status=Status.Unauthenticated;
    notifyListeners();
  }

  Future<List<dynamic>> login(username,password) async {

    //_status = Status.Authenticating;
    //notifyListeners();
    Map<String,String> body={
      "username":username,
      "password":password
    };
    Uri url=Uri.parse(serverUrl+"login");
    var response=await http.post(url,headers: {'Content-Type': 'application/json','Access-Control-Allow-Origin': '*'},body: json.encode(body));
    final parsed = json.decode(response.body);
    print(parsed);
    if(parsed["message"]=="Login successfully")
    {
      user_id=parsed["_id"];
      _uid=parsed["_id"];
      _token=parsed["token"];
      final storage = new FlutterSecureStorage();
      await storage.write(key: "token", value: parsed["token"]);
      await storage.write(key: "uid", value: parsed["_id"]);
      _status=Status.Authenticated;
      notifyListeners();
      return [true,"Login Successfully"];
    }
    else
      return [false,parsed["message"]];

  }

  Future<List<dynamic>> registeruser(body) async {

    Uri url=Uri.parse(serverUrl+"register");
    var response=await http.post(url,headers: {'Content-Type': 'application/json'},body: json.encode(body));
    final parsed = json.decode(response.body);
    print(parsed);

    if(parsed["success"]=="true")
    {
      user_id=parsed["user"]["_id"];
      return [true,"User added succesfully"];
    }
    else
      return [false,parsed["message"]];
  }

}