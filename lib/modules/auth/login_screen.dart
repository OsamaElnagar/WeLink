import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_link/modules/auth/register_screen.dart';
import 'package:we_link/modules/auth/rset_password.dart';
import 'package:we_link/shared/bloc/AppCubit/cubit.dart';
import 'package:we_link/shared/bloc/loginCubit/states.dart';
import 'package:we_link/shared/components/components.dart';
import 'package:we_link/shared/network/local/cache_helper.dart';

import '../../homeLayout/home_layout.dart';
import '../../shared/bloc/loginCubit/cubit.dart';
import '../../shared/components/auth_items/auth_banner.dart';
import '../../shared/components/auth_items/auth_bottom_bar.dart';
import '../../shared/components/constants.dart';
import '../../shared/styles/backgrounds.dart';
import '../../shared/styles/form_fields.dart';
import '../../shared/styles/strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    FocusNode emailNode = FocusNode();
    FocusNode passwordNode = FocusNode();
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => LoginCubit(LoginInitialState()),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            CacheHelper.saveLoginData(key: 'uid', value: state.uId);
            uId = state.uId;
            AppCubit.get(context).getUserData();
            navigate2(context, const HomeLayout());
            showToast(msg: 'login successfully', state: ToastStates.success);
          }
          if (state is LoginErrorState) {
            showToast(msg: 'Wrong email or password', state: ToastStates.error);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: GestureDetector(
                onTap: () => unFocusNodes([emailNode, passwordNode]),
                child: Stack(
                  children: [
                    Backgrounds.authBackground(),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Form(
                          key: formKey,
                          child: FadeInDown(
                            animate: true,
                            duration: const Duration(seconds: 1),
                            child: Column(
                              children: [

                                const WeLinkAuthBanner(
                                  headline: WeLinkLoginStrings.loginHeadline,
                                  tour: WeLinkLoginStrings.loginYourAccount,
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
                                        WeLinkPassFormField(
                                          label: 'Password field',
                                          hintText: 'password',
                                          focusNode: passwordNode,
                                          controller: passwordController,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return ' Password must not be empty';
                                            }
                                            return null;
                                          },
                                          textInputAction: TextInputAction.go,
                                          loginCubit: LoginCubit.get(context),
                                          onChanged: (s) {
                                            if (LoginCubit.get(context).isShown ==
                                                false) {
                                              LoginCubit.get(context)
                                                  .changePasswordVisibility();
                                            }
                                          },
                                          onFieldSubmitted: (value) {
                                            if (formKey.currentState!
                                                .validate()) {
                                              FocusScope.of(context).unfocus();
                                            }
                                          },
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            navigateTo(context,
                                                const ResetPasswordScreen());
                                          },
                                          child: const Text(
                                            'forgot password?',
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        const WeLinkSpacer(),
                                        ConditionalBuilder(
                                          condition: state is! LoginLoadingState,
                                          fallback: (context) => Stack(
                                            children: [
                                              Center(
                                                child: gradientButton(
                                                  title: 'LOGIN',
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
                                            title: 'LOGIN',
                                            context: context,
                                            onPressed: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                LoginCubit.get(context).userLogin(
                                                  email: emailController.text
                                                      .replaceAll(' ', '')
                                                      .toString(),
                                                  password:
                                                      passwordController.text,
                                                );
                                              }
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
                                  question: WeLinkLoginStrings.donHaveAccount,
                                  decision: WeLinkLoginStrings.signup,
                                  onPressed: () =>
                                      navigate2(context, RegisterScreen()),
                                ),
                              ],
                            ),
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
