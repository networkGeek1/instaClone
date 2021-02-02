import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instaClone/models/messages.dart';
import 'package:instaClone/widgets/post.dart';

class PostTileOnlyImage extends StatelessWidget {
  final PostTile post;

  PostTileOnlyImage(this.post);

  showPost(context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => PostScreen(
    //       postId: post.postId,
    //       userId: post.ownerId,
    //     ),
    //   ),
    // );
    print("Nice");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPost(context),
      child: CachedNetworkImage(imageUrl: post.url),
    );
  }
}
