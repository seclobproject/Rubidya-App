
import '../networking/constant.dart';
import '../support/dio_helper.dart';

class TrendingService {


  static Future tendingapi() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-pricemoney');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future tendingcard() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/this-day-all-users');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


}
