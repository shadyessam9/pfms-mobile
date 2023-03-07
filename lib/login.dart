import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'arrivescan.dart';
import 'leavescan.dart';




class login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _login();
  }
}

class _login extends State<login> {

  final codeController = TextEditingController();

  bool visible = false ;


  Future userLogin(code) async{
    setState(() {
      visible = true ;
    });


    var url = "http://shadyabdelaziz-001-site1.ctempurl.com/api/personnel/${int.parse(code)}";

    var response = await http.get(Uri.parse(url));

    var message = response.statusCode;


    if(message == 200){

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("code", code);

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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("لا يوجد حساب بالكود الذي تم ادخاله"),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget  build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return  Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title:  const Text(
            'تسجيل الدخول',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'SF Display',
              fontSize: 25,
              color: Color(0xFFCC9966),
            ),
          ),
          shape:const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10))
          ),
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(10,MediaQuery.of(context).size.height*0.1,10,MediaQuery.of(context).size.height*0.1),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 50, 10, 20),
                      child: TextField(
                        controller: codeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'الكود'
                        ),
                      ),
                    ), Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color(0xFFCC9966),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                        ElevatedButton(
                       //   color: Colors.transparent,
                       //   splashColor: Colors.transparent,
                          child:
                          const Center(
                            child: Text(
                              'ادخال',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'SF Display',
                                fontSize: 16,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                          onPressed: (){
                            userLogin(codeController.text);
                          },
                        )),
                    Visibility(
                        visible: visible,
                        child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: const CircularProgressIndicator()
                        )
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom,
                    ),
                  ],
                ))
        )
    );
  }
}