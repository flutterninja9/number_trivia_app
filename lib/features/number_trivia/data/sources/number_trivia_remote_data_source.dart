import 'dart:convert';
import 'dart:developer';

import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  // Tries fetching raw_data from api)endpoint
  // Throws a [ServerException] when any mis-thing happens, for all the error codes

  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  // same as above , but the endpoint changes to /random
  Future<NumberTriviaModel> getRadnomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});
  @override

  /// Implementation for getConcreteNumberTrivia
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getNumberTriviaFromURL(
        url: 'http://numbersapi.com/$number?json',
      );

  /// Implementation for getRandomNumberTrivia
  @override
  Future<NumberTriviaModel> getRadnomNumberTrivia() => _getNumberTriviaFromURL(
        url: 'http://numbersapi.com/random?json',
      );

  // Rafactored Code for fetching NumberTriviaModel by getting parsing the jsonResponse
  Future<NumberTriviaModel> _getNumberTriviaFromURL({String url}) async {
    try {
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return NumberTriviaModel.fromJson(jsonDecode(response.body));
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
