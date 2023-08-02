import 'package:ecommerce/components/SigninAndSignup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget{

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var isUserLoggedIn = false;

  Future<void> checkUser() async {
    var pref = await SharedPreferences.getInstance();
    var token = await pref.getString("authToken");

    if (token != null) {
      isUserLoggedIn = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),

      body: FutureBuilder<void>(
        future: checkUser(),
        builder: (context , snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          else if(!isUserLoggedIn){
            return SigninAndSignup();
          }
          else{
            return Container(
                child : Text("hi")
            );
          }
        },
      )
      ,
    );
  }
}
