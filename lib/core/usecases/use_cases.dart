// It is the file which will hold the abstract class (or interfaces) containing the call() for various use_cases

import 'dart:async';

import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {}
