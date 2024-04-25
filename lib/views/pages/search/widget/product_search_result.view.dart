import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/main_search.vm.dart';
import 'package:fuodz/widgets/custom_grid_view.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/dynamic_product.list_item.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductSearchResultView extends StatefulWidget {
  ProductSearchResultView(this.vm, {Key key}) : super(key: key);

  final MainSearchViewModel vm;
  @override
  State<ProductSearchResultView> createState() =>
      _ProductSearchResultViewState();
}

class _ProductSearchResultViewState extends State<ProductSearchResultView> {
  @override
  Widget build(BuildContext context) {
    final refreshController = widget.vm.refreshControllers[1];
    //
    return (widget.vm.search.layoutType == null ||
            widget.vm.search.layoutType == "grid")
        ? CustomGridView(
            refreshController: refreshController,
            canPullUp: true,
            canRefresh: true,
            onRefresh: widget.vm.searchProducts,
            onLoading: () => widget.vm.searchProducts(initial: false),
            dataSet: widget.vm.products,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            isLoading: widget.vm.busy(widget.vm.products),
            childAspectRatio: (context.screenWidth / 2.5) / 100,
            separatorBuilder: (p0, p1) => UiSpacer.vSpace(0),
            itemBuilder: (ctx, index) {
              final product = widget.vm.products[index];
              return DynamicProductListItem(
                product,
                onPressed: widget.vm.productSelected,
                h: 100,
              );
            },
          )
        : CustomListView(
            refreshController: refreshController,
            canPullUp: true,
            canRefresh: true,
            onRefresh: widget.vm.searchProducts,
            onLoading: () => widget.vm.searchProducts(initial: false),
            dataSet: widget.vm.products,
            isLoading: widget.vm.busy(widget.vm.products),
            itemBuilder: (ctx, index) {
              final product = widget.vm.products[index];
              return DynamicProductListItem(
                product,
                onPressed: widget.vm.productSelected,
              );
            },
            separatorBuilder: (p0, p1) => UiSpacer.vSpace(0),
          );
  }
}
