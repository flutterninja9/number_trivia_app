import 'dart:convert';

import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test('Should be a subclass of numberTriviaEntity', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  // Testing fromJson
  // Group is a series of tests
  group('fromJson', () {
    // Test for int
    test('should return a valid model when , nmber from json is integer',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia.json'));

      //act
      final result = NumberTriviaModel.fromJson(jsonMap);

      //assert
      expect(result, tNumberTriviaModel);
    });

    // Test for double

    test('should return a valid model when , number from json is Double',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('trivia_double.json'));

      //act
      final result = NumberTriviaModel.fromJson(jsonMap);

      //assert
      expect(result, tNumberTriviaModel);
    });
  });

  // Testing for toJson
  group('toJson', () {
    test('should return a valid Map with proper data', () async {
      // expect
      final result = tNumberTriviaModel.toJson();
      //assert
      Map<String, dynamic> testData = {"text": "Test Text", "number": 1};
      expect(result, testData);
    });
  });
}
