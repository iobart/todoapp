import 'package:flutter/material.dart';

const double marginLeadingAppBar = 20.0;

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final double? elevation;
  final bool? showGradient;
  final Widget? widgetTitle;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle;
  final Widget? leading;

  const CustomAppBar({
    Key? key,
    this.title,
    this.bottom,
    this.widgetTitle,
    this.centerTitle,
    this.elevation = 0,
    this.actions = const [],
    this.showGradient = true,
    this.backgroundColor = Colors.transparent,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: showGradient!
            ? LinearGradient(
                begin: const Alignment(3, 0.0),
                end: Alignment.centerLeft,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              )
            : null,
      ),
      child: AppBar(
        title: widgetTitle ?? _title(),
        leading: leading,
        bottom: bottom,
        actions: actions,
        centerTitle: centerTitle,
        elevation: elevation,
        backgroundColor: backgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }

  Widget _title() => Text(
    title ?? '',
    style: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  );
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
