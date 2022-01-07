class CartModle {
  final String idfood;
  final String iduser;
  final String image;
  final String name;
  final int price;
  final int quantify;
  final String idcart;
  CartModle(
      {required this.idfood,
      required this.price,
      required this.iduser,
      required this.quantify,
      required this.image,
      required this.name,
      required this.idcart});
}
