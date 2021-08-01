import 'package:flutter/widgets.dart';
import 'package:mutation_text/ruby_text/ruby_text.dart';
import '/../utils/string_extension.dart';

class MutationText extends StatelessWidget {
  const MutationText(this.normalText,
      {this.furiganaText,
      this.furiganaMode,
      this.onTextChanged,
      this.onTapChildText});

  final String? normalText;
  final String? furiganaText;
  final bool? furiganaMode;
  final Function(String, double)? onTextChanged;
  final Function(String)? onTapChildText;

  @override
  Widget build(BuildContext context) {
    return genderMutationText(normalText,
        furiganaText: furiganaText, furiganaMode: furiganaMode);
  }

  ///xử lý chuỗi:
  //cắt thành từng đoạn văn
  Widget genderMutationText(String? normalText,
      {String? furiganaText, bool? furiganaMode}) {
    List<Widget> listWidget = <Widget>[];
    var normals = <String>[]; // đoạn văn bình thường
    var furiganas = <List<RubyTextData>>[]; // đoạn văn được rắc furigane

    if (furiganaText != null) {
      List<String> f = furiganaText.split('\\n');
      for (var i = 0; i < f.length; i++) {
        furiganas.add(convertTextToRuby(f[i]));
      }
    }

    List<String> n = normalText!.split('\\n');
    for (var i = 0; i < n.length; i++) {
      normals.add(n[i]);
    }
// trả về Container rỗng khi không có input
    if (normals.length == 0 && furiganas.length == 0) {
      listWidget.add(Container());
    }
// trả về text thông thường khi không có
    else if (normals.length != 0 && furiganas.length == 0 ||
        furiganaMode == false) {
      for (var i = 0; i < normals.length; i++) {
        listWidget.add(Text(normals[i]));
      }
    }
    // muốn có furigane
    else {
      for (var i = 0; i < furiganas.length; i++) {
        listWidget.add(RubyText(
          normals[i],
          furiganas[i],
          onTextChanged: onTextChanged,
          onTapChildText: onTapChildText,
        ));
      }
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: listWidget);
  }

  /// chuyển đổi sang sạng ruby text
  List<RubyTextData> convertTextToRuby(String text) {
    List<String> listP = text.split('/n');
    List<RubyTextData> rubyText = <RubyTextData>[];
    for (var p in listP) {
      var isKanji = false;
      //var isBracket = false;
      var isUnderlined = false;
      int startIndex = 0;
      // biến trung gian
      RubyTextData qsRubyTextModel = RubyTextData();
      List<String> characters = p.split('');
      // chạy vòng lặp tới khi gặp chữ kanji
      for (int i = 0; i < characters.length; i++) {
        // khi là chữ kanji thì check xem phía trước có phải dấu ngoặc không
        if (characters[i].isKanji()) {
          // nếu phía trước là dấu ngoặc
          if (characters[i + 1] == '(') {
            //lưu lại giá trị của text từ vị trí start tới điểm trước dấu ngoặc
            qsRubyTextModel.text = p.substring(startIndex, i + 1);
            //nếu thành phần đó đc gạch chân thì thiết định style
            if (isUnderlined) {
              qsRubyTextModel.isUnderlined = true;
            }
            //sau khi lưu giá trị thì thiết định lại điểm start
            startIndex = i + 1;
            // bật cờ kanji
            isKanji = true;
          }
        } //khi là dấu ngoặc thì check xem cờ kanji có đang được bật không
        // nếu cờ đang được bật thi dấu ngoặc đó là dấu ngoặc ở xử lý trên
        // khi đó tăng điểm start lên 1 để bỏ qua dấu ngoặc
        else if (characters[i] == '(' && isKanji) {
          startIndex++;
        } //khi là dấu ngoặc đóng thì check xem cờ kanji có đang được bật không
        //nếu đang được bật thì đâu là dấu đóng ngoặc của nội dung furigane
        // khi ấy lưu giá trị furigana từ điểm start tới điểm trước dấu ngoặc
        // đóng, sau đó tăng điểm start lên 1 để bỏ qua dấu ngoặc
        else if (characters[i] == ')' && isKanji) {
          // lưu giá trị từ vị trí start tới trước dấu ngoặc
          qsRubyTextModel.ruby = p.substring(startIndex, i);
          //nếu thành phần đó đc gạch chân thì thiết định style
          if (isUnderlined) {
            qsRubyTextModel.isUnderlined = true;
          }
          // tăng điểm start
          startIndex = i + 1;
          // tắt cờ kanji
          isKanji = false;
          //lưu ruby data vào mảng
          rubyText.add(qsRubyTextModel);
          // khởi tạo lại biến trung gian
          qsRubyTextModel = RubyTextData();
        } // khi gặp kí tự 'u' thì bật cờ gạch chân lên
        // phần này dùng để thiết định style cho chữ
        else {
          if (characters[i] == 'u') {
            // bật tắt cờ gạch chân
            isUnderlined = !isUnderlined;
            // tăng điểm start lên 1 để bỏ qua chữ u
            startIndex++;
          } else {
            //nếu kí tự không thuộc phạm vi chữ kanji và các kí tự đánh dấu
            //thì là kí tự không furigane nên sẽ lưu giá trị
            if (isKanji == false) {
              // lưu kí tự
              qsRubyTextModel.text = characters[i];
              // tăng điểm start lên 1
              startIndex = i + 1;
              //nếu thành phần đó đc gạch chân thì thiết định style
              if (isUnderlined) {
                qsRubyTextModel.isUnderlined = true;
              }
              // lưu giá trị vào mảng
              rubyText.add(qsRubyTextModel);
              // khởi tạo lại biến trung gian
              qsRubyTextModel = RubyTextData();
            }
          }
        }
      }
    }
    return rubyText;
  }
}
