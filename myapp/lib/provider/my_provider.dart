// ignore_for_file: unused_import, avoid_function_literals_in_foreach_calls, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/modle/cart_model.dart';
import 'package:myapp/modle/categories_modle.dart';
import 'package:myapp/modle/food_modle.dart';
import 'package:myapp/modle/rating_model.dart';
import 'package:myapp/modle/user_modle.dart';

class MyProvider extends ChangeNotifier {
  List<CategoriesModle> typeList = [];
  late CategoriesModle typeModle;
  Future<void> getList() async {
    List<CategoriesModle> newTypeList = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('idtype').get();
    querySnapshot.docs.forEach((element) {
      typeModle = CategoriesModle(
          name: (element.data() as dynamic)['name'],
          image: (element.data() as dynamic)['image'],
          idtype: (element.data() as dynamic)['idtype']);
      newTypeList.add(typeModle);
      typeList = newTypeList;
    });
    notifyListeners();
  }

  get typeFoodList {
    return typeList;
  }

  List<FoodModle> foodList = [];
  late FoodModle foodModle;
  Future<void> getFood() async {
    List<FoodModle> newFoodList = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('food').get();
    querySnapshot.docs.forEach((element) {
      foodModle = FoodModle(
          rates: (element.data() as dynamic)['rates'],
          rating: (element.data() as dynamic)['rating'],
          name: (element.data() as dynamic)['name'],
          image: (element.data() as dynamic)['image'],
          price: (element.data() as dynamic)['price'],
          idfood: (element.data() as dynamic)['idfood'],
          idtype: (element.data() as dynamic)['idtype'],
          infor: (element.data() as dynamic)['infor']);
      newFoodList.add(foodModle);
      foodList = newFoodList;
    });
    notifyListeners();
  }

  get throwFoodModleList {
    return foodList;
  }
  ///////

  List<FoodModle> foodListt = [];
  late FoodModle foodModlet;

  Future<void> getFoodt(idtype) async {
    List<FoodModle> newFoodListt = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('food')
        .where('idtype', isEqualTo: idtype)
        .get();
    querySnapshot.docs.forEach((element) {
      foodModlet = FoodModle(
          rates: (element.data() as dynamic)['rates'],
          rating: (element.data() as dynamic)['rating'],
          name: (element.data() as dynamic)['name'],
          image: (element.data() as dynamic)['image'],
          price: (element.data() as dynamic)['price'],
          idfood: (element.data() as dynamic)['idfood'],
          idtype: (element.data() as dynamic)['idtype'],
          infor: (element.data() as dynamic)['infor']);
      newFoodListt.add(foodModlet);
      foodListt = newFoodListt;
    });
    notifyListeners();
  }

  get foodtypelist {
    return foodListt;
  }
  //////

  List<CartModle> cartList = [];

  late CartModle cartModle;
  Future<void> getCart() async {
    List<CartModle> newCartList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .where('iduser', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    querySnapshot.docs.forEach((element) {
      cartModle = CartModle(
          idcart: (element.data() as dynamic)['idcart'],
          idfood: (element.data() as dynamic)['idfood'],
          price: (element.data() as dynamic)['price'],
          iduser: (element.data() as dynamic)['iduser'],
          quantify: (element.data() as dynamic)['quantify'],
          image: (element.data() as dynamic)['image'],
          name: (element.data() as dynamic)['name']);
      newCartList.add(cartModle);
      cartList = newCartList;
    });
    notifyListeners();
  }

  int totalprice() {
    int total = 0;
    cartList.forEach((element) {
      total = total + element.price * element.quantify;
    });
    return total;
  }

  int item() {
    int item = cartList.length;
    return item;
  }

  get throwCart {
    return cartList;
  }

  List<UserModle> user = [];
  late UserModle userModle;
  Future<void> UserInfor() async {
    List<UserModle> newuser = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("userData")
        .where('iduser', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    querySnapshot.docs.forEach((element) {
      userModle = UserModle(
          phone: (element.data() as dynamic)['phone'],
          name: (element.data() as dynamic)['name'],
          email: (element.data() as dynamic)['email'],
          image: (element.data() as dynamic)['image'],
          address: (element.data() as dynamic)['address']);
      newuser.add(userModle);
      user = newuser;
    });
    notifyListeners();
  }

  get Userinfo {
    return user;
  }

  //////////
  Future<void> addToCart(image, idfood, name, quantify, price, iduser) async {
    String idcart = idfood + iduser;

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('cart').doc(idcart);
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (snapshot.exists) {
        int newQuantify = (snapshot.data() as dynamic)['quantify'] + quantify;
        transaction.update(documentReference, {'quantify': newQuantify});
      } else {
        CollectionReference cart =
            FirebaseFirestore.instance.collection('cart');

        cart.doc(idcart).set({
          'image': image,
          'idfood': idfood,
          'name': name,
          'quantify': quantify,
          'price': price,
          'iduser': iduser,
          'idcart': idcart
        });
      }
      return null;
    });
  }

  Future<void> deleteCartitem(idcart) {
    CollectionReference cart = FirebaseFirestore.instance.collection('cart');
    return cart.doc(idcart).delete();
  }

  Future<void> deleteCart() async {
    CollectionReference cart = FirebaseFirestore.instance.collection('cart');
    cartList.forEach((element) {
      CollectionReference cart = FirebaseFirestore.instance.collection('cart');
      cart.doc(element.idcart).delete();
    });
  }

  late String thisname;
  late String thisphone;
  late String thisaddress;
  Future<void> ChangeInfor(name, phone, address) async {
    DocumentReference documentReference = await FirebaseFirestore.instance
        .collection('userData')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    if (name.toString().isNotEmpty) {
      documentReference.update({'name': name});
    }
    if (phone.toString().isNotEmpty) {
      documentReference.update({'phone': phone});
    }
    if (address.toString().isNotEmpty) {
      documentReference.update({'address': address});
    }
  }

  Future<void> ChangeImage(image) async {
    print("Bắt đầu");
    CollectionReference user =
        FirebaseFirestore.instance.collection('userData');
    user.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'image': image,
    }, SetOptions(merge: true)).then((value) => print("Đã thêm"));
  }

  List<RatingModel> ratesList = [];
  late RatingModel ratingModel;

  Future<void> getRating(idfood) async {
    List<RatingModel> newRatesList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('rating')
        .where('idfood', isEqualTo: idfood)
        .get();
    querySnapshot.docs.forEach((element) {
      ratingModel = RatingModel(
          image: (element.data() as dynamic)['image'],
          name: (element.data() as dynamic)['name'],
          rating: (element.data() as dynamic)['rating'],
          comment: (element.data() as dynamic)['comment'],
          idfood: idfood,
          iduser: (element.data() as dynamic)['iduser'],
          idrating: (element.data() as dynamic)['idrate']);
      newRatesList.add(ratingModel);
      ratesList = newRatesList;
    });
    notifyListeners();
  }

  get showRatesList {
    return ratesList;
  }
}
