import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/CommentModel.dart';
import 'package:admin/Models/Post.dart';
import 'package:admin/Models/SeriesModel.dart';
import 'package:admin/Models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DatabaseServices {
  // Search posts
  static Future<QuerySnapshot> searchPosts(
    String title,
  ) async {
    Future<QuerySnapshot> posts = newMoviesRef
        .where('title', isGreaterThanOrEqualTo: title)
        .where('title', isLessThan: title + 'z')
        .get();

    return posts;
  }

  // Search For Users
  static Future<QuerySnapshot> searchUsers(
    String username,
  ) async {
    Future<QuerySnapshot> users = usersRef
        .where('username', isGreaterThanOrEqualTo: username)
        .where('username', isLessThan: username + 'z')
        .get();

    return users;
  }

// Get Users Count
  static Future<int> getUsersCount() async {
    QuerySnapshot usersSnap = await usersRef.get();
    return usersSnap.docs.length;
  }

// Get Most Papular Movies
  static Future<int> getPapulareMovies() async {
    QuerySnapshot moviesSnap = await usersRef.get();
    return moviesSnap.docs.length;
  }

  // Check UserId
  static Future<String> checkUserId(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> userSnap =
        await usersRef.doc(userId).get();
    print("This UserId: ${userSnap.id}");
    return userSnap.id;
  }

// Followers Number
  static Future<int> followersNumber(String userId) async {
    QuerySnapshot followersSnapshot =
        await followersRef.doc(userId).collection('Followers').get();
    return followersSnapshot.docs.length;
  }

  // Following Number
  static Future<int> followingNumber(String userId) async {
    QuerySnapshot followingSnapshot =
        await followingRef.doc(userId).collection('Following').get();
    return followingSnapshot.docs.length;
  }

  // Get Comments
  static Future<List<CommentModel>> getComments(PostModel postModel) async {
    QuerySnapshot commentsSnap = await commentsRef
        .doc(postModel.postuid)
        .collection('Comments')
        .orderBy('rating', descending: true)
        .get();
    List<CommentModel> userComment =
        commentsSnap.docs.map((doc) => CommentModel.fromDoc(doc)).toList();

    return userComment;
  }

// Get User Posts
  static Future<List<PostModel>> getUserPosts(String userId) async {
    QuerySnapshot userPostsSnap = await postsRef
        .doc(userId)
        .collection('userPosts')
        .orderBy('Timestamp', descending: true)
        .get();
    List<PostModel> userPosts =
        userPostsSnap.docs.map((doc) => PostModel.fromDoc(doc)).toList();

    return userPosts;
  }

  // Get Reccomended Post
  static Future<List<PostModel>> getRecommendedPost() async {
    QuerySnapshot userPostsSnap =
        await recommendedRef.orderBy("Timestamp", descending: false).get();
    List<PostModel> userPosts =
        userPostsSnap.docs.map((doc) => PostModel.fromDoc(doc)).toList();

    return userPosts;
  }

// Get Admin Count
  static Future<List<UserModell>> getAdmin() async {
    QuerySnapshot adminSnap =
        await usersRef.where('admin', isEqualTo: true).get();
    List<UserModell> userAdmin =
        adminSnap.docs.map((doc) => UserModell.fromDoc(doc)).toList();
    print(userAdmin.where((element) => element.admin));
    return userAdmin;
  }

  static Future<List<UserModell>> getCreatorsCount() async {
    QuerySnapshot adminSnap =
        await usersRef.where('isVerified', isEqualTo: true).get();
    List<UserModell> userAdmin =
        adminSnap.docs.map((doc) => UserModell.fromDoc(doc)).toList();
    print(userAdmin.where((element) => element.admin));
    return userAdmin;
  }
  // Get New Movies

  static Future<List<PostModel>> getNewMovies() async {
    QuerySnapshot userPostsSnap = await newMoviesRef.get();
    List<PostModel> userPosts =
        userPostsSnap.docs.map((doc) => PostModel.fromDoc(doc)).toList();

    return userPosts;
  }
  // Get Explorer Post

  static Future<List<PostModel>> getExplorerPost() async {
    QuerySnapshot exploerePostSnap =
        await explorersRef.orderBy("Timestamp", descending: false).get();
    List<PostModel> userPosts =
        exploerePostSnap.docs.map((doc) => PostModel.fromDoc(doc)).toList();

    return userPosts;
  }

  // Get Views
  static Future<int> getViews(PostModel postModel) async {
    QuerySnapshot viewsSnapshot =
        await viewsRef.doc(postModel.postuid).collection('Views').get();
    return viewsSnapshot.docs.length;
  }

  // Get Other Episodes
  static Future<List<PostModel>> getOtherepisode(PostModel postModel) async {
    QuerySnapshot userPostsSnap = await postsRef
        .doc(postModel.userId)
        .collection('userPosts')
        .doc(postModel.postuid)
        .collection('otherEpisodes')
        .orderBy("episode", descending: false)
        .get();
    List<PostModel> userPosts =
        userPostsSnap.docs.map((doc) => PostModel.fromDoc(doc)).toList();

    return userPosts;
  }

// get likes
  static Future<int> getPostLikes(postId) async {
    QuerySnapshot likesSnapshot =
        await likesRef.doc(postId).collection('Likes').get();
    return likesSnapshot.docs.length;
  }

  // Get Comments Count
  static Future<int> getCommentsCount(PostModel postModel) async {
    QuerySnapshot commentsSnapshot =
        await commentsRef.doc(postModel.postuid).collection('Comments').get();
    return commentsSnapshot.docs.length;
  }

// Get Series
  static Future<List<SeriesModel>> getSeries(
    PostModel postModel,
  ) async {
    QuerySnapshot userPostsSnap = await postsRef
        .doc(postModel.userId)
        .collection('userPosts')
        .doc(postModel.postuid)
        .collection('Series')
        .orderBy("episode", descending: false)
        .get();
    List<SeriesModel> userPosts =
        userPostsSnap.docs.map((doc) => SeriesModel.fromDoc(doc)).toList();

    return userPosts;
  }

  // Get Other Series
  static Future<List<PostModel>> getOtherEpisodes(PostModel postModel) async {
    QuerySnapshot userPostsSnap = await postsRef
        .doc(postModel.userId)
        .collection('userPosts')
        .doc(postModel.postuid)
        .collection('otherEpisode')
        .orderBy("episode", descending: false)
        .get();
    List<PostModel> userPosts =
        userPostsSnap.docs.map((doc) => PostModel.fromDoc(doc)).toList();

    return userPosts;
  }

  static void removeEveryWhere(PostModel postModel) async {
    final videoStorage = storageRef
        .child("video's/${postModel.title}, ${postModel.postuid}.mp4");
    final thumbnailStorage = storageRef
        .child("thumbnail's/${postModel.title}, ${postModel.postuid}.jpg");
    await postsRef
        .doc(postModel.userId)
        .collection('userPosts')
        .doc(postModel.id)
        .delete()
        .whenComplete(() => Fluttertoast.showToast(
            timeInSecForIosWeb: 5, msg: "Succsfully deleted in profile"));
    QuerySnapshot followerSnapshot =
        await followersRef.doc(postModel.userId).collection('Followers').get();
    for (var docSnapshot in followerSnapshot.docs) {
      followingPostsRef
          .doc(docSnapshot.id)
          .collection('posts')
          .doc(postModel.id)
          .delete()
          .whenComplete(() => Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: 'succsufully deleted in Timeline Followers'));
      await newMoviesRef.doc(postModel.id).delete();
      await recommendedRef.doc(postModel.id).delete().whenComplete(() =>
          Fluttertoast.showToast(
              timeInSecForIosWeb: 5,
              msg: 'succsufully deleted in recommended '));
      likesRef.doc(postModel.postuid).delete();
      videoStorage.delete();
      thumbnailStorage.delete();
    }
  }

  static void uploadToProfile(
      String userid,
      String uuid,
      String description,
      String videoLink,
      String title,
      String type,
      String thumbnailLink,
      int episode,
      int series,
      List tags,
      String trailer,
      double imdbRating) async {
    await postsRef.doc(userid).collection('userPosts').doc(uuid).set({
      "description": description,
      "video": videoLink,
      "Timestamp": Timestamp.now(),
      "postuid": uuid,
      "title": title,
      "type": type,
      "userId": userid,
      "verified": false,
      'thumbnail': thumbnailLink,
      "episode": episode,
      'series': series,
      "tags": tags,
      "trailer": trailer,
      "imdbRating": imdbRating
    }).whenComplete(() => Fluttertoast.showToast(
        timeInSecForIosWeb: 6, msg: "Succsfully upload to profile"));
  }

  static void uploadToNewMovies(
      String userid,
      String uuid,
      String description,
      String videoLink,
      String title,
      String type,
      String thumbnailLink,
      int episode,
      int series,
      List tags,
      String trailer,
      double imdbRating) {
    newMoviesRef.doc(uuid).set({
      "description": description,
      "video": videoLink,
      "Timestamp": Timestamp.now(),
      "postuid": uuid,
      "title": title,
      "type": type,
      "userId": userid,
      "verified": false,
      'thumbnail': thumbnailLink,
      "episode": episode,
      'series': series,
      "tags": tags,
      "trailer": trailer,
      "imdbRating": imdbRating
    }).whenComplete(() => Fluttertoast.showToast(
        timeInSecForIosWeb: 6,
        msg: 'succsufully upload to new Movie collection'));
  }

  static void uploadToFollowersTimeline(
    String userid,
    String uuid,
    String description,
    String videoLink,
    String title,
    String type,
    String thumbnailLink,
    int episode,
    int series,
    List tags,
    String trailer,
    double imdbRating,
  ) async {
    QuerySnapshot followerSnapshot =
        await followersRef.doc(userid).collection('Followers').get();

    for (var docSnapshot in followerSnapshot.docs) {
      followingPostsRef.doc(docSnapshot.id).collection('posts').doc(uuid).set({
        "description": description,
        "video": videoLink,
        "Timestamp": Timestamp.now(),
        "postuid": uuid,
        "title": title,
        "type": type,
        "userId": userid,
        "verified": false,
        'thumbnail': thumbnailLink,
        "episode": episode,
        'series': series,
        "tags": tags,
        "trailer": trailer,
        "imdbRating": imdbRating
      }).whenComplete(() => Fluttertoast.showToast(
          timeInSecForIosWeb: 6, msg: 'succsufully upload to Timeline'));
    }
  }
}
