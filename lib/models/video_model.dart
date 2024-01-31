import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class VideoModel {
  final String username;
  final String uid;
  final String id;
  final List likes;
  final int commentCount;
  final int shareCount;
  // final String songName;
  final String songCaption;
  final String videoUrl;
  final String thumbnail;
  final String profilePhoto;
  VideoModel({
    required this.username,
    required this.uid,
    required this.id,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    // required this.songName,
    required this.songCaption,
    required this.videoUrl,
    required this.thumbnail,
    required this.profilePhoto,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'uid': uid,
      'id': id,
      'likes': likes,
      'commentCount': commentCount,
      'shareCount': shareCount,
      // 'songName': songName,
      'songCaption': songCaption,
      'videoUrl': videoUrl,
      'thumbnail': thumbnail,
      'profilePhoto': profilePhoto,
    };
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      username: map['username'] as String? ?? '',
      uid: map['uid'] as String? ?? '',
      id: map['id'] as String? ?? '',
      likes: List.from(map['likes'] as List? ?? []),
      commentCount: map['commentCount'] as int? ?? 0,
      shareCount: map['shareCount'] as int? ?? 0,
      // songName: map['songName'] as String? ?? '',
      songCaption: map['songCaption'] as String? ?? '',
      videoUrl: map['videoUrl'] as String? ?? '',
      thumbnail: map['thumbnail'] as String? ?? '',
      profilePhoto: map['profilePhoto'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoModel.fromJson(String source) =>
      VideoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
