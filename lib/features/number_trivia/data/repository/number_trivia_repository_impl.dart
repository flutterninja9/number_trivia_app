import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repository/number_trivia_repository.dart';
import '../sources/number_trivia_local_data_source.dart';
import '../sources/number_trivia_remote_data_source.dart';

// We cannot rely on a 3rd-party library like connectivity directly from this class, So we keep all of this in a simple lean class NetworkInfo under lib/core/platform
// Goes inside core/platform coz. checking for connectivity is a type of feature which can be used cross multiple features

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.localDataSource,
    @required this.networkInfo,
    @required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRadnomNumberTrivia();
    });
  }

  // We are going to use Higher Order Functions for better code-re-usability, i.e. depending upon argument type we will get concrete or randomNumber trivia

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      Future<NumberTrivia> Function() getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
