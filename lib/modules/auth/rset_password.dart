import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_link/modules/auth/login_screen.dart';
import 'package:we_link/shared/bloc/loginCubit/states.dart';
import 'package:we_link/shared/components/components.dart';

import '../../shared/bloc/loginCubit/cubit.dart';
import '../../shared/components/auth_items/auth_banner.dart';
import '../../shared/components/auth_items/auth_bottom_bar.dart';
import '../../shared/styles/backgrounds.dart';
import '../../shared/styles/form_fields.dart';
import '../../shared/styles/strings.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    FocusNode emailNode = FocusNode();
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => LoginCubit(LoginInitialState()),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: GestureDetector(
                onTap: () => unFocusNodes([emailNode]),
                child: Stack(
                  children: [
                    Backgrounds.authBackground(),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              const WeLinkAuthBanner(
                                headline: WeLinkResetPasswordStrings
                                    .resetPasswordHeadline,
                                tour: WeLinkResetPasswordStrings.donWorry,
                              ),
                              const WeLinkSpacer(),
                              AuthDecoratedContainer(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      const WeLinkSpacer(),
                                      WeLinkTextFormField(
                                        label: 'Email field',
                                        hintText: 'email',
                                        focusNode: emailNode,
                                        controller: emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return ' Email must not be empty';
                                          }
                                          return null;
                                        },
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const WeLinkSpacer(),
                                      ConditionalBuilder(
                                        condition: state
                                            is! LoginResetPasswordLoadingState,
                                        fallback: (context) => Stack(
                                          children: [
                                            Center(
                                              child: gradientButton(
                                                title: 'RESET',
                                                context: context,
                                              ),
                                            ),
                                            Center(
                                              child: CircularProgressIndicator(
                                                backgroundColor: Colors.black
                                                    .withOpacity(.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                        builder: (context) => gradientButton(
                                          title: 'RESET',
                                          context: context,
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              LoginCubit.get(context)
                                                  .resetPassword(
                                                      context: context,
                                                      email: emailController
                                                          .text
                                                          .replaceAll(' ', '')
                                                          .toString());
                                            }
                                            FocusScope.of(context).unfocus();
                                          },
                                        ),
                                      ),
                                      const WeLinkSpacer(),
                                    ],
                                  ),
                                ),
                              ),
                              const WeLinkSpacer(),
                              AuthBottomBar(
                                question: WeLinkResetPasswordStrings.goLogin,
                                decision: WeLinkLoginStrings.login,
                                onPressed: () =>
                                    navigate2(context, const LoginScreen()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
