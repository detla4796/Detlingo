import 'package:flutter/material.dart';

class LessonDetails extends StatelessWidget {
  const LessonDetails({super.key, required this.title, required this.words, required this.image});
  final String title;
  final List<String> words;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: words.length,
              itemBuilder:(context, index) {
                return ListTile(
                  title: Text(words[index]),
                );
              },
            ),
          ),
          Container(
            height: 200,
            width: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image)
              ),
            ),
          ),
        ],
      ),
    );
  }
}