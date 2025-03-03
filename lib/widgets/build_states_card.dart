 import 'package:flutter/material.dart';

Widget buildStatsCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    String? actionText,
  }) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom:8.0),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white38,
                  child: Icon(icon, color: color, size: 60),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left:50),
                child: Text(
                  value,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                ),
              ),
              
              if (actionText != null) ...[
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {},
                  child: Text(actionText, style: TextStyle(color: Colors.blue)),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
