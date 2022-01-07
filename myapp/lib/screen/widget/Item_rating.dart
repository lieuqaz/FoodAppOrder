// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemRating extends StatefulWidget {
  final double rateting;
  final String ratingfood;
  final int rates;
  final String name;
  final String image;
  final String comment;
  final String idrating;
  final String iduser;
  final String idfood;
  const ItemRating(
      {Key? key,
      required this.ratingfood,
      required this.rates,
      required this.idfood,
      required this.idrating,
      required this.comment,
      required this.rateting,
      required this.name,
      required this.image,
      required this.iduser})
      : super(key: key);

  @override
  _ItemRatingState createState() => _ItemRatingState();
}

class _ItemRatingState extends State<ItemRating> {
  String iduser = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.grey,
            )
          ]),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.image), fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(50)),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          for (int i = 1; i <= widget.rateting; i++)
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                            )
                        ],
                      )
                    ],
                  ),
                ),
                widget.iduser == iduser
                    ? Positioned(
                        right: 0.0,
                        top: 0.0,
                        child: PopupMenuButton(
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: ListTile(
                                      leading: Icon(Icons.delete_forever),
                                      title: Text("Delete"),
                                    ),
                                    onTap: () {
                                      DocumentReference documentReference =
                                          FirebaseFirestore.instance
                                              .collection("rating")
                                              .doc(widget.idrating);
                                      documentReference.delete();
                                      DocumentReference item = FirebaseFirestore
                                          .instance
                                          .collection('food')
                                          .doc(widget.idfood);
                                      if (widget.rates > 1) {
                                        double newRating =
                                            (double.parse(widget.ratingfood) *
                                                        widget.rates -
                                                    (widget.rateting)) /
                                                (widget.rates - 1);
                                        item.update({
                                          'rating': newRating.toString(),
                                          'rates': widget.rates - 1
                                        });
                                      } else {
                                        item.update(
                                            {'rating': "0", 'rates': "0"});
                                      }
                                    },
                                  )
                                ],
                            icon: Icon(Icons.more_vert)),
                      )
                    : Column()
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.comment,
              style: TextStyle(color: Colors.black, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
