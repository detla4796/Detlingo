import 'package:flutter/material.dart';
import 'lessonsdetails.dart';
import 'quest.dart';

class Lessons extends StatelessWidget {
  const Lessons({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lessons'),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('Lesson 1'),
            subtitle: Text('Basic greetings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder : (context) => LessonDetails(
                    title: 'Lesson 1',
                    words: ['Hello', 'Goodbye', 'Please', 'Thank you', 'How are you?', 'Excuse me', 'Good morning', 'Good night'],
                    image: 'image/6.jpg',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('Lesson 2'),
            subtitle: Text('Simple english words'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder : (context) => LessonDetails(
                    title: 'Lesson 2',
                    words: ['Apple', 'Banana', 'Orange', 'Grapes', 'Mango', 'Pineapple', 'Strawberry', 'Watermelon'],
                    image: 'image/3.jpg',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmarks),
            title: Text('Test'),
            subtitle: Text('Test your knowledge'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Quest()),
              );
            },
          ),
        ],
      ),
    );
  }
}