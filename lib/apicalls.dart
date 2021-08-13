import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:password_manager/constants.dart';


String baseUrl="http://192.168.43.130:8080/";

// Future<List<dynamic>> login(username,password) async {
//
//
//   Map<String,String> body={
//     "username":username,
//     "password":password
//   };
//   Uri url=Uri.parse(baseUrl+"login");
//   var response=await http.post(url,headers: {'Content-Type': 'application/json','Access-Control-Allow-Origin': '*'},body: json.encode(body));
//   final parsed = json.decode(response.body);
//   print(parsed);
//   if(parsed["message"]=="Login successfully")
//     {
//       user_id=parsed["_id"];
//       return [true,"Login Successfully"];
//     }
//   else
//     return [false,parsed["message"]];
//
// }

Future<List<dynamic>> register(body) async {

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
Future<void> addpassword(body) async {
  Uri url=Uri.parse(serverUrl+"storePass");
  var response=await http.post(url,headers: {'Content-Type': 'application/json'},body: json.encode(body));
  final parsed = json.decode(response.body);

  print(parsed);
}

Future<bool> setmasterpass(body) async {
  Uri url=Uri.parse(serverUrl+"setmasterpass");
  var response=await http.post(url,headers: {'Content-Type': 'application/json'},body: json.encode(body));
  final parsed = json.decode(response.body);
  print(parsed);

  return parsed["success"];
}
Future<bool> checkmasterpass(body) async {
  Uri url=Uri.parse(serverUrl+"checkmasterpass");
  var response=await http.post(url,headers: {'Content-Type': 'application/json'},body: json.encode(body));
  final parsed = json.decode(response.body);
  print(parsed);

  return parsed["success"];
}



Future<List> fetchmypasswords(String _id,String token) async {
  print(_id);
  Uri url=Uri.parse(serverUrl+"mypass/"+_id);
  var response=await http.get(url,headers: {'x-access-token': token});
  final parsed = json.decode(response.body);
  print(parsed);

  return parsed["data"];
}

Future<bool> storepassword(body,String token) async {
  Uri url=Uri.parse(serverUrl+"storePass");
  var response=await http.post(url,headers: {'Content-Type': 'application/json','x-access-token': token},body: json.encode(body));
  final parsed = json.decode(response.body);
  print(parsed);

  if(parsed["success"]=="false")
    {
      return false;
    }
  else
      return true;
}