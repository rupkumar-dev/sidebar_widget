import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/navigation_item.dart';
import 'widget/config.dart';
import 'widget/sidebar_widget.dart';
import 'provider/sidebar_controller.dart';

/// A customizable sidebar widget that supports navigation items and nested routes.
/// Handles route matching, item expansion, and selection states.
class CustomSideBar extends StatelessWidget {
  /// List of items to display in the sidebar. Can contain both NavigationItem and Widget.
  final List<dynamic> items;

  /// Configuration for the sidebar appearance
  final SidebarConfig? sidebarConfig;

  /// Configuration for the sidebarItem appearance
  final ItemConfig? itemConfig;

  /// Callback function when a route is selected.
  final Function(String)? onRouteSelected;

  /// Current active route.
  final String? currentRoute;
  final bool onRoute;

  const CustomSideBar({
    super.key,
    required this.items,
    this.currentRoute,
    this.sidebarConfig,
    this.itemConfig,
    this.onRoute = false,
    this.onRouteSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SidebarController()..updateFromRoute(currentRoute, items),
      child: Consumer<SidebarController>(
        builder: (context, controller, _) {
          return Container(
            padding: sidebarConfig?.padding,
            color: sidebarConfig?.backgroundColor,
            width: sidebarConfig?.width,
            child: ListView.builder(
              cacheExtent: 300,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                if (item is Widget) return item;

                final navItem = item as NavigationItem;
                return SidebarWidget(
                  item: navItem,
                  index: index,
                  selectedColor: itemConfig?.selectedItemColor,
                  iconBagroundColor: itemConfig?.iconBagroundColor,
                  iconColor: itemConfig?.iconColor,
                  textColor: itemConfig?.textColor,
                  itemExpanded: controller.itemExpandedIndex == index,
                  isSelected: controller.selectedIndex == index,
                  selectedSubIndex: controller.selectedSubIndex,
                  itemOnTap: () => controller.handleMainItemTap(
                    navItem,
                    index,
                    onRouteSelected,
                    currentRoute,
                    onRoute,
                  ),
                  onSubItemTap: (subIndex) => controller.handleSubItemTap(
                    navItem,
                    index,
                    subIndex,
                    onRouteSelected,
                    currentRoute,
                    onRoute,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
