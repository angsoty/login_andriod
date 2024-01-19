import 'dart:convert';
import 'package:login_andriod/models/request/LoginRequest.dart';
import 'package:login_andriod/models/response/LoginResponse.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storage = LocalStorage("USER_SEASON");
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  bool isLoading =false;
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  // void showInStackBar(String value){
  //   _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  // }


  login() async{
    setState(() {
      isLoading = true;
    });
    LoginRequest req = LoginRequest();
    var username = _usernameController.text;
    var password = _passwordController.text;
    req.password = password;
    req.username = username;
    var url = Uri.parse("https://dummyjson.com/auth/login");
    var response = await http.post(url,body: req.toJson());
    if(response.statusCode == 200){

      var map = jsonDecode(response.body);
      var user = LoginResponse.fromJson(map);
      setState(() {
        isLoading = false;
      });
      storage.setItem("USER_NAME", user.username );
      storage.setItem("EMAIL", user.email);
      storage.setItem("TOKEN", user.token);

      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }else{
      print("can not login!");
      setState(() {
        isLoading = false;
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
    _usernameController.text = "kminchelle";
    _passwordController.text = "0lelplR";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green[200],
        title: const Text(
          "Login",
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Form(
        key: _keyForm,
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 15),
              child: TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),

                  ),
                  labelText: "Username",
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Enter your Username!";

                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 20),
              child: TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  labelText: "Password",
                ),
                validator: (value){
                  if(value ==null || value.isEmpty){
                    return "Enter your Password!";

                  }
                  return null;
                },
              ),
            ),
            isLoading == true ? Container(
              decoration: BoxDecoration(
                  color: Colors.deepPurple[200],
                  borderRadius: BorderRadius.circular(20)),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(right: 125, left: 125, top: 30),
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            ): InkWell(
              onTap: (){

                if(_keyForm.currentState!.validate()){
                  login();
                }
              }
              ,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.deepPurple[200],
                    borderRadius: BorderRadius.circular(20)),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(right: 125, left: 125, top: 30),
                child: const Text(
                  'Login',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(
                right: 16,
                left: 16,
              ),
              child: const Text(
                'Forgot Password?',
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
