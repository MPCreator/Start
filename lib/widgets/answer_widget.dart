import 'package:flutter/material.dart';
import '../models/question.dart';

class AnswerWidget extends StatelessWidget {
  final Question question;
  final ValueChanged<String> onAnswerChanged;

  const AnswerWidget({super.key,
    required this.question,
    required this.onAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (question.type) {
      case QuestionType.SI_NO:
        return Row(
          children: [
            _buildRadioButton('Sí'),
            _buildRadioButton('No'),
          ],
        );
      case QuestionType.TEXTO:
        return TextField(
          onChanged: (value) {
            onAnswerChanged(value);
          },
          decoration: const InputDecoration(hintText: 'Escribe tu respuesta'),
        );
      case QuestionType.COMBO_BOX:
        return Center(
          child: DropdownButton<String>(
            value: question.answer,
            onChanged: (value) {
              onAnswerChanged(value!);
            },
            items: question.options!
                .map((option) =>
                DropdownMenuItem(value: option, child: Text(option)))
                .toList(),

          ),
        );
      case QuestionType.MULTIPLE_OPTIONS:
        return Column(
          children: question.options!
              .map((option) =>
              CheckboxListTile(
                title: Text(option),
                value: question.answer == option,
                onChanged: (value) {
                  onAnswerChanged(option);
                },
              ))
              .toList(),
        );
      case QuestionType.ESCALA:
        if (question.answer == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onAnswerChanged(question.minScale!.toString());
          });
        }

        return Column(
          children: [
            Slider(
              value: double.tryParse(question.answer ?? question.minScale!.toString()) ?? question.minScale!,
              min: question.minScale ?? 1,
              max: question.maxScale ?? 5,
              divisions: (question.maxScale! - question.minScale!).toInt(),
              label: question.scaleLabels != null && question.answer != null
                  ? question.scaleLabels![double.tryParse(question.answer!)!.toInt() - 1]
                  : question.scaleLabels != null
                  ? question.scaleLabels![question.minScale!.toInt() - 1]
                  : '',
              onChanged: (value) {
                onAnswerChanged(value.toString());
              },
            ),
          ],
        );


      default:
        return Container();
    }
  }

  Widget _buildRadioButton(String value) {
    return Expanded(
      child: RadioListTile<String>(
        title: Text(value),
        value: value,
        groupValue: question.answer,
        onChanged: (newValue) {
          onAnswerChanged(newValue!);
        },
      ),
    );
  }
}

