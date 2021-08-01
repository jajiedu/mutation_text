// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'as_quiz1_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AsModel _$AsModelFromJson(Map<String, dynamic> json) {
  return AsModel(
    answerNormal: json['answerNormal'] as String?,
    answerFurigana: json['answerFurigana'] as String?,
    isTrue: json['isTrue'] as bool?,
  );
}

Map<String, dynamic> _$AsModelToJson(AsModel instance) => <String, dynamic>{
      'answerNormal': instance.answerNormal,
      'answerFurigana': instance.answerFurigana,
      'isTrue': instance.isTrue,
    };
