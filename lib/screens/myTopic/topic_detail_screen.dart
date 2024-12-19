import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:language_learning_app/services/firebase_service.dart';

class TopicDetailScreen extends StatefulWidget {
  final String topicId;
  final String topicName;

  const TopicDetailScreen({
    super.key,
    required this.topicId,
    required this.topicName,
  });

  @override
  _TopicDetailScreenState createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  // Hiển thị popup sửa/xóa từ vựng
  void _showOptionsDialog(String vocabId, String word, String meaning) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            word,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meaning,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showVocabularyDialog(
                        vocabId: vocabId,
                        initialWord: word,
                        initialMeaning: meaning,
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _firebaseService.deleteVocabulary(
                        topicId: widget.topicId,
                        vocabId: vocabId,
                      );
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Hiển thị popup thêm/sửa từ vựng
  void _showVocabularyDialog(
      {String? vocabId, String? initialWord, String? initialMeaning}) {
    final wordController = TextEditingController(text: initialWord ?? '');
    final meaningController = TextEditingController(text: initialMeaning ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Text(vocabId == null ? 'Thêm Từ Vựng' : 'Sửa Từ Vựng'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: wordController,
                decoration: const InputDecoration(labelText: 'Word'),
              ),
              TextField(
                controller: meaningController,
                decoration: const InputDecoration(labelText: 'Meaning'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final word = wordController.text.trim();
                final meaning = meaningController.text.trim();
                if (word.isEmpty || meaning.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Từ vựng và nghĩa không được để trống!'),
                    ),
                  );
                  return;
                }

                if (vocabId == null) {
                  _firebaseService.addVocabulary(
                    topicId: widget.topicId,
                    word: word,
                    meaning: meaning,
                  );
                } else {
                  _firebaseService.updateVocabulary(
                    topicId: widget.topicId,
                    vocabId: vocabId,
                    word: word,
                    meaning: meaning,
                  );
                }
                Navigator.pop(context);
              },
              child: Text(vocabId == null ? 'Thêm' : 'Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 71, 162, 236),
        title: Text(widget.topicName),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('topics')
            .doc(widget.topicId)
            .collection('vocabulary')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có từ vựng nào.\nNhấn nút "+" để thêm từ vựng.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final vocab = doc.data() as Map<String, dynamic>;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  title: Text(
                    vocab['word'] ?? 'Chưa có từ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    vocab['meaning'] ?? 'Chưa có nghĩa',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  onTap: () {
                    _showOptionsDialog(
                      doc.id,
                      vocab['word'] ?? '',
                      vocab['meaning'] ?? '',
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showVocabularyDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
