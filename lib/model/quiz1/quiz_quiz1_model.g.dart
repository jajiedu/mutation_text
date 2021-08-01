// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_quiz1_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizModelQuiz1 _$QuizModelQuiz1FromJson(Map<String, dynamic> json) {
  return QuizModelQuiz1(
    id: json['id'] as String?,
    questionNormal: json['questionNormal'] as String?,
    questionFurigana: json['questionFurigana'] as String?,
    questionTranslate: json['questionTranslate'] as String?,
    listSubQuestion: (json['listSubQuestion'] as List<dynamic>?)
        ?.map((e) => QsModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$QuizModelQuiz1ToJson(QuizModelQuiz1 instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionNormal': instance.questionNormal,
      'questionFurigana': instance.questionFurigana,
      'questionTranslate': instance.questionTranslate,
      'listSubQuestion':
          instance.listSubQuestion?.map((e) => e.toJson()).toList(),
    };
