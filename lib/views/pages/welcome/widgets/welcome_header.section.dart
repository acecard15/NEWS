import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/services/alert.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/welcome.vm.dart';
import 'package:fuodz/views/pages/notification/notifications.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class WelcomeHeaderSection extends StatelessWidget {
  const WelcomeHeaderSection(
    this.vm, {
    Key key,
  }) : super(key: key);

  final WelcomeViewModel vm;
  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        HStack(
          [
            Icon(
              FlutterIcons.location_pin_ent,
              size: 24,
            ),
            UiSpacer.hSpace(5),
            VStack(
              [
                "Deliver To".tr().text.thin.light.sm.make(),
                StreamBuilder(
                  stream: LocationService.currenctAddressSubject,
                  builder: (conxt, snapshot) {
                    return (snapshot.hasData
                            ? "${snapshot.data?.addressLine}"
                            : "Current Location".tr())
                        .text
                        .lg
                        .semiBold
                        .maxLines(1)
                        .ellipsis
                        .make();
                  },
                ).flexible(),
              ],
            ).flexible(),
            UiSpacer.hSpace(5),
            Icon(
              FlutterIcons.chevron_down_ent,
              size: 20,
            ),
          ],
        ).onTap(
          () async {
            await onLocationSelectorPressed();
          },
        ).expand(),
        UiSpacer.hSpace(),
        Icon(
          FlutterIcons.bell_fea,
          size: 20,
        ).onInkTap(
          () {
            context.nextPage(NotificationsPage());
          },
        ),
      ],
    )
        .px20()
        .py16()
        .safeArea()
        .box
        .color(context.theme.colorScheme.background)
        .bottomRounded(value: 0)
        .shadowSm
        .make()
        .pOnly(bottom: 5)
        .box
        .color(context.theme.colorScheme.background)
        .make();
  }

  Future<void> onLocationSelectorPressed() async {
    try {
      vm.pickDeliveryAddress(onselected: () {
        vm.pageKey = GlobalKey<State>();
        vm.notifyListeners();
      });
    } catch (error) {
      AlertService.stopLoading();
    }
  }
}
