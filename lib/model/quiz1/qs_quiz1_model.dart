import 'package:json_annotation/json_annotation.dart';
import 'as_quiz1_model.dart';
part 'qs_quiz1_model.g.dart';

@JsonSerializable(explicitToJson: true)
class QsModel {
  QsModel(
      {this.subQuestionNormal,
      this.subQuestionFurigana,
      this.listSubQuestion,
      this.explain});

  String? subQuestionNormal = ''; // Câu hỏi (normal)
  String? subQuestionFurigana = ''; //Câu hỏi (furigana)
  @JsonSerializable(explicitToJson: true)
  List<AsModel>? listSubQuestion = []; // danh sách câu các đáp án
  String? explain = '';

  factory QsModel.fromJson(Map<String, dynamic> json) =>
      _$QsModelFromJson(json);
  Map<String, dynamic> toJson() => _$QsModelToJson(this);
}
