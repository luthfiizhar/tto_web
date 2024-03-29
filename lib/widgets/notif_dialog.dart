import 'package:flutter/material.dart';
import 'package:tto/constant/color.dart';
import 'package:tto/constant/text.dart';
import 'package:tto/widgets/button.dart';
import 'package:tto/widgets/white_button.dart';

class AlertDialogBlack extends StatelessWidget {
  AlertDialogBlack({
    required this.title,
    required this.contentText,
    this.color = greenAcent,
  });

  final String? title;
  final String? contentText;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: eerieBlack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 560,
          minWidth: 385,
          minHeight: 200,
          maxHeight: double.infinity,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          child: Stack(
            children: [
              Container(
                // color: Colors.amber,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Wrap(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title!,
                          style: titlePage.copyWith(
                            color: color,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          contentText!,
                          style: bodyText.copyWith(
                            color: culturedWhite,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     // SizedBox(),
                    //     TransparentButtonWhite(
                    //       text: 'Cancel',
                    //       onTap: () {},
                    //       padding: ButtonSize().smallSize(),
                    //     ),
                    //     const SizedBox(
                    //       width: 15,
                    //     ),
                    //     WhiteRegularButton(
                    //       text: 'Confirm',
                    //       onTap: () {},
                    //       padding: ButtonSize().smallSize(),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SizedBox(),
                    // TransparentButtonWhite(
                    //   text: 'Cancel',
                    //   onTap: () {
                    //     Navigator.of(context).pop(false);
                    //   },
                    //   padding: ButtonSize().mediumSize(),
                    // ),

                    WhiteRegularButton(
                      text: 'OK',
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                      padding: ButtonSize().mediumSize(),
                      disabled: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
