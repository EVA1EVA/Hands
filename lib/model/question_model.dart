class QuestionModel {
  int? id;
  String? questionText;
  String? type; // نصي، خيارات، إلخ
  List<String>? options; // إذا كان هناك خيارات

  QuestionModel({this.id, this.questionText, this.type, this.options});

  // هذه الدالة هي التي تحول الـ JSON القادم من لارافيل إلى كائن فلاتر
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      questionText: json['name'] ?? json['question'] ?? '', // حسب تسمية الباك إند
      type: json['type'] ?? 'text',
      // إذا كانت الخيارات تأتي كقائمة
      options: json['options'] != null ? List<String>.from(json['options']) : [],
    );
  }
}