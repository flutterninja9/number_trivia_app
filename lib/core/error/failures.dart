import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

// Just an abstract class, and will be acting as a model for our errors
abstract class Failure extends Equatable {
  Failure([List properties = const <dynamic>[]]) : super([properties]);
}

// General Failures
// thrown when mis-things happen in network related states
class ServerFailure extends Failure {}

// Thrown when mis-things happen in caching
class CacheFailure extends Failure {}
