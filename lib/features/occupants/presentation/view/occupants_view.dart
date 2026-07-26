// TODO: Implement the View for Occupants feature.
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';

class OccupantsView extends StatelessWidget {
  const OccupantsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.occupants_title.tr()),
      ),
      body: Center(
        child: Text(LocaleKeys.occupants_subtitle.tr()),
      ),
    );
  }
}