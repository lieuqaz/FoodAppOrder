// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/modle/cart_model.dart';
import 'package:myapp/provider/my_provider.dart';

import 'package:provider/provider.dart';

class BodyCart extends StatefulWidget {
  @override
  State<BodyCart> createState() => _BodyCartState();
}

class _BodyCartState extends State<BodyCart> {
  List<CartModle> list = [];

  @override
  Widget build(BuildContext context) {
    MyProvider provider = Provider.of<MyProvider>(context);
    provider.getCart();
    list = provider.throwCart;
    final cartitem = FirebaseFirestore.instance;
    String iduser = FirebaseAuth.instance.currentUser!.uid;
    return ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: list.length,
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final itemID = list[index].idcart;

          return Dismissible(
            key: Key(itemID),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                list.removeAt(index);
              });

              provider.deleteCartitem(itemID);
              provider.totalprice();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Item Deleted Successfully")));
            },
            background: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Icon(Icons.delete)],
              ),
            ),
            child: ItemCart(list: list, index: index),
          );
        });
  }
}

class ItemCart extends StatefulWidget {
  const ItemCart({Key? key, required this.list, required this.index})
      : super(key: key);

  final List<CartModle> list;
  final int index;

  @override
  State<ItemCart> createState() => _ItemCartState();
}

class _ItemCartState extends State<ItemCart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey)]),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey)],
                    image: DecorationImage(
                      image: NetworkImage(widget.list[widget.index].image),
                      fit: BoxFit.fill,
                    ),
                    color: Color(0xfff5f6f9),
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.list[widget.index].name,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (widget.list[widget.index].quantify > 1) {
                                DocumentReference item = FirebaseFirestore
                                    .instance
                                    .collection('cart')
                                    .doc(widget.list[widget.index].idcart);
                                item.update({
                                  'quantify':
                                      widget.list[widget.index].quantify - 1
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 5),
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(blurRadius: 5, color: Colors.grey)
                                  ]),
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 13,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            child: Text(
                              '${widget.list[widget.index].quantify}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              DocumentReference item = FirebaseFirestore
                                  .instance
                                  .collection('cart')
                                  .doc(widget.list[widget.index].idcart);
                              item.update({
                                'quantify':
                                    widget.list[widget.index].quantify + 1
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 5),
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(blurRadius: 5, color: Colors.grey)
                                  ]),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 13,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Text(
                  "\$${widget.list[widget.index].price * widget.list[widget.index].quantify}  ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 25),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
