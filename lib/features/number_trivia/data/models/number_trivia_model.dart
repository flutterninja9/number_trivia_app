// Always start developing this file first
// Models will act as a parser for the raw data coming from the harsh outside world of API's and 3rd party libraries
// Has functions like formJson() and toJson()

import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:meta/meta.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({
    @required String text,
    @required int number,
  }) : super(
            text: text,
            number:
                number); // Passing things to the superclass i.e. NumberTrivia

  // Defining factory methods here
  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
        text: json['text'],
        number: (json['number'] as num)
            .toInt()); // num can be of any number dataype irrespective of its initial Datatype
  }

  // Implementing toJson factory method
  Map<String, dynamic> toJson() {
    return {"text": text, "number": number};
  }
}
