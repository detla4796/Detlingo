import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Dictionary extends StatefulWidget {
  const Dictionary({super.key});

  @override
  State<Dictionary> createState() => _DictionaryState();
}

class Words {
  String englishWord;
  String translation;

  Words(this.englishWord, this.translation);

  Map<String, dynamic> toMap() {
    return {
      'english' : englishWord,
      'russian' : translation
    };
  }

  static Words fromMap(Map<String, dynamic> map) {
    return Words(
      map['english'],
      map['russian'],
    );
  }

  String toJson() {
    final map = toMap();
    return json.encode(map);
  }

  static Words fromJson(jsonString) {
    final map = json.decode(jsonString);
    return fromMap(map);
  }
}

class _DictionaryState extends State<Dictionary> {
  final TextEditingController englishController = TextEditingController();
  final TextEditingController translationController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  List<Words> words = [];
  List<Words> filteredWords = [];

  _saveWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = words.map((item) => item.toJson()).toList();
    await prefs.setStringList('words', jsonList);
  }

  _loadWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('words');
    if (jsonList != null) {
      setState(() {
        words = jsonList.map((item) => Words.fromJson(item)).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  @override
  void dispose() {
    englishController.dispose();
    translationController.dispose();
    searchController.dispose();
    super.dispose();
  }

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

  void searchWord(query) { // поиск
    setState(() {
      if (query.isNotEmpty) {
        filteredWords = words.where((word) {
          return word.englishWord.toLowerCase().contains(query.toLowerCase()) || word.translation.toLowerCase().contains(query.toLowerCase());
        }).toList();
        }
    });
  }

  void showSearchDialog() { // окно с поиском
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search word'),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Enter word',
            ),
            onChanged: (value) {
              searchWord(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                searchController.clear();
                setState(() {
                  filteredWords.clear();
                });
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                searchWord(searchController.text);
              },
              child: Text('Search'),
            )
          ],
        );
      }
    );
  }

  bool hasDuplicate(enWord, ruWord) {
    bool hasExactMatch = false;
    bool hasSimilarMatch = false;

    for (int i = 0; i < words.length; i++) {
      if (words[i].englishWord.toLowerCase() == enWord.toLowerCase() && words[i].translation.toLowerCase() == ruWord.toLowerCase()) {
        hasExactMatch = true;
        break;
      }
      if (words[i].englishWord.toLowerCase() != enWord.toLowerCase() && words[i].translation.toLowerCase() == ruWord.toLowerCase()) {
        hasSimilarMatch = true;
        break;
      }
    }
    if (hasExactMatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This word already exists', style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.deepPurpleAccent,
        ),
      );
      return true;
    }
    if (hasSimilarMatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This word already exists with a different translation', style: TextStyle(color: Colors.black)),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.deepPurpleAccent,
        ),
      );
      return true;
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
                  if (!hasDuplicate(englishController.text, translationController.text)) {
                    setState(() {
                      words.add(Words(englishController.text, translationController.text));
                      _saveWords();
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
                  if (!hasDuplicate(englishController.text, translationController.text)) {
                    setState(() {
                      words[index] = Words(englishController.text, translationController.text);
                      _saveWords();
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
              child: Text('Save'),
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
          IconButton(
            icon: Icon(Icons.search),
            onPressed: showSearchDialog // кнопка окна поиска
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredWords.isEmpty ? words.length : filteredWords.length,
        itemBuilder: (context, index) {
          final word = filteredWords.isEmpty ? words[index] : filteredWords[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Text(
                '${index + 1}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              title: Text('English: ${word.englishWord}'),
              subtitle: Text('Translation: ${word.translation}'),
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
                        _saveWords();
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