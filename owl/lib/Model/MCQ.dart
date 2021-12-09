class MCQ {
  String id;
  String question;
  String option1;
  String option2;
  String option3;
  String option4;
  String correctOption;

  MCQ(this.question, this.option1, this.option2, this.option3, this.option4, this.correctOption);

  // Convert an MCQ object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['mcqID'] = id;
    }
    map['question'] = question;
    map['option1'] = option1;
    map['option2'] = option2;
    map['option3'] = option3;
    map['option4'] = option4;
    map['correctOption'] = correctOption;

    return map;
  }

  // Extract an MCQ object from a Map object
  MCQ.fromMapObject(Map<String, dynamic> map) {
    this.id = map['mcqID'];
    this.question = map['question'];
    this.option1 = map['option1'];
    this.option2 = map['option2'];
    this.option3 = map['option3'];
    this.option4 = map['option4'];
    this.correctOption = map['correctOption'];
  }
}
