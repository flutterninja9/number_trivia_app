import 'package:clean_architecture_tdd/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test('should return an unsigendInt when a proper String is passed', () {
      //arrange
      final str = '123';
      //act
      final result = inputConverter.stringToUnsignedInt(str);
      //assert
      expect(result, Right(123));
    });
    test('should throw a Failure when string is not parsed to int', () {
      //arrange
      final str = 'abc';
      //act
      final result = inputConverter.stringToUnsignedInt(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });
    test('should throw a Failure when parsed string is negative integer', () {
      //arrange
      final str = '-123';
      //act
      final result = inputConverter.stringToUnsignedInt(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
