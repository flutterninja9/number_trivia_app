import 'dart:convert';

import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/sources/number_trivia_local_data_source.dart';
import 'package:matcher/matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPrefrences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPrefrences sharedPrefrences;
  NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSourceImpl;

  setUp(() {
    sharedPrefrences = MockSharedPrefrences();
    numberTriviaLocalDataSourceImpl =
        NumberTriviaLocalDataSourceImpl(sharedPreferences: sharedPrefrences);
  });

  group('getLastKnownNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached.json')));
    test(
        'should give us the last cached object of NumberTrivia, when there is one in the cache',
        () async {
      //arrange
      when(sharedPrefrences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));
      //act
      final result =
          await numberTriviaLocalDataSourceImpl.getLastNumberTrivia();
      //assert
      verify(sharedPrefrences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });
    test('should throw a CacheException when there is no last cached data',
        () async {
      //arrange
      when(sharedPrefrences.getString(any)).thenReturn(null);
      //act
      final call = numberTriviaLocalDataSourceImpl.getLastNumberTrivia;
      //assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('chacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);
    test('should call the sharedPrefrences for caching the gotten numberTrivia',
        () async {
      //act
      numberTriviaLocalDataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
      //assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(
          sharedPrefrences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
