import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myapp/modle/rating_model.dart';
import 'package:myapp/provider/my_provider.dart';
import 'package:myapp/screen/widget/Item_rating.dart';
import 'package:provider/provider.dart';

class RatingPage extends StatefulWidget {
  final String idfood;
  final int rates;
  final String rating;
  const RatingPage(
      {Key? key,
      required this.idfood,
      required this.rating,
      required this.rates})
      : super(key: key);

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  late String name;
  late String image;
  List<RatingModel> ratesList = [];
  double ratings = 0;
  double ratingz = 0;
  String iduser = FirebaseAuth.instance.currentUser!.uid;
  late String cmt;
  String hintText = "Comment";
  TextEditingController comment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    MyProvider provider = Provider.of<MyProvider>(context);
    provider.getRating(widget.idfood);
    ratesList = provider.showRatesList;
    getUserInfor(iduser);
    getRating();
    return Scaffold(
      body: ListView(
        children: [
          appBar(context),
          Column(
            children: List.generate(ratesList.length, (index) {
              return ItemRating(
                  comment: ratesList[index].comment,
                  rateting: double.parse(ratesList[index].rating.toString()),
                  name: ratesList[index].name,
                  image: ratesList[index].image,
                  iduser: ratesList[index].iduser,
                  idrating: ratesList[index].idrating,
                  idfood: ratesList[index].idfood,
                  rates: widget.rates,
                  ratingfood: widget.rating);
            }),
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
              showRating();
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

  Future<void> getUserInfor(id) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('userData').doc(id);
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        name = (snapshot.data() as dynamic)['name'];
        image = (snapshot.data() as dynamic)['image'];
      }
    });
  }

  Widget buildRating() {
    ratingz = ratings;
    return RatingBar.builder(
        initialRating: ratings,
        minRating: 0.5,
        itemSize: 46,
        itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.orange,
            ),
        updateOnDrag: true,
        onRatingUpdate: (ratingz) => setState(() {
              this.ratingz = ratingz;
            }));
  }

  void showRating() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Rate This Food'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Please leave a star rating"),
                const SizedBox(
                  height: 20,
                ),
                buildRating(),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: hintText,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                    controller: comment,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    DocumentReference item = FirebaseFirestore.instance
                        .collection('food')
                        .doc(widget.idfood);
                    DocumentReference rate = FirebaseFirestore.instance
                        .collection('rating')
                        .doc(widget.idfood + iduser);
                    double ratetings = double.parse(widget.rating.toString());
                    double ratingss = double.parse(ratings.toString());
                    double newRate = (ratetings * widget.rates + ratingz) /
                        (widget.rates + 1);
                    double newRates;
                    if (widget.rates <= 1) {
                      newRates = ratingz;
                    } else {
                      newRates =
                          (ratetings * widget.rates + ratingz - ratingss) /
                              widget.rates;
                    }

                    if (ratings != 0) {
                      item.update({
                        'rating': newRates.toString(),
                      });
                      rate.update({
                        'rating': ratingz.toString(),
                        'name': name,
                        'image': image
                      });

                      if (cmt == null) {
                        rate.update({
                          'comment': comment.text,
                          'name': name,
                          'image': image
                        });
                      }
                      if (cmt != null && comment.text.trim() == null) {
                        rate.update(
                            {'comment': cmt, 'name': name, 'image': image});
                      }
                      if (cmt != null && comment.text.trim().isNotEmpty) {
                        print("trong");
                        rate.update({
                          'comment': comment.text,
                          'name': name,
                          'image': image
                        });
                      }
                    } else {
                      item.update({
                        'rating': newRate.toString(),
                        'rates': widget.rates + 1
                      });
                      rate.set({
                        'iduser': iduser,
                        'idfood': widget.idfood,
                        'idrate': widget.idfood + iduser,
                        'rating': ratingz.toString(),
                        'comment': comment.text,
                        'name': name,
                        'image': image
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          ));
  Future<void> getRating() async {
    DocumentReference documentReference = await FirebaseFirestore.instance
        .collection('rating')
        .doc(widget.idfood + iduser);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        ratings =
            double.parse((snapshot.data() as dynamic)['rating'].toString());

        cmt = (snapshot.data() as dynamic)['comment'];
        hintText = cmt;
      }
    });
  }
}
