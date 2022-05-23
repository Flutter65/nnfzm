import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lunchbox2/models/recipe_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunchbox2/views/recipe_view.dart';
import 'package:url_launcher/url_launcher.dart';


class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<RecipeModel> recipes= new List<RecipeModel>();

  TextEditingController textEditingController = new TextEditingController();


  getRecipes (String query) async{

    final String link =
        "https://api.edamam.com/search?q=$query&app_id=7f539d94&app_key=c5d989f43774ab1b53a19224bb6166d1&";
    final Uri url = Uri.parse(link);


    var response = await http.get(url);
    Map<String,dynamic> jsonData = jsonDecode(response.body);

    jsonData["hits"].forEach((element) {
      //print(element.toString());

      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipes.add(recipeModel);

      setState(() {});

    });

    print("${recipes.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xff213A55),
                  const Color(0xff071930),
                  ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: Platform.isIOS? 60:75,
                  horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                  SizedBox(height: 30,),
                  Text(
                    "Bugün menüde ne var?",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.amber
                  ),
                  ),
                  SizedBox(height: 12,
                  ),
                  Text(
                    "Siz elinizde ne olduğunu söyleyin, gerisini bana bırakın : )",
                  style: TextStyle(
                      fontSize: 15,
                    color: Colors.amber
                  ),
                  ),
                  SizedBox(height: 12,
                  ),
                  Text(
                    "Birden fazla malzeme girmek için aralara virgül koymanız yeterli.",
                    style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: Colors.amber
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              hintText: "Elimde...",
                              hintStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.white.withOpacity(0.5)
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                        SizedBox(width: 15,),
                        InkWell(
                          onTap: (){
                               if(textEditingController.text.isNotEmpty){
                                 getRecipes(textEditingController.text);
                                 print("Bakalım neler varmış");
                                 }else{
                                 print("Hiçbişi yok");
                                 }
                                },
                          child: Container(
                            child: Icon(Icons.search),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    child: GridView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150, mainAxisSpacing: 15.0,
                      ),
                      children: List.generate(recipes.length, (index) {
                        return GridTile(
                          child: RecipeTile(
                            title: recipes[index].label,
                            desc: recipes[index].source,
                            imgUrl: recipes[index].image,
                            url: recipes[index].url,
                      ));
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}

class RecipeTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipeTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              print(widget.url + " bu bağlantıya gideceğiz");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                        postUrl: widget.url,
                      )));
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Overpass'),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontFamily: 'OverpassRegular'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
class GradientCard extends StatelessWidget {
  final Color topColor;
  final Color bottomColor;
  final String topColorCode;
  final String bottomColorCode;

  GradientCard(
      {this.topColor,
        this.bottomColor,
        this.topColorCode,
        this.bottomColorCode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  height: 160,
                  width: 180,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [topColor, bottomColor],
                          begin: FractionalOffset.topLeft,
                          end: FractionalOffset.bottomRight)),
                ),
                Container(
                  width: 180,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          topColorCode,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          bottomColorCode,
                          style: TextStyle(fontSize: 16, color: bottomColor),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

