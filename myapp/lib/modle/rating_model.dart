class RatingModel {
  final String rating;
  final String idfood;
  final String iduser;
  final String idrating;
  final String comment;
  final String name;
  final String image;
  RatingModel(
      {required this.rating,
      required this.name,
      required this.image,
      required this.comment,
      required this.idfood,
      required this.iduser,
      required this.idrating});
}
