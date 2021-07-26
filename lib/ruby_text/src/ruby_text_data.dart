import 'package:flutter/widgets.dart';

class RubyTextData {
  RubyTextData({this.text, this.ruby, this.isUnderlined});
  RubyTextData.fromJson(Map<String, Object?> json)
      : this(
          text: json['text']! as String,
          ruby: json['ruby']! as String,
          isUnderlined: json['isUnderlined']! as bool,
        );

  String? text = '';
  String? ruby = '';
  bool? isUnderlined;
  Map<String, Object?> toJson() {
    return {
      'text': text,
      'ruby': ruby,
      'isUnderlined': isUnderlined,
    };
  }

  int getLength() {
    return text!.length;
  }
}
