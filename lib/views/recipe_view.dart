import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
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
    var safePadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top:Radius.circular(20),
              bottom:Radius.circular(20)),
        ),

        title: const Text('LunchBox'),
        centerTitle: true,
        //backgroundColor: Colors.grey,

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey, Colors.indigoAccent],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
        elevation: 50,

        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: (){
            print('Ayarlar Butonu');
          },
        ),


        actions: [
          IconButton(
            color: Colors.red.shade400,
              onPressed: (){
              Share.share(finalurl
              );
              },
              icon: const Icon(Icons.share),
          ),
          IconButton(
              color: Colors.red.shade400,
              onPressed: (){
              },
              icon:const Icon(Icons.search_sharp)
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Paylaşma aksiyonu');
        },
        child: const Text('Paylaş!'),
        backgroundColor: Colors.redAccent[500],
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.blueGrey,
        child:Container(
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
      ),
    );
  }
}
