import 'package:flutter/material.dart';
import 'package:thankyoulist/app_colors.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  DefaultAppBar({
    required this.title,
    this.leading,
    this.actions
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(
          title,
          style: TextStyle(
              color: AppColors.textColor,
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: AppColors.appBarBottomBorderColor)),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColors.textColor),
        leading: leading,
        actions: actions
    );
  }
}