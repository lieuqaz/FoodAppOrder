// ignore_for_file: deprecated_member_use, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/modle/cart_model.dart';
import 'package:myapp/provider/my_provider.dart';
import 'package:myapp/screen/home.dart';
import 'package:myapp/screen/widget/cart/body_cart.dart';

import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartModle> list = [];
  @override
  Widget build(BuildContext context) {
    MyProvider provider = Provider.of<MyProvider>(context);
    provider.getCart();
    list = provider.throwCart;
    final cartitem = FirebaseFirestore.instance;
    String iduser = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: newMethod(context),
      body: ListView.separated(
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
          }),
      bottomNavigationBar: CheckOurCard(
        list: list,
      ),
    );
  }

  AppBar newMethod(BuildContext context) {
    MyProvider provider = Provider.of<MyProvider>(context);
    int item = provider.item();
    return AppBar(
      backgroundColor: Colors.orange,
      title: Center(
        child: Column(
          children: [
            Text(
              "Cart",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "$item items",
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      ),
    );
  }
}

class CheckOurCard extends StatefulWidget {
  const CheckOurCard({Key? key, required this.list}) : super(key: key);
  final List<CartModle> list;
  @override
  State<CheckOurCard> createState() => _CheckOurCardState();
}

class _CheckOurCardState extends State<CheckOurCard> {
  @override
  Widget build(BuildContext context) {
    MyProvider provider = Provider.of<MyProvider>(context);
    String iduser = FirebaseAuth.instance.currentUser!.uid;
    int total = provider.totalprice();
    int item = provider.item();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, -15),
                blurRadius: 20,
                color: Color(0xffdadada).withOpacity(0.15))
          ]),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color(0xfff5f6f9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.wallet_giftcard,
                    color: Colors.red,
                  ),
                ),
                Spacer(),
                Text(
                  "Add voucher code",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.black,
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(TextSpan(text: "Tổng tiền:\n", children: [
                  TextSpan(
                    text: "\$$total",
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  )
                ])),
                SizedBox(
                  width: 190,
                  height: 40,
                  child: RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Have you decided to buy?"),
                                content: Text(
                                    "You have $item items that cost $total"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        // provider.deleteCart();
                                        int index;
                                        provider.deleteCart();
                                        setState(() {
                                          widget.list.removeRange(
                                              0, widget.list.length);
                                        });

                                        Navigator.pop(context);
                                      },
                                      child: Text("Buy"))
                                ],
                              ));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("Buy",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
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
