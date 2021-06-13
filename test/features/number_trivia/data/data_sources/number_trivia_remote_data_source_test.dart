import 'dart:convert';

import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/sources/number_trivia_remote_data_source.dart';
import 'package:matcher/matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl remoteDataSourceImpl;
  MockHttpClient mockHttpClient;
  // Anonymous function for httpClientSucces, You will understand better just look at the code-piece in the 1-test
  final httpClientFunctionSuccess = () =>
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

  // Anonymous function for httpClientFailure, You will understand better just look at the code-piece in the 1-test
  final httpClientFunctionFailure = () =>
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong!', 404));

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSourceImpl =
        NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  // groups for randomNumber and ConcreteNumber endpoints
  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
    test(
      '''should perform a GET request on a URL with number being
           the endpoint & application/json header''',
      () async {
        //arrannge
        // anonymous function for when(Mock) arrange function
        httpClientFunctionSuccess(); // http.Response() takes in 2 default parameters body and statusCode
        //act
        remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/$tNumber',
          headers: {
            'content-type': 'application/json',
          },
        ));
      },
    );
    test(
      'should return NumberTrivia when the responseCode is 200',
      () async {
        //arrange
        httpClientFunctionSuccess();
        //act
        final result =
            await remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
        //assert
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'should throw ServerException when the responseCode is any errorCode',
      () async {
        //arrange
        httpClientFunctionFailure();
        //act
        final result = remoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
        //assert
        expect(result, throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
    test(
      '''should perform a GET request on a URL with number being
           the endpoint & application/json header''',
      () async {
        //arrannge
        // anonymous function for when(Mock) arrange function
        httpClientFunctionSuccess(); // http.Response() takes in 2 default parameters body and statusCode
        //act
        remoteDataSourceImpl.getRadnomNumberTrivia();
        //assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/random',
          headers: {
            'content-type': 'application/json',
          },
        ));
      },
    );
    test(
      'should return NumberTrivia when the responseCode is 200',
      () async {
        //arrange
        httpClientFunctionSuccess();
        //act
        final result = await remoteDataSourceImpl.getRadnomNumberTrivia();
        //assert
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'should throw ServerException when the responseCode is any errorCode',
      () async {
        //arrange
        httpClientFunctionFailure();
        //act
        final result = remoteDataSourceImpl.getRadnomNumberTrivia();
        //assert
        expect(result, throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
