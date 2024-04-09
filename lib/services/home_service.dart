
import '../networking/constant.dart';
import '../support/dio_helper.dart';

class HomeService {


  static Future refferalhistory() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-direct-refferals');
      return response.data;
    } catch (e) {
      rethrow;
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
      var response = await dio.get('$baseURL/api/users/get-following');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }



}
