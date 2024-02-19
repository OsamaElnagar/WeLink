import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:we_link/shared/bloc/AppCubit/cubit.dart';
import 'package:we_link/shared/components/components.dart';
import 'package:we_link/shared/styles/colors.dart';
import 'package:we_link/shared/styles/fonts.dart';

import '../../shared/bloc/AppCubit/states.dart';
import '../../shared/components/build_onBoarding_item.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';
import '../auth/login_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with SingleTickerProviderStateMixin {
  PageController pageController = PageController();

  void submit(context) {
    CacheHelper.putData('lastPage', lastPage!).then((value) {
      if (value) {
        navigate2(
          context,
          const LoginScreen(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            actions: [
              // if(lastPage != true)
              // Padding(
              //   padding: const EdgeInsets.all(2.0),
              //   child: ElevatedButton(
              //     onPressed: () {
              //       submit(context);
              //     },
              //
              //     child: Text(
              //       'Skip'.toUpperCase(),
              //       style: WeLinkTextStyles.weLinkHintMontserrat(color: WeLinkColors.myColor),
              //     ),
              //   ),
              // ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index) {
                    if (index == cubit.boarding.length - 1) {
                      setState(() {
                        lastPage = true;
                      });
                    } else {
                      setState(() {
                        lastPage = false;
                      });
                    }
                  },
                  itemBuilder: (context, index) =>
                      OnBoardingBuilder(boardingModel: cubit.boarding[index]),
                  controller: pageController,
                  itemCount: cubit.boarding.length,
                ),
              ),
            ],
          ),
          bottomNavigationBar: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 5.0),
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: cubit.boarding.length,
                    effect: const ExpandingDotsEffect(
                      dotWidth: 16.0,
                      dotHeight: 16.0,
                      dotColor: Colors.grey,
                      activeDotColor: WeLinkColors.myColor,
                      radius: 16.0,
                      spacing: 6,
                      expansionFactor: 4.0,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: lastPage != true
                        ? FloatingActionButton(
                            onPressed: () {
                              if (lastPage == true) {
                                submit(context);
                              } else {
                                pageController.nextPage(
                                  duration: const Duration(milliseconds: 700),
                                  curve: Curves.easeOut,
                                );
                              }
                            },
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                          )
                        : ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  WeLinkColors.myColor,
                                ),
                                shape: MaterialStateProperty.all(
                                  ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                )),
                            onPressed: () {
                              submit(context);
                            },
                            child: const Text(
                              'Let\'s get started.',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
