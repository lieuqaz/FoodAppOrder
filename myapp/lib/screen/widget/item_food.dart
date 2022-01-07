import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screen/food_page.dart';

class ItemFood extends StatefulWidget {
  final String name;
  final String image;
  final String id;
  final int rates;
  final int price;
  final String infor;
  final String rating;
  const ItemFood(
      {Key? key,
      required this.rates,
      required this.rating,
      required this.id,
      required this.image,
      required this.name,
      required this.price,
      required this.infor})
      : super(key: key);

  @override
  State<ItemFood> createState() => _ItemFoodState();
}

class _ItemFoodState extends State<ItemFood> {
  String rating = "";
  @override
  Widget build(BuildContext context) {
    if (widget.rating.length >= 3) {
      rating = widget.rating.substring(0, 3);
    } else
      rating = widget.rating;
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FoodDetail(
                    rating: widget.rating,
                    rates: widget.rates,
                    idfood: widget.id,
                    name: widget.name,
                    image: widget.image,
                    price: widget.price,
                    infor: widget.infor)))
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      child: Container(
                    width: MediaQuery.of(context).size.width / 2.3,
                    padding: EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      widget.name,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                  )),
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      "${widget.price}\$",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20)),
                          color: Colors.orange,
                        ),
                        child: Icon(
                          Icons.add,
                          size: 22,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Icon(Icons.star),
                          Text(
                            rating,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 130,
              width: 130,
              transform: Matrix4.translationValues(10, 0, 0),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.image), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20)]),
            )
          ],
        ),
      ),
    );
  }
}
