import 'package:flutter/material.dart';
import 'package:language_learning_app/models/response.dart';
import 'package:language_learning_app/screens/dictionary/api.dart';
import 'package:language_learning_app/widgets/bottom_nav_bar.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  bool isLoading = false; // Trạng thái loading
  ResponseModel? wordData; // Lưu kết quả trả về từ API
  String message = "Welcome, Start searching"; // Thông báo mặc định

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(), // Thanh tìm kiếm
            const SizedBox(height: 12),
            _buildContent(), // Nội dung chính
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 1),
    );
  }

  /// Xây dựng AppBar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Dictionary"),
      backgroundColor: const Color.fromARGB(255, 71, 162, 236),
    );
  }

  /// Xây dựng thanh tìm kiếm
  Widget _buildSearchBar() {
    return SearchBar(
      hintText: "Search word here",
      onSubmitted: (word) =>
          _fetchWordMeaning(word), // Gọi hàm fetch khi nhập từ
    );
  }

  /// Hiển thị nội dung chính dựa vào trạng thái
  Widget _buildContent() {
    if (isLoading) {
      return const LinearProgressIndicator(); // Loading
    } else if (wordData != null) {
      return Expanded(child: _buildWordDetails()); // Hiển thị dữ liệu
    } else {
      return _buildMessageWidget(); // Hiển thị thông báo mặc định
    }
  }

  /// Hiển thị thông báo khi không có dữ liệu
  Widget _buildMessageWidget() {
    return Center(
      child: Text(
        message,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  /// Hiển thị kết quả tra từ
  Widget _buildWordDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          wordData!.word ?? "",
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        Text(wordData!.phonetic ?? ""),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: wordData!.meanings?.length ?? 0,
            itemBuilder: (context, index) {
              return _buildMeaningCard(wordData!.meanings![index]);
            },
          ),
        ),
      ],
    );
  }

  /// Xây dựng card hiển thị từng nghĩa
  Widget _buildMeaningCard(Meanings meaning) {
    final definitions = meaning.definitions
        ?.asMap()
        .entries
        .map((entry) => "${entry.key + 1}. ${entry.value.definition}")
        .join("\n");

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleText("Part of Speech", meaning.partOfSpeech),
            _buildTitleText("Definitions", definitions),
            _buildSynonymsAntonyms("Synonyms", meaning.synonyms),
            _buildSynonymsAntonyms("Antonyms", meaning.antonyms),
          ],
        ),
      ),
    );
  }

  /// Hiển thị tiêu đề và nội dung
  Widget _buildTitleText(String title, String? content) {
    if (content == null || content.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(content),
        const SizedBox(height: 12),
      ],
    );
  }

  /// Hiển thị synonyms và antonyms
  Widget _buildSynonymsAntonyms(String title, List<String>? list) {
    if (list == null || list.isEmpty) return const SizedBox.shrink();

    return _buildTitleText(title, list.toSet().join(", "));
  }

  /// Gọi API lấy dữ liệu
  Future<void> _fetchWordMeaning(String word) async {
    setState(() {
      isLoading = true;
      message = "";
    });

    try {
      wordData = await API.fetchMeaning(word); // Gọi API
    } catch (e) {
      wordData = null;
      message = "Could not fetch meaning. Please try again.";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
