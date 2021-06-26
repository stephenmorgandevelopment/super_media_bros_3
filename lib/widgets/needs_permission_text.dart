import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NeedsPermissionText extends StatelessWidget {
  static final String NEEDS_PERMISSION = 'needs_permission';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'This is a media app dumbass...\nWTF you expect it to do without access to media?!??!??!',
        style: TextStyle(
          color: Colors.greenAccent[700],
          fontSize: 24.0,
        ),
      ),
    );
  }
}