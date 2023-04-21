class LessonCategory {
  int? catId;
  String? catName;
  String? catImg;
  String? catDescription;

  LessonCategory({this.catId, this.catName, this.catImg, this.catDescription});

  factory LessonCategory.fromJson(Map<String, dynamic> json) {
    return LessonCategory(
      catId: json['cat_id'],
      catName: json['cat_name'],
      catImg: json['cat_img'],
      catDescription: json['cat_description'],
    );
  }
}
