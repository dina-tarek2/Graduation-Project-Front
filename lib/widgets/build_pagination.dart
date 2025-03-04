 import 'package:flutter/material.dart';

Widget buildPagination(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
            },
            child: Text('Previous'),
          ),
          TextButton(
            onPressed: () {
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
