import 'dart:convert';
import 'package:qrscan/qrscan.dart' as scannery;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:numberpicker/numberpicker.dart';
import 'package:permission_handler/permission_handler.dart';

class scanner1 extends StatefulWidget {
  String sitename;
  int siteid;
  String sitetype;
  String action;
  scanner1({Key? key, required this.sitename, required this.siteid, required this.sitetype, required this.action}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _scanner1();}
}

class _scanner1 extends State<scanner1> {
  bool visiblepump = false;
  int _currentValue  = 1;
  String? sitename;
  int? siteid;
  String? sitetype;
  String? action;
  @override
  void initState() {
    super.initState();
    sitename=widget.sitename;
    siteid=widget.siteid;
    sitetype=widget.sitetype;
    action=widget.action;

    if(sitetype=="LD"){visiblepump = true;}else if (sitetype=="WH"){}
  }

  Future scan() async {

      await Permission.camera.request();
      String? barcode = await scannery.scan();
      int  pump = _currentValue;

      if(barcode == null){}else{
        var url = "http://shadyabdelaziz-001-site1.ctempurl.com/api/scan";

        var data = json.encode({"vehicle": int.parse(barcode), "site": siteid, "pump": pump, "type": action}) ;

        var response = await http.post(Uri.parse(url),headers: {
          "Accept": "application/json",
          "content-type":"application/json"
        }, body: data);

        var message = response.statusCode;

        if(message == 200){

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10.0)),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height*0.35,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline,color:Colors.green,size:50),
                          const SizedBox(height:10),
                          const Text(
                            'تمت العمليه بنجاح',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'SF Display',
                              fontSize: 25,
                              color: Color(0xFFCC9966),
                            ),
                          ),
                          const SizedBox(height:10),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "تم",
                                style: TextStyle(color: Colors.white),

                              ),

                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        }else if (message == 204){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10.0)), //this right here
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height*0.40,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.warning,color:Colors.red,size:50),
                          const SizedBox(height:10),
                          const Text(
                            'السياره موقوفه',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'SF Display',
                              fontSize: 25,
                              color: Color(0xFFCC9966),
                            ),
                          ),
                          const SizedBox(height:10),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "تم",
                                style: TextStyle(color: Colors.white),
                              ),
                          //    color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
            },
          );
        }else if (message == 400){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10.0)), //this right here
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height*0.40,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.warning,color:Colors.red,size:50),
                          const SizedBox(height:10),
                          const Text(
                            'عمليه غير مكتمله',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'SF Display',
                              fontSize: 25,
                              color: Color(0xFFCC9966),
                            ),
                          ),
                          const SizedBox(height:10),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "تم",
                                style: TextStyle(color: Colors.white),
                              ),
                          //    color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
            },
          );
        }
      }
  }



  @override
  Widget  build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return WillPopScope(
        onWillPop: () async => false,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                title:  const Center(
                  child:Text(
                    'وصول',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF Display',
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
                shape:const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
                brightness: Brightness.light,
                backgroundColor: const Color(0xFFCC9966),
                elevation: 0.0,
              ),
              body:  Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child:Text(
                        sitename!,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Display',
                          fontSize: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width:MediaQuery.of(context).size.width*0.3),
                    Row(
                        children: [
                          SizedBox(width:MediaQuery.of(context).size.width*0.06),
                          SizedBox(width:MediaQuery.of(context).size.width*0.3),
                          Visibility(
                              visible: visiblepump,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'رقم المضخه',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SF Display',
                                        fontSize: 20,
                                        color: Color(0xFFCC9966),
                                      ),
                                    ),
                                    const SizedBox(height:10),
                                    Container(
                                        width:MediaQuery.of(context).size.width*0.25,
                                        height:180,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffffffff),
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow:[BoxShadow(offset: const Offset(0,3), blurRadius: 6,color: const Color(0xff000000).withOpacity(0.16),)],),
                                        child: Center(
                                          child:  Padding(
                                              padding: const EdgeInsets.all(1),
                                              child: NumberPicker(
                                                  decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      shape: BoxShape.rectangle,
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(10),
                                                        topRight: Radius.circular(10),
                                                        bottomRight: Radius.circular(10),
                                                        bottomLeft: Radius.circular(10),
                                                      ),
                                                      border: Border.all(width:0.5, color: const Color(0xFFCC9966))
                                                  ),
                                                  value: _currentValue,
                                                  minValue: 1,
                                                  maxValue: 20,
                                                  onChanged: (newValue) =>
                                                      setState(() => _currentValue = newValue))
                                          ),
                                        )
                                    )
                                  ]
                              )
                          )
                        ]
                    ),
                    Padding(
                        padding: const EdgeInsets.all(50),
                        child:Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          height: MediaQuery.of(context).size.height*0.1,
                          decoration: const BoxDecoration(
                              color: Color(0xFFCC9966),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)
                              )),
                          child: ElevatedButton(
                         //     color: Colors.transparent,
                         //     textColor: Colors.white,
                         //     splashColor: Colors.transparent,
                              onPressed: scan,
                              child: const Text('SCAN',style: TextStyle(color: Colors.black, fontSize: 30))
                          ),

                        )
                    )
                  ],
                ),
              )
          ),
        )
    );
  }

}
