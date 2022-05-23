import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {

  final String postUrl ;
  RecipeView({this.postUrl});


  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  String finalurl;
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {

    if(widget.postUrl.contains("http://")){
      finalurl = widget.postUrl.replaceAll("http://", "https://");
    } else{
        finalurl = widget.postUrl;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.blueGrey,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: Platform.isIOS? 60:30,
                  right: 25, left: 25, bottom: 15),
              color: Colors.lightGreen,
              width:  MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: kIsWeb ? MainAxisAlignment.start: MainAxisAlignment.center,
                children: [
                  Text(
                    "LunchBox", style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.amberAccent,
                  ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 80,
              width: MediaQuery.of(context).size.width,
              child: WebView(
                initialUrl: finalurl,
                javascriptMode:  JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController){
                  setState(() {
                    _controller.complete(webViewController);
                  });
                }),
            ),
          ],
        ),
      ),
    );
  }
}
