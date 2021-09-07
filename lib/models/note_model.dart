//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_notes/entities/entities.dart';

class Note extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String URL;
  final Color color;
  final DateTime timestamp;



  const Note({
    this.id,
    @required this.userId,
    @required this.color,
    @required this.title,
    @required this.content,
    @required this.URL,
    @required this.timestamp,
  });

  @override
  List<Object> get props => [id, userId, title, content,URL, color, timestamp];

  @override
  String toString() => '''Note {
    id: $id,
    userId: $userId,
    title: $title,
    content: $content,
    URL: $URL,
    color: $color,
    timestamp: $timestamp
  }''';

  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      userId: userId,
      title: title,
      content: content,
      URL: URL,
      color: '#${color.value.toRadixString(16)}',
      timestamp: Timestamp.fromDate(timestamp),
    );
  }

  factory Note.fromEntity(NoteEntity entity) {
    return Note(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      content: entity.content,
      URL: entity.URL,
      color: HexColor(entity.color),
      timestamp: entity.timestamp.toDate(),
    );
  }

  Note copy({
    String id,
    String userId,
    String title,
    String content,
    Color color,
    DateTime timestamp, String URL,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,

      URL: URL ?? this.URL,
      color: color ?? this.color,
      timestamp: timestamp ?? this.timestamp,
    );
  }


  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    if (id != null) {
      data['id'] = id;
    }
    data['title'] = title;
    data['content'] = content;
    data['color'] = color;
    return data;
  }


}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toLowerCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
