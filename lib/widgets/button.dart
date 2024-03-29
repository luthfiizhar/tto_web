import 'package:flutter/material.dart';
import 'package:tto/constant/color.dart';

class RegularButton extends StatelessWidget {
  RegularButton({
    required this.text,
    this.fontSize,
    this.onTap,
    required this.disabled,
    this.padding,
    this.fontWeight = FontWeight.w700,
    this.radius = 7.5,
  });

  final String? text;
  final double? fontSize;
  final VoidCallback? onTap;
  bool? disabled = false;
  final EdgeInsetsGeometry? padding;
  FontWeight fontWeight;
  double radius;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed
    };
    if (states.any(interactiveStates.contains)) {
      return eerieBlack;
    }
    return culturedWhite;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disabled! ? null : onTap,
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        foregroundColor: MaterialStateProperty.resolveWith(getColor),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          return disabled! ? grayx11 : eerieBlack;
        }),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
                side: BorderSide(color: eerieBlack, width: 1),
              );
            }
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            );
          },
        ),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) return culturedWhite;
            if (states.contains(MaterialState.hovered)) return davysGray;
            return null;
          },
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (states) {
            return TextStyle(
              fontSize: 16,
              fontWeight: fontWeight,
              fontFamily: 'Helvetica',
              height: 1.15,
            );
          },
        ),
        padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>(
          (states) {
            return padding;
          },
        ),
      ),
      child: Text(text!),
    );
  }
}

class ButtonSize {
  EdgeInsetsGeometry longSize() {
    return const EdgeInsets.symmetric(horizontal: 100, vertical: 20);
  }

  EdgeInsetsGeometry mediumSize() {
    return const EdgeInsets.symmetric(horizontal: 50, vertical: 20);
  }

  EdgeInsetsGeometry smallSize() {
    return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
  }

  EdgeInsetsGeometry loginButotn() {
    return const EdgeInsets.symmetric(horizontal: 32, vertical: 17);
  }

  EdgeInsetsGeometry itemQtyButton() {
    return const EdgeInsets.symmetric(horizontal: 5, vertical: 5);
  }
}
