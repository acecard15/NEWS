import 'package:flutter/material.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/vendor/popular_services.vm.dart';
import 'package:fuodz/widgets/buttons/custom_outline_button.dart';
import 'package:fuodz/widgets/custom_masonry_grid_view.dart';
import 'package:fuodz/widgets/list_items/service.gridview_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class PopularServicesView extends StatefulWidget {
  const PopularServicesView(this.vendorType, {Key key}) : super(key: key);

  final VendorType vendorType;

  @override
  _PopularServicesViewState createState() => _PopularServicesViewState();
}

class _PopularServicesViewState extends State<PopularServicesView> {
  bool showGrid = true;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PopularServicesViewModel>.reactive(
      viewModelBuilder: () => PopularServicesViewModel(
        context,
        widget.vendorType,
      ),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return VStack(
          [
            //
            ("Popular".tr() + " ${widget.vendorType.name}")
                .text
                .lg
                .medium
                .make()
                .px12(),


            CustomMasonryGridView(
              isLoading: vm.isBusy,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              items: vm.services.map((service) {
                return ServiceGridViewItem(
                  service: service,
                  onPressed: vm.serviceSelected,
                );
              }).toList(),
            ).p12(),

            //view more
            CustomOutlineButton(
              height: 24,
              child: "View More"
                  .tr()
                  .text
                  .medium
                  .sm
                  .color(Utils.textColorByTheme())
                  .makeCentered(),
              onPressed: vm.openSearch,
            ).px20(),
          ],
        ).py12();
      },
    );
  }
}
