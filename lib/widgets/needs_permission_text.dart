import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NeedsPermissionText extends StatelessWidget {
  static const String NEEDS_PERMISSION = 'needs_permission';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Text(
          'The primary function of this app is to display your media and play it all in one place\n' +
              'Without access to media on your device or in the cloud, this app is effectively useless.',
          style: TextStyle(
            color: Colors.greenAccent[700],
            fontSize: 24.0,
          ),
        ),
      ),
    );
  }
}
