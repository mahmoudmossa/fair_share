// TODO: Implement the widget for Occupants feature.
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';

class OccupantsWidget extends StatelessWidget {
  const OccupantsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(LocaleKeys.occupants_widget.tr()),
    );
  }
}