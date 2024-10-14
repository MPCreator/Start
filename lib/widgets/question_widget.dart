import 'package:flutter/material.dart';
import 'package:start/utils/sizes.dart';
import 'subquestion_widget.dart';
import 'answer_widget.dart';
import '../models/question.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final ValueChanged<String> onAnswerChanged;

  const QuestionWidget({super.key,
    required this.question,
    required this.onAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          question.questionText,
          style: TextStyle(fontSize: AppSizes.customSizeHeight(context, 0.019), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: AppSizes.customSizeHeight(context, 0.016)),
        AnswerWidget(
          question: question,
          onAnswerChanged: onAnswerChanged,
        ),
      ],
    );
  }
}
