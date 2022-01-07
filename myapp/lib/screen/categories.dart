// ignore_for_file: unused_import, prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/modle/food_modle.dart';
import 'package:myapp/provider/my_provider.dart';

import 'package:myapp/screen/home.dart';
import 'package:myapp/screen/widget/bottonContainer.dart';
import 'package:myapp/screen/widget/item_food.dart';

import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  final String idtype;
  final String name;

  Categories({required this.idtype, required this.name});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<FoodModle> foodList = [];

  @override
  Widget build(BuildContext context) {
    MyProvider provider = Provider.of<MyProvider>(context);
    provider.getFoodt(widget.idtype);
    foodList = provider.foodtypelist;

    return Scaffold(
        body: ListView(
      children: [
        appBar(context),
        tittle("Foods"),
        Column(
          children: List.generate(
              foodList.length,
              (index) => ItemFood(
                    rates: foodList[index].rates,
                    rating: foodList[index].rating,
                    name: foodList[index].name,
                    price: foodList[index].price,
                    image: foodList[index].image,
                    id: foodList[index].idfood,
                    infor: foodList[index].infor,
                  )),
        ),
      ],
    ));
  }

  Padding appBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.chevron_left_rounded),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Text(
            widget.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
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
}
