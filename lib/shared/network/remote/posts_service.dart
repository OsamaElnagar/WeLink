import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/post_model.dart';

class PostService {
  static final CollectionReference _postsCollection =
      FirebaseFirestore.instance.collection('posts');

  static DocumentSnapshot? lastVisiblePost;

  static Stream<List<PostModel>> getPostsStream({int limit = 5}) {
    Query query =
        _postsCollection.orderBy('postDate', descending: true).limit(limit);

    if (lastVisiblePost != null) {
      query = query.startAfterDocument(lastVisiblePost!);
    }

    return query.snapshots().map((snapshot) {
      List<PostModel> posts = [];
      if (snapshot.docs.isNotEmpty) {
        lastVisiblePost = snapshot.docs.last;
        for (DocumentSnapshot doc in snapshot.docs) {
          posts.add(PostModel.fromJson(doc.data() as Map<String, dynamic>));
        }
      }

      return posts;
    });
  }
}
