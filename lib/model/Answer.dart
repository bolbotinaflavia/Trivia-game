class Answer {
  String? questionId;
  String? answerText;
  bool? isCorrect;
  int? priorityLevel;

  Answer({
    this.questionId,
    this.answerText,
    this.isCorrect,
    this.priorityLevel,
  });


  Answer.fromSnapshot(Map<String, dynamic> snapshot)
      : questionId=snapshot['questionId'],
        answerText = snapshot['answerText'],
        isCorrect = snapshot['isCorrect'],
        priorityLevel = snapshot['priorityLevel'];


  Map<String, dynamic> toFirestore() {
    return {
      'questionId':questionId,
      'answerText': answerText,
      'isCorrect': isCorrect,
      'priorityLevel': priorityLevel,
    };
  }
}
