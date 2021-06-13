// This is a simple abstract class acting as a contract for getting data
// Does not know from where or how data will arrive
// Only knows data will arrive and it will have to!
// So we can say that this is only the contract of repository for getting data

import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepository {
  // For getting concrete number trivia
  // Here datatype would not be concrete as we would be identifying the errors here
  // So Datatype used here will be Future<Either<L,R>>
  // L is the Failure case (Failure in our case)
  // R is the success case (NumberTrivia in our case)
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);

  // for getting random number trivia
  // same return type as that of above one
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
