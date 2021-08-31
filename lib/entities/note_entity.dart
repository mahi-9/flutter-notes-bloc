import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class NoteEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String color;
  final Timestamp timestamp;

  const NoteEntity({
    this.id,
    @required this.userId,
    @required this.title,
    @required this.content,
    @required this.color,
    @required this.timestamp,
  });

  @override
  List<Object> get props => [id, userId, title, content, color, timestamp];

  @override
  String toString() => '''NoteEntity {
    id: $id,
    userId: $userId,
    title: $title,
    content: $content,
    color: $color,
    timestamp: $timestamp,  
  }''';

  Map<String, dynamic> toDocument() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
      'color': color,
      'timestamp': timestamp,
    };
  }

  factory NoteEntity.fromSnapshot(DocumentSnapshot doc) {
    return NoteEntity(
      id: doc.documentID,
      userId: doc.data['userId'] ?? '',
      title: doc.data['title'] ?? '',
      content: doc.data['content'] ?? '',
      color: doc.data['color'] ?? '#FFFFFF',
      timestamp: doc.data['timestamp'],
    );
  }
}
