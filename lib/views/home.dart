import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lunchbox/models/recipe_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunchbox/views/recipe_view.dart';
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFEEEEEE),
                  Color(0xFF9E9E9E),
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
                        color: Colors.redAccent.shade700,
                      ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  Text(
                    "Bugün menüde ne var?",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade900
                  ),
                  ),
                  const SizedBox(height: 12,
                  ),
                  Text(
                    "Siz elinizde ne olduğunu söyleyin, gerisini bana bırakın : )",
                  style: TextStyle(
                      fontSize: 18,
                    color: Colors.grey.shade900
                  ),
                  ),
                  const SizedBox(height: 12,
                  ),
                  Text(
                    "Birden fazla malzeme girmek için aralara virgül koymanız yeterli.",
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade900
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                        decoration: new BoxDecoration(
                            color: Colors.lightBlueAccent.shade100.withOpacity(0.3),
                            borderRadius: BorderRadius.all(Radius.circular(5),
                            ),
                        ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left:15),
                                hintText: "Buyur burdan yaz...",
                                hintStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.redAccent.withOpacity(0.7)
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.red.withOpacity(1),
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
                  ),
                  SizedBox(height: 20,),
                  Container(
                    child: GridView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150, mainAxisSpacing: 100.0,
                        crossAxisSpacing: 30,
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
            padding: EdgeInsets.symmetric(vertical: 10),
            margin: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: 300,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: <Widget>[
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'Overpass'),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
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
                  decoration: const BoxDecoration(
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
                          style: const TextStyle(fontSize: 16, color: Colors.black54),
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

