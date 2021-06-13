import '../../../../core/error/failures.dart';
import '../../../../core/usecases/use_cases.dart';
import '../entities/number_trivia.dart';
import '../repository/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  NumberTriviaRepository repository;
  GetConcreteNumberTrivia(this.repository);

  // Becasue Dart support Callable classes throughwhich tests are made quite simpler and cleaner
  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  int number;
  Params({@required this.number}) : super([number]);
}
