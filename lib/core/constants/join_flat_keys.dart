import 'package:flutter/material.dart';

class JoinFlatKeys {
  const JoinFlatKeys();
  final joinFlatView = const ValueKey('join_flat_view');
  final joinFlatButton = const Key('joinFlatButton');
  final goToJoinFlatButton = const Key('goToJoinFlatButton');
  Key pinDigitField(int index) => Key('pinDigitField$index');
}
