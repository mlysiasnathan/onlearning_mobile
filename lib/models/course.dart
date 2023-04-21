class Lesson {
  int? lesId;
  String? lesName;
  String? lesImg;
  String? lesContent;
  String? lesPrice;
  int? catId;

  Lesson(
      {this.lesId,
      this.lesName,
      this.lesImg,
      this.lesContent,
      this.lesPrice,
      this.catId});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lesId: json['course']['les_id'],
      lesName: json['course']['les_name'],
      lesImg: json['course']['les_img'],
      lesPrice: json['course']['les_price'],
      lesContent: json['course']['les_content'],
      catId: json['course']['cat_id'],
    );
  }
}
