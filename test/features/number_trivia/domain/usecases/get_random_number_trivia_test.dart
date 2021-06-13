// file name is same as that of production fileName, but we append test for better naming convention
// As we know data will be called from repository in the production code, So as we don't have the implementation yet
// It is a better practice for mocking that data , We use mockito for that
// In this way we can easily test all the methods irrespective of the data we get

import 'package:clean_architecture_tdd/core/usecases/use_cases.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia useCase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  // Initial setup for test

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    // Becase we will pass instance if repository in the actual useCase too
    useCase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  // Predecided output
  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: tNumber, text: 'Test Number');

  // Actual Test code
  test(
      'should get trivia for a random number from the number trivia repository',
      () async {
    // arrange
    // {Provide functionality to the mocked instance of the repository here}
    // We are saying that when we are calling calling getyConcreteNumberTrivia from the repository, then return right side(i.e: success side) of the NumberTriviaRepository
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));

    //act
    final result = await useCase(NoParams());

    //assert
    expect(result, Right(tNumberTrivia));
    // Adds a layer of protection by telling weather when() was called on same arguments as that of the below arguments
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    // Checks wheather everything has completed running or not
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
