import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Using equatable coz. Dart supports referantial equality, So objects with same data are responded as not equal
class NumberTrivia extends Equatable {
  final String text;
  final int number;

  const NumberTrivia({
    @required this.text,
    @required this.number,
  });

  // We wont be using try catch for exceptional handling, Instead we will try to return a failure object
  // Exceptions would be identified in the repositry of data layer ASAP and return types would be selected there
  // It is done with the help of functional programming
  // Dartz provide us with Future<Either>, which can return objects on same condition

  // super() is used for letting equatable know which data to consider while measuring equility

  @override
  List<Object> get props => [text, number];
}
