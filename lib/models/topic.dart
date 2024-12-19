class Topic {
  final String id;
  final String userId;
  final String name;
  final bool isPublic;
  final DateTime createdAt;

  Topic({
    required this.id,
    required this.userId,
    required this.name,
    required this.isPublic,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'isPublic': isPublic,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Topic.fromMap(Map<String, dynamic> map, String docId) {
    return Topic(
      id: docId,
      userId: map['userId'] ?? 'Unknown User', // Xử lý nếu userId null
      name: map['name'] ?? 'Unnamed Topic', // Xử lý nếu name null
      isPublic: map['isPublic'] ?? true, // Mặc định là Public
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }
}
