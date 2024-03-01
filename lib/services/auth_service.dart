
import '../networking/constant.dart';
import '../support/dio_helper.dart';

class AuthService {


  static Future Login(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/users/login',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future registration(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/users/add-user-by-refferal',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }



}
