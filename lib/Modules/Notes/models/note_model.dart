class NoteModel {
  String title;
  String note;
  int createdAt;
  int? updatedAt;
  NoteModel({
    required this.title,
    required this.note,
    required this.createdAt,
    this.updatedAt,
  });

  factory NoteModel.fromJson(Map data) {
    return NoteModel(
      title: data['title'],
      note: data['note'],
      createdAt: data['created_at'],
      updatedAt: data['updated_at'],
    );
  }
}
