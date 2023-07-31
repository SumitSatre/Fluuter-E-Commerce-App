import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _isCategoryDataFetched = false;
  List<Widget> CarouselImages = [];

  var CategoryData = [];
  var ProductData = [];

  void fetchData () async {
    // This is used to fetch category name and image
    var response = await http.get(Uri.parse("https://flutter-app-backend-qy7f.onrender.com/api/categories"));
    var responseData = json.decode(response.body);

    if(responseData["success"]){
        if(!_isCategoryDataFetched){
          setState(() {
            CategoryData = responseData["CategoryData"];
            _isCategoryDataFetched = true;
          });
        }
    }


    var responseProducts = await http.get(Uri.parse("https://flutter-app-backend-qy7f.onrender.com/api/products"));
    var responseDataProducts = json.decode(responseProducts.body);

    if(responseDataProducts["success"]){
      if(!_isCategoryDataFetched){
        setState(() {
          ProductData = responseDataProducts["productsData"];
        });
      }
    }
  }

  // This is used to fetch product items
  void fetchProductData(product) async {
    var response = await http.post(
      Uri.parse("https://flutter-app-backend-qy7f.onrender.com/api/products"),
      headers: {
        'Content-Type': 'application/json',
        },

    );
  }

  @override
  void initState() {
    super.initState();

    CarouselImages.addAll([
      Image.network("https://source.unsplash.com/random/900x700/?fashion"),
      Image.network("https://source.unsplash.com/random/900x700/?girl"),
      Image.network("https://source.unsplash.com/random/900x700/?women"),
    ]);

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(20,110,180 ,1),
        title: const Text(
          "QuickShop",
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
            children: [

              // Categories
              Card(
                child: Container(
                  padding: EdgeInsets.only(top: 15 , bottom: 15),
                  color: Colors.white,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Row(
                      children: CategoryData != [] ?
                      CategoryData.map((value){
                        return Container(
                          padding: EdgeInsets.all(3),
                          margin: EdgeInsets.only(right: 5),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(value["imageUrl"]),
                                radius: 35,
                              ),

                              SizedBox(height: 8,),

                              Text(value["category"])
                            ],
                          ),
                        );
                      } ).toList()
                      : [Center(child: Text("No Data"))],
                    ),
                  ),
                ),
              ),

              // Carousel

              Column(
                children: [
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: CarouselImages.isNotEmpty ?
                    AnotherCarousel(
                      images: CarouselImages,
                      dotSize: 6,
                      indicatorBgPadding: 10,
                      dotIncreasedColor: Colors.lightBlue,
                      autoplay: true,
                      autoplayDuration: Duration(seconds: 8),

                    )
                    :
                      Center(child : Text("No Images"))
                  ),
                ],
              ),

              // This is used to show products on home screen
              Column(

                  children: [
                    Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20),
                        color: Color.fromRGBO(210, 176, 215, 1.0),
                        child: Text("Top picks for you!", style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w700))
                    ),

                    Container(
                      color: Colors.cyan,
                      child : GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns in the grid
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0
                          ),
                          itemCount: ProductData.length,
                          itemBuilder: (context , index){
                            return Card(
                              child: Column(
                                children: [
                                  Container(
                                    height : 70,
                                    width: 50,
                                    child: Image.network(ProductData[index]["image"]),

                                  )
                                ],
                              )
                            );
                          }
                      )
                    ),
                  ]
              ),
              
            ],
        ),
      ),
    );
  }
}

