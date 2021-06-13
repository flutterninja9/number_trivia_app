import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/use_cases.dart';
import '../entities/number_trivia.dart';
import '../repository/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  NumberTriviaRepository numberTriviaRepository;
  GetRandomNumberTrivia(this.numberTriviaRepository);
  @override
  Future<Either<Failure, NumberTrivia>> call(params) async {
    return await numberTriviaRepository.getRandomNumberTrivia();
  }
}
