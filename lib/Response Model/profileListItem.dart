import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:home_hub/utils/extension.dart';
import 'package:sizer/sizer.dart';

class ProfileListItem extends StatelessWidget {
  final String name;
  final String icon;
  final VoidCallback onPressed;
  final Color? color;
  final Color? iconColors;
  const ProfileListItem({
    this.iconColors,
    this.color,
    required this.name,
    required this.icon,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: 5.h,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: 30,
              color: iconColors,
            ),
            2.w.addWSpace(),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: color ?? Colors.black),
              ),
            ),
            IconButton(
              onPressed: onPressed,
              icon: Icon(Icons.navigate_next),
            )
          ],
        ),
      ),
    );
  }
}
