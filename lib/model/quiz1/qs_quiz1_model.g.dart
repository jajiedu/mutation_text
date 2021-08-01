// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qs_quiz1_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QsModel _$QsModelFromJson(Map<String, dynamic> json) {
  return QsModel(
    subQuestionNormal: json['subQuestionNormal'] as String?,
    subQuestionFurigana: json['subQuestionFurigana'] as String?,
    listSubQuestion: (json['listSubQuestion'] as List<dynamic>?)
        ?.map((e) => AsModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    explain: json['explain'] as String?,
  );
}

Map<String, dynamic> _$QsModelToJson(QsModel instance) => <String, dynamic>{
      'subQuestionNormal': instance.subQuestionNormal,
      'subQuestionFurigana': instance.subQuestionFurigana,
      'listSubQuestion':
          instance.listSubQuestion?.map((e) => e.toJson()).toList(),
      'explain': instance.explain,
    };
