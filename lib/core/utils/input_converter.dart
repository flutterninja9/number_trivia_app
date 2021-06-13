import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInt(String str) {
    try {
      final parsedInt = int.parse(str);
      if (parsedInt.isNegative) {
        throw FormatException();
      } else {
        return Right(parsedInt);
      }
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
