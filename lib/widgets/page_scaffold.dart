import 'package:flutter/material.dart';
import 'package:simple_task_mate/utils/icon_utils.dart';
import 'package:simple_task_mate/utils/page_navigation_utils.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({
    required this.child,
    this.header,
    this.selectedPageIndex = -1,
    super.key,
  });

  final Widget? header;
  final Widget child;
  final int selectedPageIndex;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final primaryInverseColor = Theme.of(context).colorScheme.inversePrimary;

    final header = this.header;

    var navigationRail = NavigationRail(
      unselectedIconTheme: Theme.of(context).iconTheme.copyWith(
            color: primaryInverseColor,
          ),
      unselectedLabelTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: primaryInverseColor,
            fontWeight: FontWeight.bold,
          ),
      backgroundColor: primaryColor,
      destinations: [
        NavigationRailDestination(
          icon: IconUtils.clock(
            context,
            color: selectedPageIndex != 0 ? primaryInverseColor : null,
          ),
          label: const Text('Stamp'),
        ),
        NavigationRailDestination(
          icon: IconUtils.clipboard(
            context,
            color: selectedPageIndex != 1 ? primaryInverseColor : null,
          ),
          label: const Text('Task'),
        ),
      ],
      selectedIndex: selectedPageIndex,
      onDestinationSelected: (value) {
        final target = switch (value) {
          0 => stampViewRoute,
          1 => taskViewRoute,
          _ => null,
        };

        if (target != null) {
          Navigator.of(context).pushAndRemoveUntil(target, (_) => false);
        }
      },
    );

    return Row(
      children: [
        Stack(
          children: [
            navigationRail,
            Container(
              margin: const EdgeInsets.all(17),
              alignment: Alignment.bottomCenter,
              child: IconButton(
                icon: IconUtils.gear(context, color: primaryInverseColor),
                onPressed: () {
                  Navigator.of(context).push(configViewRoute);
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (header != null) header,
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
