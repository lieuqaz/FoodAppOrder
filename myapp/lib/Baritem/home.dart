// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Auth/auth_services.dart';
import 'package:myapp/modle/categories_modle.dart';
import 'package:myapp/modle/food_modle.dart';
import 'package:myapp/provider/my_provider.dart';
import 'package:myapp/screen/categories.dart';
import 'package:myapp/screen/widget/item_food.dart';
import 'package:provider/provider.dart';

class Homepa extends StatefulWidget {
  const Homepa({Key? key}) : super(key: key);

  @override
  _HomepaState createState() => _HomepaState();
}

class _HomepaState extends State<Homepa> {
  List<CategoriesModle> typeList = [];
  List<FoodModle> food = [];
  List<FoodModle> foods = [];
  int selectCategoris = 0;
  String query = '';
  @override
  void initState() {
    super.initState();

    foods = food;
  }

  @override
  Widget build(BuildContext context) {
    AuthServices loginProvider = Provider.of<AuthServices>(context);
    MyProvider provider = Provider.of<MyProvider>(context);
    provider.getList();
    typeList = provider.typeFoodList;
    provider.getFood();
    food = provider.throwFoodModleList;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          actions: [
            Container(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              width: 355,
              child: SearchWidget(
                hintText: 'Search',
                onChanged: searchFood,
                text: query,
              ),
            ),
          ],
        ),
        body: query.isEmpty
            ? Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        tittle("Categories"),
                        SizedBox(
                          height: 160,
                          child: ListView.builder(
                              itemCount: typeList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => Padding(
                                    padding: EdgeInsets.only(
                                        left: index == 0 ? 10 : 0),
                                    child: typeFood(
                                        typeList[index].image,
                                        typeList[index].name,
                                        index,
                                        typeList[index].idtype),
                                  )),
                        ),
                        tittle("Foods"),
                        Column(
                            children: List.generate(
                                food.length,
                                (index) => ItemFood(
                                      rates: food[index].rates,
                                      rating: food[index].rating,
                                      name: food[index].name,
                                      price: food[index].price,
                                      image: food[index].image,
                                      id: food[index].idfood,
                                      infor: food[index].infor,
                                    )))
                      ],
                    ),
                  ),
                ],
              )
            : ListView(
                children: [
                  Column(
                    children: List.generate(
                        foods.length,
                        (index) => ItemFood(
                              rates: foods[index].rates,
                              rating: foods[index].rating,
                              name: foods[index].name,
                              price: foods[index].price,
                              image: foods[index].image,
                              id: foods[index].idfood,
                              infor: foods[index].infor,
                            )),
                  ),
                ],
              ));
  }

  Padding tittle(String name) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 10),
      child: Text(
        name,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget typeFood(String image, String name, int index, String id) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Categories(idtype: id, name: name)))
      },
      child: Container(
          margin: EdgeInsets.only(right: 15, top: 10, bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                      image: NetworkImage(image), fit: BoxFit.cover),
                ),
              ),
              Text(
                name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              RawMaterialButton(
                onPressed: () {},
                fillColor: Colors.white,
                shape: CircleBorder(),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                  size: 20,
                ),
              )
            ],
          )),
    );
  }

  void searchFood(String query) {
    final foods = food.where((element) {
      final name = element.name.toLowerCase();
      final search = query.toLowerCase();
      return name.contains(search);
    }).toList();
    setState(() {
      this.query = query;
      this.foods = foods;
    });
  }
}

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;
  const SearchWidget(
      {Key? key,
      required this.text,
      required this.hintText,
      required this.onChanged})
      : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 10),
          hintText: widget.hintText,
          hintStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          prefixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.close, color: Colors.black),
                  onTap: () {
                    controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : Icon(
                  Icons.search,
                  color: Colors.black,
                ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10))),
    );
  }
}
