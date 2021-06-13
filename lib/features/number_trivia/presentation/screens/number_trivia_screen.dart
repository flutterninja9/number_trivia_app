import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/widgets/loading-widget.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/widgets/message-displayed.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/widgets/trivia-diplayed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Number Trivia"),
      ),
      body: _buildBody(context),
    );
  }
}

Widget _buildBody(BuildContext context) {
  String inpStr;
  return Container(
    padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
    child: Column(
      children: [
        SizedBox(
          height: 10,
        ),
        BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
          builder: (context, state) {
            print(state);
            if (state is Loading) {
              return LoadingWidget();
            } else if (state is Loaded) {
              return TriviaDisplayed(
                numberTrivia: state.trivia,
              );
            } else if (state is Error) {
              return MessageDisplayed(
                messageDisplayed: state.message,
              );
            } else {
              return MessageDisplayed(
                messageDisplayed: "Start searching!",
              );
            }
          },
        ),
        SizedBox(
          height: 20,
        ),
        Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Enter a number', border: OutlineInputBorder()),
              onChanged: (inpVal) {
                inpStr = inpVal;
              },
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      dispatchConcrete(context, inpStr);
                    },
                    color: Theme.of(context).accentColor,
                    textTheme: ButtonTextTheme.primary,
                    child: Text(
                      "Search",
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      dispatchRandom(context);
                    },
                    child: Text(
                      "Get random trivia",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

void dispatchConcrete(BuildContext context, String inpString) {
  BlocProvider.of<NumberTriviaBloc>(context)
      .dispatch(GetTriviaForConcreteNumber(inpString));
}

void dispatchRandom(BuildContext context) {
  BlocProvider.of<NumberTriviaBloc>(context)
      .dispatch(GetTriviaForRandomNumber());
}
