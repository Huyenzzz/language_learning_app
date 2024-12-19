import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:language_learning_app/screens/home/topic_detail_screen_home.dart';
import '../../models/topic.dart';
import '../../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = ''; // Lưu giá trị tìm kiếm
  String filterOption = 'all'; // Lọc chủ đề theo tất cả hoặc theo ngày
  final ScrollController _scrollController =
      ScrollController(); // Điều khiển danh sách cuộn
  final Map<String, int> _letterIndexMap =
      {}; // Lưu chỉ mục (index) cho chữ cái đầu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 71, 162, 236),
        elevation: 4,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.co2,
              size: 50,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              'Hi! Khám phá các chủ đề từ vựng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery =
                      value.trim().toLowerCase(); // Cập nhật giá trị tìm kiếm
                });
              },
              decoration: InputDecoration(
                hintText: 'Tìm kiếm chủ đề...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Bộ lọc theo ngày
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Lọc theo: ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: filterOption,
                  items: const [
                    DropdownMenuItem(
                      value: 'all',
                      child: Text('Tất cả'),
                    ),
                    DropdownMenuItem(
                      value: 'today',
                      child: Text('Hôm nay'),
                    ),
                    DropdownMenuItem(
                      value: 'this_week',
                      child: Text('Tuần này'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      filterOption = value ?? 'all';
                    });
                  },
                ),
              ],
            ),
          ),

          // Danh sách chủ đề
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('topics')
                  .where('isPublic', isEqualTo: true) // Chỉ lấy topic public
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'Không có chủ đề công khai nào.\nHãy tạo chủ đề đầu tiên nhé!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                // Chuyển đổi dữ liệu thành danh sách chủ đề
                var topics = docs
                    .map((doc) => Topic.fromMap(
                        doc.data() as Map<String, dynamic>, doc.id))
                    .where((topic) => topic.name
                        .toLowerCase()
                        .contains(searchQuery)) // Lọc theo tên topic
                    .toList();

                // Lọc theo thời gian
                if (filterOption == 'today') {
                  final today = DateTime.now();
                  topics = topics.where((topic) {
                    return topic.createdAt.year == today.year &&
                        topic.createdAt.month == today.month &&
                        topic.createdAt.day == today.day;
                  }).toList();
                } else if (filterOption == 'this_week') {
                  final now = DateTime.now();
                  final startOfWeek =
                      now.subtract(Duration(days: now.weekday - 1));
                  topics = topics.where((topic) {
                    return topic.createdAt.isAfter(startOfWeek);
                  }).toList();
                }

                // Sắp xếp theo ABC
                topics.sort(
                  (a, b) =>
                      a.name.toLowerCase().compareTo(b.name.toLowerCase()),
                );

                // Tạo chỉ mục cho từng chữ cái
                _letterIndexMap.clear();
                for (int i = 0; i < topics.length; i++) {
                  final firstLetter = topics[i].name[0].toUpperCase();
                  if (!_letterIndexMap.containsKey(firstLetter)) {
                    _letterIndexMap[firstLetter] = i;
                  }
                }

                if (topics.isEmpty) {
                  return const Center(
                    child: Text(
                      'Không tìm thấy chủ đề nào.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return Stack(
                  children: [
                    ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: topics.length,
                      itemBuilder: (context, index) {
                        final topic = topics[index];
                        final formattedDate =
                            DateFormat('dd/MM/yyyy').format(topic.createdAt);

                        final firstLetter =
                            topic.name[0].toUpperCase(); // Chữ cái đầu

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0 ||
                                topics[index - 1].name[0].toUpperCase() !=
                                    firstLetter) // Hiển thị đầu mục chữ cái
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  firstLetter,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            Card(
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
                                title: Text(
                                  topic.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                subtitle: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Created: $formattedDate',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TopicDetailScreen(
                                        topicId: topic.id,
                                        topicName: topic.name,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    // Thanh điều hướng ABC
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _letterIndexMap.keys.map((letter) {
                          return GestureDetector(
                            onTap: () {
                              final index = _letterIndexMap[letter]!;
                              final offset = index *
                                  120.0; // Giả định chiều cao mỗi item là 80
                              _scrollController.animateTo(
                                offset,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text(
                              letter,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }
}
