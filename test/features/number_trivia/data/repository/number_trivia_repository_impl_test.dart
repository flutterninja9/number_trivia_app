import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/network/network_info.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/repository/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/sources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mocking Remote Data Source

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

// For mocking Local Data Sources

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

// For mocking NetworkInfo

class MockNetworkInfo extends Mock implements NetworkInfo {}

// Driver Code for test
void main() {
  NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;
  MockLocalDataSource localDataSource;
  MockRemoteDataSource remoteDataSource;
  MockNetworkInfo networkInfo;

  // Setting up initial things
  setUp(() {
    localDataSource = MockLocalDataSource();
    remoteDataSource = MockRemoteDataSource();
    networkInfo = MockNetworkInfo();
    numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
        networkInfo: networkInfo);
  });

  // Refactoring Codes for Online and Offline test

  void runTestsOnline(Function body) {
    group('when device is online', () {
      // IsConnected will always be true for these tests
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('when device is offline', () {
      // IsConnected will always be true for these tests
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  // grouping our tests
  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: "Test Text", number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if device is online', () async {
      //arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      //act
      numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
      //assert
      verify(networkInfo.isConnected);
    });

    // Tests for situation when device is online
    runTestsOnline(() {
      test(
          'should return remote data, when the connection to remote data sources is successfull',
          () async {
        // arrange
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });
      test(
          'should cache the data to local resource, when the connection to remote data sources is successfull',
          () async {
        // arrange
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'should return a ServerException, when the connection to remote data sources is unsuccessfull',
          () async {
        // arrange
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        //act
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(localDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    // Tests for situation when device is oflline

    runTestsOffline(() {
      test('should return last locally cached data when device is offline',
          () async {
        // arrange
        when(localDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });
      test('should return CacheFailure when there is no cached data', () async {
        // arrange
        when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        //act
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });

  // Tests for randomNumberTrivia

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: "Test Text", number: 123);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should check if device is online', () async {
      //arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      //act
      numberTriviaRepositoryImpl.getRandomNumberTrivia();
      //assert
      verify(networkInfo.isConnected);
    });

    // Tests for situation when device is online
    runTestsOnline(() {
      test(
          'should return remote data, when the connection to remote data sources is successfull',
          () async {
        // arrange
        when(remoteDataSource.getRadnomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        //assert
        verify(remoteDataSource.getRadnomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });
      test(
          'should cache the data to local resource, when the connection to remote data sources is successfull',
          () async {
        // arrange
        when(remoteDataSource.getRadnomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        //assert
        verify(remoteDataSource.getRadnomNumberTrivia());
        verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'should return a ServerException, when the connection to remote data sources is unsuccessfull',
          () async {
        // arrange
        when(remoteDataSource.getRadnomNumberTrivia())
            .thenThrow(ServerException());
        //act
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        //assert
        verify(remoteDataSource.getRadnomNumberTrivia());
        verifyZeroInteractions(localDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    // Tests for situation when device is oflline

    runTestsOffline(() {
      test('should return last locally cached data when device is offline',
          () async {
        // arrange
        when(localDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });
      test('should return CacheFailure when there is no cached data', () async {
        // arrange
        when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        //act
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
