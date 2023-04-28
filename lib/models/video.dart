class Video {
  int? vidId;
  String? vidName;
  String? vidFile;
  String? createdAt;
  String? updatedAt;

  Video({
    this.vidId,
    this.vidName,
    this.vidFile,
    this.createdAt,
    this.updatedAt,
  });

  factory Video.fromJson(Map<String, dynamic> video) {
    return Video(
      vidId: video['vid_id'],
      vidName: video['vid_name'],
      vidFile: video['vid_file'],
      createdAt: video['created_at'],
      updatedAt: video['updated_at'],
    );
  }
}
