import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_link/modules/search_user_screen.dart';
import 'package:we_link/shared/bloc/AppCubit/cubit.dart';
import 'package:we_link/shared/components/animated_f_a_b.dart';
import 'package:we_link/shared/components/components.dart';
import 'package:we_link/shared/styles/colors.dart';
import '../shared/bloc/AppCubit/states.dart';
import '../shared/styles/icons_broken.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({
    Key? key,
    this.initIndex = 0,
  }) : super(key: key);

  final int initIndex;

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout>
    with SingleTickerProviderStateMixin {
  //late TabController controller;
  late Animation<double> animation;

  late TabController _tabController;
  late ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
    _scrollController = ScrollController();
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return DefaultTabController(
          length: 5,
          initialIndex: 0,
          child: Scaffold(
            body: SafeArea(
              child: NestedScrollView(
                controller: _scrollController,
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text(
                                'Hello ${cubit.loginModel?.name}',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 45,
                              child: InkWell(
                                onTap: () => navigateTo(
                                    context, const UserSearchScreen()),
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: SearchBar(
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.white,
                                    ),
                                    leading: const Icon(
                                      Icons.search,
                                      color: WeLinkColors.myColor,
                                    ),
                                    hintText: 'Search',
                                    hintStyle: MaterialStateProperty.all(
                                      const TextStyle(
                                        color: WeLinkColors.myColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    expandedHeight: 60,
                    collapsedHeight: 60,
                    floating: true,
                    bottom: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.transparent,
                      dividerHeight: 0,
                      unselectedLabelStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                      ),
                      onTap: (index) {
                        cubit.changeIndex(index);
                        if (index == 0) {
                          scrollToTop();
                        }
                      },
                      physics: const BouncingScrollPhysics(),
                      tabs: const [
                        Tab(
                          icon: Icon(IconBroken.Home),
                          text: 'Feeds',
                        ),
                        Tab(
                          icon: Icon(IconBroken.Chat),
                          text: 'Chats',
                        ),
                        Tab(
                          icon: Icon(IconBroken.Profile),
                          text: 'Profile',
                        ),
                        Tab(
                          icon: Icon(IconBroken.Notification),
                          text: 'Notifications',
                        ),
                        Tab(
                          icon: Icon(IconBroken.Setting),
                          text: 'Settings',
                        ),
                      ],
                      isScrollable: false,
                    ),
                  ),
                ],
                body: Stack(
                  children: [
                    TabBarView(
                      controller: _tabController,
                      children: cubit.screens,
                    ),
                    if (cubit.currentIndex == 0) const AnimatedFeedsFAB(),
                    if (cubit.currentIndex == 1) const AnimatedChatsFAB(),
                    if (cubit.currentIndex == 2) const AnimatedProfileFAB(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
