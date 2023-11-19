class Lesson {
  int? lesId;
  String? lesName;
  String? lesImg;
  String? lesContent;
  int? lesPrice;
  int? catId;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? tags;

  Lesson({
    this.lesId,
    this.lesName,
    this.catId,
    this.lesPrice,
    this.lesImg,
    this.lesContent,
    this.createdAt,
    this.updatedAt,
    this.tags,
  });

  factory Lesson.fromJson(Map<String, dynamic> lesson) {
    return Lesson(
        lesId: lesson['les_id'],
        lesName: lesson['les_name'],
        catId: lesson['cat_id'],
        lesPrice: lesson['les_price'],
        lesImg: lesson['les_img'],
        lesContent: lesson['les_content'],
        createdAt: lesson['created_at'],
        updatedAt: lesson['updated_at'],
        tags: lesson['tags']);
  }
}
