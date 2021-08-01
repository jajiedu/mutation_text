import 'qs_quiz1_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'quiz_quiz1_model.g.dart';

@JsonSerializable(explicitToJson: true)
class QuizModelQuiz1 {
  QuizModelQuiz1({
    this.id,
    this.questionNormal,
    this.questionFurigana,
    this.questionTranslate,
    this.listSubQuestion,
  });

  String? id = ''; // id của bài tập
  /// Đề bài(normal)
  String? questionNormal = '';

  /// Đề bài(furigana) 1
  String? questionFurigana = '';

  /// Đề bài(translate)
  String? questionTranslate = '';

  ///danh sách câu hỏi
  @JsonSerializable(explicitToJson: true)
  List<QsModel>? listSubQuestion = [];

  factory QuizModelQuiz1.fromJson(Map<String, dynamic> json) =>
      _$QuizModelQuiz1FromJson(json);

  Map<String, dynamic> toJson() => _$QuizModelQuiz1ToJson(this);
}
