class LessonCategory {
  int? catId;
  String? catName;
  String? catImg;
  String? catDescription;
  String? createdAt;

  LessonCategory({
    this.catId,
    this.catName,
    this.catImg,
    this.catDescription,
    this.createdAt,
  });

  factory LessonCategory.fromJson(Map<String, dynamic> category) {
    return LessonCategory(
      catId: category['cat_id'],
      catName: category['cat_name'],
      catImg: category['cat_img'],
      catDescription: category['cat_description'],
      createdAt: category['created_at'],
    );
  }
}
