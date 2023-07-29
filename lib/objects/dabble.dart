import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dabble {
  late final DocumentReference reference;
  late final String title;
  late final int duration;
  late final Timestamp createdAt;

  Dabble({
    required this.reference,
    required this.title,
    required this.duration,
    required this.createdAt,
  });

  double get progress {
    return min(
      1,
      DateTime.now()
              .difference(
                DateTime.fromMillisecondsSinceEpoch(
                  createdAt.millisecondsSinceEpoch,
                ),
              )
              .inMilliseconds
              .toDouble() /
          duration /
          1000,
    );
  }

  String get progressString {
    return '${(progress * 100).toStringAsFixed(0)}%';
  }

  Color get color {
    if (progress == 1) {
      return Colors.green;
    } else if (progress > 0.75) {
      return Colors.orange;
    } else if (progress > 0.5) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }

  Dabble.fromMap(this.reference, Map<String, dynamic> map) {
    title = map['title'] as String? ?? '';
    duration = map['duration'] as int? ?? 0;
    createdAt = map['createdAt'] as Timestamp? ?? Timestamp.now();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'duration': duration,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'Dabble{title: $title, duration: $duration, createdAt: $createdAt}';
  }
}
