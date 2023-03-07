import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pfms/login.dart';
import 'arrivescan.dart';
import 'leavescan.dart';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main(){
     HttpOverrides.global = MyHttpOverrides();
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      )
  );
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool visible = false ;

  Future<void> check() async {

    setState(() {
      visible = true ;
    });

    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = "http://shadyabdelaziz-001-site1.ctempurl.com/api/personnel/${prefs.getString('code')}";

    var response = await http.get(Uri.parse(url));

    var message = response.statusCode;


    if(message == 200){
      setState(() {
        visible = false;
      });


      Map<String, dynamic> data = jsonDecode(response.body);

      var sitename = data['p_name'];
      var siteid = data['site'];
      var sitetype = data['site_type'];
      var action = data['type'];



      if(data['type']=="A"){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => scanner1(siteid:siteid,sitename: sitename,sitetype:sitetype,action:action)));
      }else if (data['type']=="L"){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => scanner2(siteid:siteid,sitename: sitename,action:action)));
      }

    }else{
      setState(() {
        visible = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => login()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
            () => check());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:Padding(
            padding: EdgeInsets.fromLTRB(40,MediaQuery.of(context).size.height*0.15,40,MediaQuery.of(context).size.height*0.25),
            child: Column(
                children: [
                   Center(
                      child:  Image.asset('assets/images/logo-icon.png')
                  ),
                  const Center(
                      child:Text(
                        'مرحبا',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Display',
                          fontSize: 40,
                          color: Color(0xFFCC9966),
                        ),
                      )
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                      visible: visible,
                      child: Container(
                          margin: const EdgeInsets.only(bottom: 30),
                          child: const CircularProgressIndicator()
                      )
                  )
                ]
            )
        )
    );
  }
}
