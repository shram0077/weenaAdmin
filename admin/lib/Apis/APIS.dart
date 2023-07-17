import 'package:admin/Constant/constant.dart';
import 'package:admin/Models/Post.dart';

class Api {
  static bool? isMovieExists;
  static Future<void> getMovieInfo(String movieId) async {
    await plus18Ref.doc(movieId).get().then((movie) async {
      if (movie.exists) {
        isMovieExists = true;
      } else {
        isMovieExists = false;
      }
    });
  }
}
