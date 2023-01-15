class Journal {
  String? docId;
  final String title;
  final String? content;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  final String uid;

  Journal({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.uid,
  });

  void setDocId(String docId) {}

  factory Journal.fromMap(Map<String, dynamic> map) {
    return Journal(
      title: map["title"],
      content: map["content"],
      createdAt: DateTime.parse(map["createdAt"]),
      lastUpdatedAt: DateTime.parse(map["lastUpdatedAt"]),
      uid: map["uid"],
    );
  }

  Map<String, dynamic> toMap() => {
        "title": title,
        "content": content ?? "",
        "createdAt": createdAt.toString(),
        "lastUpdatedAt": lastUpdatedAt.toString(),
        "uid": uid,
      };
}
