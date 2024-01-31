import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CommentModel {
  final String username;
  final String comment;
  // ignore: prefer_typing_uninitialized_variables
  final datePublished;
  final List likes;
  final String profilePhoto;
  final String uid;
  final String id;

  CommentModel({
    required this.username,
    required this.comment,
    required this.datePublished,
    required this.likes,
    required this.profilePhoto,
    required this.uid,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'comment': comment,
      'datePublished': datePublished,
      'likes': likes,
      'profilePhoto': profilePhoto,
      'uid': uid,
      'id': id,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      username: map['username'],
      comment: map['comment'],
      datePublished: map['datePublished'],
      likes: List.from((map['likes'])),
      profilePhoto: map['profilePhoto'],
      uid: map['uid'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) => CommentModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
