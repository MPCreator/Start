import 'package:flutter/material.dart';
import '../utils/sizes.dart';
import 'answer_widget.dart';
import '../models/question.dart';

class SubQuestionWidget extends StatelessWidget {
  final SubQuestion subQuestion;
  final ValueChanged<String> onAnswerChanged;

  const SubQuestionWidget({super.key, 
    required this.subQuestion,
    required this.onAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          subQuestion.questionText,
          style: TextStyle(fontSize: AppSizes.customSizeHeight(context, 0.019), fontWeight: FontWeight.w500,)
        ),
        SizedBox(height: AppSizes.customSizeHeight(context, 0.008)),
        AnswerWidget(
          question: Question(
            id: subQuestion.id,
            questionText: subQuestion.questionText,
            type: subQuestion.type,
            answer: subQuestion.answer,
            options: subQuestion.options,
            scaleLabels: subQuestion.scaleLabels,
            minScale: subQuestion.minScale,
            maxScale: subQuestion.maxScale,
          ),
          onAnswerChanged: onAnswerChanged,
        ),
      ],
    );
  }
}