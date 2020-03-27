import 'package:flutter/material.dart';
import 'package:skype_clone/utils/universal_vars.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTile;
  const CustomAppBar({
    Key key,
    this.title,
    this.actions,
    this.leading,
    this.centerTile,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: UniversalVariables.blackColor,
        border: Border(
          bottom: BorderSide(
            color: UniversalVariables.separatorColor,
            width: 1.4,
            style: BorderStyle.solid
          )
        )
      ),
      child: AppBar(
        backgroundColor: UniversalVariables.blackColor,
        elevation: 0.0,
        title: title,
        leading: leading,
        actions: actions,
        centerTitle: centerTile,


      ),
    );
  }

 final Size  preferredSize= const Size.fromHeight(kToolbarHeight + 10);
}