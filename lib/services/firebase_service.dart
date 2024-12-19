import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/topic.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy tất cả topics của user
  Future<List<Topic>> getTopics(String userId) async {
    final snapshot = await _firestore
        .collection('topics')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => Topic.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Lấy topics công khai
  Future<List<Topic>> getPublicTopics() async {
    final snapshot = await _firestore
        .collection('topics')
        .where('isPublic', isEqualTo: true)
        .get();
    return snapshot.docs
        .map((doc) => Topic.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Tạo topic mới
  Future<void> createTopic(String userId, String name, bool isPublic) async {
    await _firestore.collection('topics').add({
      'userId': userId,
      'name': name,
      'isPublic': isPublic,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

//   // Thêm từ vựng vào một topic
  Future<void> addVocabulary({
    required String topicId,
    required String word,
    required String meaning,
  }) async {
    await _firestore
        .collection('topics')
        .doc(topicId)
        .collection('vocabulary')
        .add({
      'word': word,
      'meaning': meaning,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Sửa từ vựng trong một topic
  Future<void> updateVocabulary({
    required String topicId,
    required String vocabId,
    required String word,
    required String meaning,
  }) async {
    await _firestore
        .collection('topics')
        .doc(topicId)
        .collection('vocabulary')
        .doc(vocabId)
        .update({
      'word': word,
      'meaning': meaning,
    });
  }

  // Xóa từ vựng khỏi một topic
  Future<void> deleteVocabulary({
    required String topicId,
    required String vocabId,
  }) async {
    await _firestore
        .collection('topics')
        .doc(topicId)
        .collection('vocabulary')
        .doc(vocabId)
        .delete();
  }

  // Thêm một topic mới
  Future<void> addTopic({
    required String userId,
    required String name,
    required bool isPublic,
  }) async {
    await _firestore.collection('topics').add({
      'userId': userId,
      'name': name,
      'isPublic': isPublic,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Xóa một topic
  Future<void> deleteTopic({required String topicId}) async {
    await _firestore.collection('topics').doc(topicId).delete();
  }
}
