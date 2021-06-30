import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/components/components.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';

class SocialLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('News feed'),
          ),
          body: ConditionalBuilder(
            condition: SocialCubit.get(context).model != null,
            builder: (context) {
              var model = SocialCubit.get(context).model;

              return Column(
                children: [
                  if (!FirebaseAuth.instance.currentUser.emailVerified)
                    Container(
                      color: Colors.amber.withOpacity(0.6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Icon(Icons.info_outlined),
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                'Please verify your email',
                              ),
                            ),
                            SizedBox(width: 15),
                            defaultTextButton(
                              text: 'SEND',
                              function: () {
                                FirebaseAuth.instance.currentUser
                                    .sendEmailVerification()
                                    .then((value) {
                                  showToast(
                                    text: 'Check your main',
                                    state: ToastStates.SUCCESS,
                                  );
                                }).catchError((error) {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
            fallback: (context) {
              return Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }
}
