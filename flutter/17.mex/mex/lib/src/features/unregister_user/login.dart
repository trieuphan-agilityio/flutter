import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mex_bloc/mex_bloc.dart';

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Center(child: Text('This is Login page')),
            BlocListener<AuthBloc, AuthState>(
              listener: (BuildContext context, AuthState state) {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: BlocBuilder(
                bloc: LoginBloc.of(context),
                builder: (BuildContext context, LoginState state) {
                  return RaisedButton(
                    child: Text(state is LoginLoading
                        ? 'Wait a second...'
                        : 'Let\' me in'),
                    onPressed: () {
                      LoginBloc.of(context).add(
                        LoginButtonPressed(username: '', password: ''),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
