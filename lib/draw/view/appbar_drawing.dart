import 'package:flutter/material.dart';

class AppBarDrawing extends StatelessWidget {
  final Widget saveFileDialog;

  const AppBarDrawing({super.key, required this.saveFileDialog});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 500,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Image.asset(
              'assets/icons/logo-01.png',
              width: 32,
              height: 32,
            ),
            onPressed: () {
              print('Search pressed');
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/icons/folder-01.png',
              width: 32,
              height: 32,
            ),
            onPressed: () {
              print('HERES Search pressed');
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/icons/download-01.png',
              width: 32,
              height: 32,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => saveFileDialog,
              );
            },
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Image.asset(
            'assets/icons/m-icon-01.png',
            width: 32,
            height: 32,
          ),
          onPressed: () {
            // Action when search icon is pressed
            print('Search pressed');
          },
        ),
        Tooltip(
          triggerMode: TooltipTriggerMode.tap,
          verticalOffset: 48,
          height: 24,
          message:
              "Process and Wellness Drawing was conceived by Eric A. Chan and has been created for you.\n\n“Process Drawing”, “Wellness Drawing”, “Process and Wellness Drawing”, and “MontageAcetates” are copyright © Eric A. Chan. All rights reserved.",
          child: IconButton(
              icon: Image.asset(
                'assets/icons/info-01.png',
                width: 32,
                height: 32,
              ),
              onPressed: null),
        ),
      ],
    );
  }
}
