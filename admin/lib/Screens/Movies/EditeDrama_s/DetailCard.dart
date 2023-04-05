// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:weena/Constant/constant.dart';
// import 'package:weena/Models/Post.dart';
// import 'package:flutter/material.dart';

// import 'package:google_fonts/google_fonts.dart';

// class DetailCard extends StatefulWidget {
//   final PostModel postModel;
//   final String currentUserId;
//   final String postID;

//   const DetailCard(
//       {Key? key,
//       required this.postModel,
//       required this.currentUserId,
//       required this.postID})
//       : super(key: key);
//   @override
//   State<DetailCard> createState() => _DetailCardState();
// }

// class _DetailCardState extends State<DetailCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//           // ignore: prefer_const_literals_to_create_immutables
//           boxShadow: [
//             const BoxShadow(
//               color: Color.fromARGB(255, 59, 58, 58),
//               spreadRadius: 0.5,
//               blurRadius: 4,
//               offset: Offset(0, 0.9),
//             ),
//           ],
//           image: DecorationImage(
//               image: CachedNetworkImageProvider(
//                 widget.postModel.thumbnail,
//               ),
//               fit: BoxFit.cover),
//           color: appcolor.withOpacity(0.9),
//           borderRadius: BorderRadius.circular(9)),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Container(
//               padding: const EdgeInsets.only(left: 8, top: 3, bottom: 2),
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       bottomRight: Radius.circular(9),
//                       bottomLeft: Radius.circular(9)),
//                   color: appcolor),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Episode ${widget.postModel.episode.toString()}",
//                     style: GoogleFonts.roboto(
//                         color: Colors.white, fontWeight: FontWeight.w600),
//                   ),
//                   IconButton(
//                       onPressed: () {
//                         deleteDrama(widget.postModel);
//                       },
//                       icon: const Icon(
//                         Icons.close,
//                         color: Colors.red,
//                       ))
//                 ],
//               )),
//         ],
//       ),
//     );
//   }

//   deleteDrama(PostModel postModel) async {
//     await postsRef
//         .doc(widget.currentUserId)
//         .collection("userPosts")
//         .doc(widget.postID)
//         .collection('otherSeries')
//         .doc(postModel.postuid)
//         .delete()
//         .whenComplete(() => print(widget.postModel.postuid));
//   }
// }
