import 'package:drawing_app/constants/assets.dart';
import 'package:el_tooltip/el_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drawing_app/l10n/app_localizations.dart';

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
                  Assets.logoIcon,
                  width: 32,
                  height: 32,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset(
                  Assets.folderIcon,
                  width: 32,
                  height: 32,
                ),
                onPressed: () {},
              ),
              IconButton(
                  icon: Image.asset(
                    Assets.downloadIcon,
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
                Assets.mIcon,
                width: 32,
                height: 32,
              ),
              onPressed: () {},
            ),
            ElTooltip(
              showModal: false,
              distance: 10,
              position: ElTooltipPosition.bottomEnd,
              color: const Color.fromARGB(255, 136, 132, 132),
              content: SizedBox(
                width: 500,
                height: 400,
                child: Scrollbar(
                  radius: const Radius.circular(
                    4,
                  ),
                  thumbVisibility: true,
                  thickness: 4,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(
                      12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.processDrawing ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          AppLocalizations.of(context)
                                  ?.processDrawingWasConceived ??
                              '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${AppLocalizations.of(context)?.processDrawingAndMontage ?? ''}\n${AppLocalizations.of(context)?.allRightsReserved ?? ''}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          AppLocalizations.of(context)?.ericChanisAnAmerican ??
                              '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text.rich(
                          TextSpan(
                            text:
                                AppLocalizations.of(context)?.workingGlobally ??
                                    '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)?.war,
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)
                                    ?.americanSoldiers,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)?.revolution,
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)
                                    ?.studentsAndCitizen,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)
                                    ?.humanTrafficking,
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)
                                    ?.statelessChildren,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)?.democracy,
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)?.citizens,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              TextSpan(
                                text:
                                    AppLocalizations.of(context)?.climateChange,
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)
                                    ?.climatScientist,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              TextSpan(
                                text:
                                    AppLocalizations.of(context)?.firstNations,
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)?.hoChunk,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)?.refugees,
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)?.asylum,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)?.andWar,
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)?.amongOthers,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          AppLocalizations.of(context)?.ericChanReceived ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              child: IconButton(
                icon: Image.asset(
                  Assets.infoIcon,
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
