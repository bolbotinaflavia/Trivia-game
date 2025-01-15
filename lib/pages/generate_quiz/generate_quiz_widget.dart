import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GenerateQuizWidget extends StatefulWidget {
  final String quizTitle;
  final String quizId;

  const GenerateQuizWidget(
      {Key? key,
      required this.quizTitle,
      required this.quizId,
      required String userId})
      : super(key: key);

  @override
  State<GenerateQuizWidget> createState() => _GenerateQuizWidgetState();
}

class _GenerateQuizWidgetState extends State<GenerateQuizWidget> {
  final TextEditingController numberOfQuestionsController =
      TextEditingController();
  final TextEditingController themeController = TextEditingController();
  bool includeHints = true;
  bool isLoading = false;

  Future<void> generateAndSaveQuiz() async {
    final numberOfQuestions =
        int.tryParse(numberOfQuestionsController.text.trim()) ?? 0;
    final theme = themeController.text.trim();

    if (numberOfQuestions == 0 || theme.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      const apiUrl = 'https://api.openai.com/v1/chat/completions';

      final prompt = '''
Create a quiz with the following specifications:
- Number of Questions: $numberOfQuestions
- Theme: $theme
- Include Hints: ${includeHints ? 'Yes' : 'No'}

Each question should include:
- The question text
- Four answer choices (A, B, C, D)
- The correct answer
- Hint (if applicable)
      ''';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant.'},
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 1500,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final quizContent = data['choices'][0]['message']['content'];

        // Parse the generated content into structured data
        final questions = _parseQuizContent(quizContent);

        // Save the quiz to Firestore
        await _saveQuizToFirestore(questions);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Quiz generated and saved successfully!')),
        );
      } else {
        print('Error: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate quiz')),
        );
      }
    } catch (e) {
      print('Error generating quiz: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _parseQuizContent(String content) {
    // Example parsing logic, adjust based on your expected response format
    // Assuming the format:
    // Question 1: ...
    // A: ...
    // B: ...
    // C: ...
    // D: ...
    // Correct Answer: A
    // Hint: ...
    final questions = <Map<String, dynamic>>[];
    final lines = content.split('\n');

    Map<String, dynamic>? currentQuestion;
    for (final line in lines) {
      if (line.startsWith('Question')) {
        if (currentQuestion != null) {
          questions.add(currentQuestion);
        }
        currentQuestion = {'question': line.split(':').last.trim()};
      } else if (line.startsWith('A:') ||
          line.startsWith('B:') ||
          line.startsWith('C:') ||
          line.startsWith('D:')) {
        final choice = line.split(':').first.trim();
        currentQuestion?[choice] = line.split(':').last.trim();
      } else if (line.startsWith('Correct Answer:')) {
        currentQuestion?['correctAnswer'] = line.split(':').last.trim();
      } else if (line.startsWith('Hint:')) {
        currentQuestion?['hint'] = line.split(':').last.trim();
      }
    }
    if (currentQuestion != null) {
      questions.add(currentQuestion);
    }
    return questions;
  }

  Future<void> _saveQuizToFirestore(
      List<Map<String, dynamic>> questions) async {
    final quizRef =
        FirebaseFirestore.instance.collection('quizzes').doc(widget.quizId);

    // Add questions as a subcollection
    for (var i = 0; i < questions.length; i++) {
      final question = questions[i];
      await quizRef.collection('questions').add({
        'text': question['question'],
        'choices': {
          'A': question['A'],
          'B': question['B'],
          'C': question['C'],
          'D': question['D'],
        },
        'correctAnswer': question['correctAnswer'],
        'hint': question['hint'] ?? '',
        'index': i + 1,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizTitle),
        backgroundColor: const Color(0xFF1D5D8A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: numberOfQuestionsController,
              decoration: const InputDecoration(
                labelText: 'Number of Questions',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: themeController,
              decoration: const InputDecoration(
                labelText: 'Theme',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Switch(
                  value: includeHints,
                  onChanged: (value) {
                    setState(() {
                      includeHints = value;
                    });
                  },
                ),
                const Text('Include Hints'),
              ],
            ),
            const SizedBox(height: 24),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: generateAndSaveQuiz,
                    child: const Text('Generate and Save Quiz'),
                  ),
          ],
        ),
      ),
    );
  }
}
