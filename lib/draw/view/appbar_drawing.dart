import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';

class AppBarDrawing extends StatelessWidget {
  final Widget saveFileDialog;

  const AppBarDrawing({
    super.key,
    required this.saveFileDialog,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawBloc, DrawState>(
      builder: (context, state) {
        final isEnabled = state.drawingFlipped;

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
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset(
                  'assets/icons/folder-01.png',
                  width: 32,
                  height: 32,
                ),
                onPressed: () {},
              ),
              IconButton(
                  icon: Image.asset(
                    'assets/icons/download-01.png',
                    width: 32,
                    height: 32,
                    color: isEnabled ? Colors.white : Colors.grey,
                  ),
                  onPressed: isEnabled
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) => saveFileDialog,
                          );
                        }
                      : null),
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
            ElTooltip(
              // triggerMode: TooltipTriggerMode.tap,
              // verticalOffset: 48,
              // height: 24,
              // message:
              //     "Process and Wellness Drawing was conceived by Eric A. Chan and has been created for you.\n\n“Process Drawing”, “Wellness Drawing”, “Process and Wellness Drawing”, and “MontageAcetates” are copyright © Eric A. Chan. All rights reserved.",
              showModal: false,
              distance: 10,
              position: ElTooltipPosition.bottomEnd,
              color: const Color.fromARGB(255, 136, 132, 132),
              content: const Text(
                'Process and Wellness Drawing was conceived by Eric A. Chan and has been created for you. “Process Drawing”, “Wellness Drawing”, “Process and Wellness Drawing”, and “MontageAcetates” are copyright © Eric A. Chan. All rights reserved.',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              child: IconButton(
                icon: Image.asset(
                  'assets/icons/info-01.png',
                  width: 32,
                  height: 32,
                ),
                onPressed: null,
              ),
            ),
          ],
        );
      },
    );
  }
}
