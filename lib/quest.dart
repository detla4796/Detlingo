import 'package:flutter/material.dart';
import 'quests.dart';

class Quest extends StatefulWidget {
  const Quest({super.key});
  @override
  State<Quest> createState() => _QuestState();
}


class _QuestState extends State<Quest> {
  List<Quests> quests = [
    Quests(
      questionText: "What means Hello in Russia?",
      answers: [
        Answer(answerText: "Привет"),
        Answer(answerText: "Пока"),
        Answer(answerText: "Нет"),
        Answer(answerText: "Да"),
      ],
      correctIndex: 0,
    ),
    Quests(
      questionText: "What means Goodbye in Russia?",
      answers: [
        Answer(answerText: "Необычно"),
        Answer(answerText: "Пока"),
        Answer(answerText: "Хорошо"),
        Answer(answerText: "Здорово"),
      ],
      correctIndex: 1,
    ),
    Quests(
      questionText: "What means Please in Russia?",
      answers: [
        Answer(answerText: "Не за что"),
        Answer(answerText: "Купить"),
        Answer(answerText: "Пожалуйста"),
        Answer(answerText: "Крупа"),
      ],
      correctIndex: 2,
    ),
  ];

  List<int?> usersAnswer = [];
  Color backColor = Colors.white; // Тут я добавил переменную для дефолтного цвета фона

  @override
  void initState() {
    super.initState();
    usersAnswer = List<int?>.filled(quests.length, null);
  }

  void selectAnswer(questIndex, answerIndex) {
    setState(() {
      usersAnswer[questIndex] = answerIndex;
    });
  }

  // Сброс ответов
  void resetAnswers() {
    setState(() {
      usersAnswer = List<int?>.filled(quests.length, null);
    });
  }

  // Смена цвета в зависимости от правильности ответов
  void updateBackground(score) {
    setState(() {
      backColor = score == quests.length ? Colors.green : Colors.red;
    });
  }

  int calculateScore() {
    int score = 0;
    for (int i = 0; i < quests.length; i++) {
      if (usersAnswer[i] == quests[i].correctIndex) {
        score++;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor, // Вписал дефолтный цвет
      appBar: AppBar(
        title: Text('Test'),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: quests.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color.fromARGB(255, 233, 208, 255),
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    quests[index].questionText,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    spacing: 10,
                    children: List.generate(
                      quests[index].answers.length,
                      (answerIndex) => RadioListTile(
                        title: Text(
                          quests[index].answers[answerIndex].answerText,
                        ),
                        value: answerIndex,
                        groupValue: usersAnswer[index],
                        onChanged: (value) {
                          selectAnswer(index, value);
                        },
                      ),
                    ),
                  ),
                ]
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        hoverColor: Colors.deepPurple,
        onPressed: () {
          int finalScore = calculateScore();
          updateBackground(finalScore); // Изменение цвета в зависимости от ответов
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Result'),
                content: Text('Your score is: $finalScore out of ${quests.length}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      resetAnswers(); // Теперь при нажатии на кнопку "ОК" все сбрасывается
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.check),
      ),
    );
  }
}