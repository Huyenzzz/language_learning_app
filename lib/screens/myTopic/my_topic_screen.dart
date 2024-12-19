import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:language_learning_app/widgets/bottom_nav_bar.dart';
import 'topic_detail_screen.dart';

class MyTopicScreen extends StatefulWidget {
  const MyTopicScreen({super.key});

  @override
  _MyTopicScreenState createState() => _MyTopicScreenState();
}

class _MyTopicScreenState extends State<MyTopicScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Hàm tạo topic mới
  Future<void> _createTopic(String name, bool isPublic) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance.collection('topics').add({
      'userId': user.uid,
      'name': name,
      'isPublic': isPublic,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Hiển thị popup để tạo topic
  void _showCreateTopicDialog() {
    final nameController = TextEditingController();
    bool isPublic = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Tạo Topic Mới'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Tên Topic'),
                  ),
                  SwitchListTile(
                    title: Text(isPublic ? 'Công khai' : 'Riêng tư'),
                    value: isPublic,
                    onChanged: (value) {
                      setState(() {
                        isPublic = value;
                      });
                    },
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
                    final name = nameController.text.trim();
                    if (name.isNotEmpty) {
                      _createTopic(name, isPublic);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Tên topic không được để trống!')),
                      );
                    }
                  },
                  child: const Text('Tạo'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade900,
          title: const Text('My Topics'),
        ),
        body: const Center(
          child: Text(
            'Bạn cần đăng nhập để xem các topic của mình.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('My Topics'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('topics')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Bạn chưa tạo topic nào.\nNhấn nút "+" để tạo topic mới.',
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
              final topic = doc.data() as Map<String, dynamic>;

              // Lấy ngày tạo và định dạng
              final createdAt = topic['createdAt'] != null
                  ? DateFormat('dd/MM/yyyy').format(
                      DateTime.fromMillisecondsSinceEpoch(topic['createdAt']),
                    )
                  : 'Không xác định';

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  title: Row(
                    children: [
                      topic['isPublic'] == true
                          ? const Icon(Icons.public,
                              size: 16, color: Colors.green)
                          : const Icon(Icons.lock, size: 16, color: Colors.red),
                      const SizedBox(width: 8), // Khoảng cách giữa icon và tên
                      Text(
                        topic['name'] ?? 'Chưa có tên',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Ngày tạo: $createdAt',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('topics')
                          .doc(doc.id)
                          .delete();
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopicDetailScreen(
                          topicId: doc.id,
                          topicName: topic['name'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTopicDialog,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 2),
    );
  }
}
