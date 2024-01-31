import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/comment_controller/comment_contoller.dart';
import 'package:tiktok_clone/utils/colors.dart';
import 'package:tiktok_clone/utils/global_var.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentView extends StatelessWidget {
  final String id;
  CommentView({super.key, required this.id});

  final CommentController _controller = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    _controller.updatePostId(id);
    log(id);
    log(_controller.comments.length.toString());
    return Scaffold(
      bottomSheet: Container(
        color: Utils.backgroundColor,
        child: ListTile(
          title: TextFormField(
            controller: _controller.commentController,
            decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              hintText: 'comment',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          trailing: TextButton(
            onPressed: () {
              _controller
                  .postComment(
                _controller.commentController.text.trim(),
              )
                  .then((value) {
                _controller.commentController.clear();
              });
            },
            child: const Text(
              'Send',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Utils.backgroundColor,
        leading: const BackButton(),
      ),
      body: Obx(() {
        return _controller.comments.isEmpty
            ? const Center(
                child: Text('No Comments'),
              )
            : ListView.builder(
                itemCount: _controller.comments.length,
                itemBuilder: (_, index) {
                  var comments = _controller.comments[index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(comments.profilePhoto),
                    ),
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: comments.username,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: comments.comment,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          tago.format(comments.datePublished.toDate()),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${comments.likes.length} likes',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    trailing: InkWell(
                      onTap: () {
                        log(id);
                        _controller.likeComment(comments.id);
                      },
                      child: Icon(
                        comments.likes.contains(authController.user.uid)
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        size: 25,
                        color: comments.likes.contains(authController.user.uid)
                            ? Colors.red
                            : Colors.white,
                      ),
                    ),
                  );
                },
              );
      }),
    );
  }
}
