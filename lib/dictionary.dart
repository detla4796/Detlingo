import 'package:flutter/material.dart';

class Dictionary extends StatefulWidget {
  const Dictionary({super.key});

  @override
  State<Dictionary> createState() => _DictionaryState();
}

class Words {
  String englishWord;
  String translation;

  Words(this.englishWord, this.translation);
}

class _DictionaryState extends State<Dictionary> {
  final TextEditingController englishController = TextEditingController();
  final TextEditingController translationController = TextEditingController();
  final List<Words> words = [];

  void sortEng() {
    setState(() {
      words.sort((a, b) => a.englishWord.toLowerCase().compareTo(b.englishWord.toLowerCase()));
    });
  }

  void sortRus() {
    setState(() {
      words.sort((a, b) => a.translation.toLowerCase().compareTo(b.translation.toLowerCase()));
    });
  }

  bool hasDuplicate(ruWord) {
    for (int i = 0; i < words.length; i++) {
      if (words[i].translation == ruWord) {
        return true;
      }
    }
    return false;
  }

  void addWord() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Word'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: englishController,
                decoration: InputDecoration(
                  labelText: 'English word',
                ),
              ),
              TextField(
                controller: translationController,
                decoration: InputDecoration(
                  labelText: 'Translation',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                englishController.clear();
                translationController.clear();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (englishController.text.isNotEmpty && translationController.text.isNotEmpty) {
                  if (hasDuplicate(translationController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('This word already exists', style: TextStyle(color: Colors.black)),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.deepPurpleAccent,
                      ),
                    );
                  }
                  else {
                  setState(() {
                    words.add(Words(englishController.text, translationController.text));
                  });
                  Navigator.of(context).pop();
                  englishController.clear();
                  translationController.clear();
                  }
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in both fields', style: TextStyle(color: Colors.black)),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      }
    );
  }

  void editWord(int index) {
    englishController.text = words[index].englishWord;
    translationController.text = words[index].translation;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Word'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: englishController,
                decoration: InputDecoration(
                  labelText: 'English word',
                ),
              ),
              TextField(
                controller: translationController,
                decoration: InputDecoration(
                  labelText: 'Translation',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                englishController.clear();
                translationController.clear();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (englishController.text.isNotEmpty && translationController.text.isNotEmpty) {
                  setState(() {
                    words[index] = Words(englishController.text, translationController.text);
                  });
                  Navigator.of(context).pop();
                  englishController.clear();
                  translationController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please fill in both fields',
                        style: TextStyle(color: Colors.black),
                      ),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    englishController.dispose();
    translationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dictionary'),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Text("EN"),
            onPressed: sortEng,
          ),
          IconButton(
            icon: Text("RU"),
            onPressed: sortRus,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Text(
                '${index + 1}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              title: Text('English: ${words[index].englishWord}'),
              subtitle: Text('Translation: ${words[index].translation}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    tooltip: 'Edit',
                    onPressed: () => editWord(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete',
                    onPressed: () {
                      setState(() {
                        words.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addWord,
        backgroundColor: Colors.deepPurpleAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}