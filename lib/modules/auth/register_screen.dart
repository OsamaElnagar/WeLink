import 'package:animate_do/animate_do.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_link/modules/auth/login_screen.dart';
import 'package:we_link/shared/bloc/register_cubit/cubit.dart';
import 'package:we_link/shared/bloc/register_cubit/states.dart';
import 'package:we_link/shared/components/components.dart';

import '../../shared/components/auth_items/auth_banner.dart';
import '../../shared/components/auth_items/auth_bottom_bar.dart';
import '../../shared/styles/backgrounds.dart';
import '../../shared/styles/form_fields.dart';
import '../../shared/styles/strings.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode nameNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(RegisterInitState()),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterCreateUserSuccessState) {
            navigate2(context, const LoginScreen());
            showToast(msg: 'Joined successfully', state: ToastStates.success);
          }
          if (state is RegisterCreateUserErrorState) {
            showToast(msg: 'Invalid data', state: ToastStates.error);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: GestureDetector(
                onTap: () => unFocusNodes(
                    [emailNode, passwordNode, phoneNode, nameNode]),
                child: Stack(
                  children: [
                    Backgrounds.authBackground(),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Form(
                          key: formKey,
                          child: FadeInDown(
                            child: Column(
                              children: [
                                const WeLinkAuthBanner(
                                  headline:
                                      WeLinkRegisterStrings.registerHeadline,
                                  tour: WeLinkRegisterStrings.registerYourAccount,
                                ),
                                const WeLinkSpacer(),
                                AuthDecoratedContainer(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        const WeLinkSpacer(),
                                        WeLinkTextFormField(
                                          label: 'Name field',
                                          hintText: 'name',
                                          focusNode: nameNode,
                                          controller: nameController,
                                          keyboardType: TextInputType.name,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return ' name must not be empty';
                                            }
                                            return null;
                                          },
                                          textInputAction: TextInputAction.next,
                                        ),
                                        const WeLinkSpacer(),
                                        WeLinkTextFormField(
                                          label: 'Phone field',
                                          hintText: 'phone',
                                          focusNode: phoneNode,
                                          controller: phoneController,
                                          keyboardType: TextInputType.phone,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return ' phone must not be empty';
                                            }
                                            return null;
                                          },
                                          textInputAction: TextInputAction.next,
                                        ),
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
                                          registerCubit:
                                              RegisterCubit.get(context),
                                          onChanged: (s) {
                                            if (RegisterCubit.get(context)
                                                    .isShown ==
                                                false) {
                                              RegisterCubit.get(context)
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
                                        const WeLinkSpacer(),
                                        ConditionalBuilder(
                                          condition: state
                                              is! RegisterCreateUserLoadingState,
                                          fallback: (context) => Stack(
                                            children: [
                                              Center(
                                                child: gradientButton(
                                                  title:
                                                    'Register'.toUpperCase(),

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
                                            title:
                                              'REGISTER',

                                            context: context,
                                            onPressed: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                RegisterCubit.get(context)
                                                    .userRegister(
                                                  name: nameController.text
                                                      .replaceAll(' ', ''),
                                                  phone: phoneController.text,
                                                  email: emailController.text,
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
                                  question: WeLinkRegisterStrings.haveAccount,
                                  decision: WeLinkRegisterStrings.login,
                                  onPressed: () =>
                                      navigate2(context, const LoginScreen()),
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
