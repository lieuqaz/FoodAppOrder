import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/modle/rating_model.dart';
import 'package:myapp/provider/my_provider.dart';
import 'package:myapp/screen/rating_page.dart';
import 'package:provider/provider.dart';

class FoodDetail extends StatefulWidget {
  final String idfood;
  final String name;
  final String infor;
  final int price;
  final String image;
  final int rates;
  final String rating;
  const FoodDetail(
      {Key? key,
      required this.idfood,
      required this.name,
      required this.image,
      required this.price,
      required this.rates,
      required this.rating,
      required this.infor})
      : super(key: key);

  @override
  State<FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  List<RatingModel> ratingList = [];
  int newQuantify = 0;
  int quantity = 1;
  String iduser = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    MyProvider provider = Provider.of<MyProvider>(context);
    getQuan();
    return Scaffold(
      floatingActionButton: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 30, minHeight: 50),
        child: ElevatedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Add to Cart",
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          ),
          onPressed: () {
            // provider.addToCart(widget.image, widget.idfood, widget.name,
            //     quantity, widget.price, iduser);
            String idcart = widget.idfood + iduser;
            DocumentReference documentReference =
                FirebaseFirestore.instance.collection('cart').doc(idcart);
            CollectionReference cart =
                FirebaseFirestore.instance.collection('cart');

            if (newQuantify != 0) {
              documentReference.update({'quantify': newQuantify + quantity});
            } else {
              cart.doc(idcart).set({
                'image': widget.image,
                'idfood': widget.idfood,
                'name': widget.name,
                'quantify': quantity,
                'price': widget.price,
                'iduser': iduser,
                'idcart': idcart
              });
            }
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Product Added To Cart")));
          },
          style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
        ),
      ),
      body: ListView(
        children: [
          appBar(context),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "\$",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red[300],
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${widget.price * quantity}",
                              style: TextStyle(
                                  fontSize: 40, color: Colors.red, height: 1),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (quantity > 1) quantity--;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(Icons.remove),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '$quantity',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 220,
                      height: 220,
                      transform: Matrix4.translationValues(40, 0, 0),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.image),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(color: Colors.grey, blurRadius: 20)
                          ]),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Desciption",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    widget.infor,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Padding appBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RatingPage(
                          idfood: widget.idfood,
                          rating: widget.rating,
                          rates: widget.rates)));
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(
                Icons.star,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getQuan() async {
    String idcart = widget.idfood + iduser;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('cart').doc(idcart);
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        newQuantify = (snapshot.data() as dynamic)['quantify'];
      }
    });
  }
}
