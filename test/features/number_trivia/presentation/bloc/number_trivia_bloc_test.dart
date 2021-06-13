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
    expect(bloc.initialState, equals(Empty()));
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
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
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
      // assert is above act coz. we are expectng tehse states to be emmited ater the dispatch of theevent form bloc
      expectLater(
          bloc.state,
          emitsInAnyOrder([
            Empty(),
            Error(INVALID_INPUT_FAILURE_MESSAGE),
          ]));
      //act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });
    test(
        'should return NumberTrivia, when call to getConcreteNumberTrivia is successfull',
        () async {
      //arrange
      setupMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      //act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
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
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
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
            Error(SERVER_FAILURE_MESSAGE),
          ]));
      //act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
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
            Error(CACHE_FAILURE_MESSAGE),
          ]));
      //act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
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
      bloc.dispatch(GetTriviaForRandomNumber());
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
      bloc.dispatch(GetTriviaForRandomNumber());
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
            Error(SERVER_FAILURE_MESSAGE),
          ]));
      //act
      bloc.dispatch(GetTriviaForRandomNumber());
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
            Error(CACHE_FAILURE_MESSAGE),
          ]));
      //act
      bloc.dispatch(GetTriviaForRandomNumber());
    });
  });
}
