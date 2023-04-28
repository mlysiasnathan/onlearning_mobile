class Document {
  int? pdfId;
  String? pdfFile;
  String? createdAt;
  String? updatedAt;

  Document({
    this.pdfId,
    this.pdfFile,
    this.createdAt,
    this.updatedAt,
  });

  factory Document.fromJson(Map<String, dynamic> doc) {
    return Document(
      pdfId: doc['pdf_id'],
      pdfFile: doc['pdf_file'],
      createdAt: doc['created_at'],
      updatedAt: doc['updated_at'],
    );
  }
}
