
import '../networking/constant.dart';
import '../support/dio_helper.dart';

class HomeService {


  // static Future refferalhistory() async {
  //   try {
  //     var dio = await DioHelper.getInstance();
  //     var response = await dio.get('$baseURL/api/users/get-direct-refferals');
  //     return response.data;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //

  static Future<Map<String, dynamic>> getDirectReferrals({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-direct-refferals?page=$page&limit=$limit');
      return response.data;
    } catch (e) {
      // Handle error appropriately, e.g., log the error or throw it further
      throw e;
    }
  }





  static Future usersuggetionlistfollow() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-suggestions');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future follow(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/users/follow',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future unfollow(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/users/unfollow',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future followingList() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-following');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future followersList() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-followers');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future getFeed() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/get-latest-posts');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future like(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/posts/like',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }



}
