import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/usecases/use_cases.dart';
import 'package:clean_architecture_tdd/core/utils/input_converter.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia getConcreteNumberTrivia;
  MockGetRandomNumberTrivia getRandomNumberTrivia;
  MockInputConverter inputConverter;

  setUp(() {
    getConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    getRandomNumberTrivia = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();

    // bLoc instantiated
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: getConcreteNumberTrivia,
      getRandomNumberTrivia: getRandomNumberTrivia,
      inputConverter: inputConverter,
    );
  });

  test('initial state if bloc should be Empty()', () async {
    //assert
    expect(bloc.state, equals(Empty()));
  });

  // Group of tests for GetTriviaForConcreteNumber
  group('GetTriviaForConcreteNumber', () {
    final tNumberString = "1";
    final tNumberParsed = 1;
    final tNumberTrivia =
        NumberTrivia(number: tNumberParsed, text: "Test Text");

    void setupMockInputConverterSuccess() =>
        when(inputConverter.stringToUnsignedInt(any))
            .thenReturn(Right(tNumberParsed));

    // tests goes here
    test('should call InputConverter for parsing the String to Unsigned Int',
        () async {
      //arrange
      setupMockInputConverterSuccess();
      //act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
      // For awaiting for this call coz. its a stream and it takes time to complete
      await untilCalled(inputConverter.stringToUnsignedInt(any));
      //assert
      verify(inputConverter.stringToUnsignedInt(tNumberString));
    });
    test('should emit [Error] when the input is invalid', () {
      //arange
      when(inputConverter.stringToUnsignedInt(any))
          .thenReturn(Left(InvalidInputFailure()));
      // assert
      // assert is above act coz. we are expectng tehse states to be emmited ater the add of theevent form bloc
      expectLater(
          bloc.state,
          emitsInAnyOrder([
            Empty(),
            Error(message: INVALID_INPUT_FAILURE_MESSAGE),
          ]));
      //act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });
    test(
        'should return NumberTrivia, when call to getConcreteNumberTrivia is successfull',
        () async {
      //arrange
      setupMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(getConcreteNumberTrivia(any));
      //assert
      verify(getConcreteNumberTrivia(Params(number: tNumberParsed)));
    });
    test('should emit [LOADING,LOADED] when data is gotten successfully',
        () async {
      //arrange
      setupMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      //assert later
      expectLater(
          bloc.state,
          emitsInAnyOrder([
            Empty(),
            Loading(),
            Loaded(trivia: tNumberTrivia),
          ]));
      //act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });
    test('should emit [LOADING,ERROR] when getting data is failed', () async {
      //arrange
      setupMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      //assert later
      expectLater(
          bloc.state,
          emitsInAnyOrder([
            Empty(),
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ]));
      //act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });
    test('should emit [LOADING,ERROR] when getting data is failed', () async {
      //arrange
      setupMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      //assert later
      expectLater(
          bloc.state,
          emitsInAnyOrder([
            Empty(),
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ]));
      //act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));
    });
  });

  // group for getRandomNumberTrivia
  group('GetTriviaForRandomNumber', () {
    final tNumberParsed = 1;
    final tNumberTrivia =
        NumberTrivia(number: tNumberParsed, text: "Test Text");

    // tests goes here
    test(
        'should return NumberTrivia, when call to getConcreteNumberTrivia is successfull',
        () async {
      //arrange
      when(getRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(getRandomNumberTrivia(NoParams()));
      //assert
      verify(getRandomNumberTrivia(NoParams()));
    });
    test('should emit [LOADING,LOADED] when data is gotten successfully',
        () async {
      //arrange
      when(getRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => Right(tNumberTrivia));
      //assert later
      expectLater(
          bloc.state,
          emitsInOrder([
            Empty(),
            Loading(),
            Loaded(trivia: tNumberTrivia),
          ]));
      //act
      bloc.add(GetTriviaForRandomNumber());
    });
    test('should emit [LOADING,ERROR] when getting data is failed', () async {
      //arrange
      when(getRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));
      //assert later
      expectLater(
          bloc.state,
          emitsInOrder([
            Empty(),
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE),
          ]));
      //act
      bloc.add(GetTriviaForRandomNumber());
    });
    test('should emit [LOADING,ERROR] when getting data is failed', () async {
      //arrange
      when(getRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => Left(CacheFailure()));
      //assert later
      expectLater(
          bloc.state,
          emitsInOrder([
            Empty(),
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ]));
      //act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
