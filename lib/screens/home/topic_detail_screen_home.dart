import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TopicDetailScreen extends StatelessWidget {
  final String topicId;
  final String topicName;

  const TopicDetailScreen({
    super.key,
    required this.topicId,
    required this.topicName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 71, 162, 236),
        title: Text(topicName),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('topics')
            .doc(topicId)
            .collection('vocabulary')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có từ vựng nào trong topic này.',
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
              final vocab = docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(
                    vocab['word'] ?? 'Chưa có từ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    vocab['meaning'] ?? 'Chưa có nghĩa',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
