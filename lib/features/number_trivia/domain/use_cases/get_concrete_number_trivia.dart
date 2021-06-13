import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/use_cases.dart';
import '../entities/number_trivia.dart';
import '../repository/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  NumberTriviaRepository repository;
  GetConcreteNumberTrivia(this.repository);

  // Becasue Dart support Callable classes throughwhich tests are made quite simpler and cleaner
  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;
  const Params({
    @required this.number,
  });

  @override
  List<Object> get props => [number];
}
