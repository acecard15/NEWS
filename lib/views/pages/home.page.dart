import 'dart:io';

import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_upgrade_settings.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/views/pages/profile/profile.page.dart';
import 'package:fuodz/view_models/home.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:upgrader/upgrader.dart';
import 'package:velocity_x/velocity_x.dart';

import 'order/orders.page.dart';
import 'search/main_search.page.dart';
import 'welcome/widgets/cart.fab.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeViewModel vm;
  @override
  void initState() {
    super.initState();
    vm = HomeViewModel(context);
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        LocationService.prepareLocationListener();
        vm?.initialise();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBack(
      message: "Press back again to close".tr(),
      child: ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => vm,
        builder: (context, model, child) {
          return BasePage(
            body: UpgradeAlert(
              upgrader: Upgrader(
                showIgnore: !AppUpgradeSettings.forceUpgrade(),
                shouldPopScope: () => !AppUpgradeSettings.forceUpgrade(),
                dialogStyle: Platform.isIOS
                    ? UpgradeDialogStyle.cupertino
                    : UpgradeDialogStyle.material,
              ),
              child: PageView(
                controller: model.pageViewController,
                onPageChanged: model.onPageChanged,
                children: [
                  model.homeView,
                  OrdersPage(),
                  MainSearchPage(),
                  ProfilePage(),
                ],
              ),
            ),
            fab: CartHomeFab(model),
            bottomNavigationBar: VxBox(
              child: SafeArea(
                child: GNav(
                  gap: 8,
                  activeColor: Colors.white,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  duration: Duration(milliseconds: 250),
                  tabBackgroundColor: Theme.of(context).colorScheme.secondary,
                  tabs: [
                    GButton(
                      icon: FlutterIcons.home_ant,
                      text: 'Home'.tr(),
                    ),
                    GButton(
                      icon: FlutterIcons.inbox_ant,
                      text: 'Orders'.tr(),
                    ),
                    GButton(
                      icon: FlutterIcons.search_fea,
                      text: 'Search'.tr(),
                    ),
                    GButton(
                      icon: FlutterIcons.menu_fea,
                      text: 'More'.tr(),
                    ),
                  ],
                  selectedIndex: model.currentIndex,
                  onTabChange: model.onTabChange,
                ),
              ),
            )
                .p16
                .shadow
                .color(Theme.of(context).bottomSheetTheme.backgroundColor)
                .make(),
          );
        },
      ),
    );
  }
}
