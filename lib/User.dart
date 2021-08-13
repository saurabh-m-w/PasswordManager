class User{

  String name;
  String emailorphone;
  String token;

  User({this.name,this.emailorphone,this.token});

  factory User.fromJson(Map<String,dynamic> responsedata){
    return User(
      name: responsedata['name'],
      emailorphone: responsedata['emailorphone'],
      token: responsedata['token']
    );
  }
}