
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

  // static Future tendingcard() async {
  //   try {
  //     var dio = await DioHelper.getInstance();
  //     var response = await dio.get('$baseURL/api/posts/this-day-all-users');
  //     return response.data;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }


  // static Future TrendingtopSix(status) async {
  //   var queryParameters = {
  //     'type': status
  //   };
  //   var dio = await DioHelper.getInstance();
  //   var response = await dio.get('$baseURL/api/posts/top-six',queryParameters:queryParameters);
  //   return response.data;
  // }


  static Future TrendingtopSix(String status) async {
    try {
      var queryParameters = {
        'type': status
      };
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/top-six', queryParameters: queryParameters);
      return response.data;
    } catch (e) {
      print('Error occurred: $e');
      // Handle the error appropriately here
      throw e; // Or handle it in another way
    }
  }


  static Future tendingcard({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get(
        '$baseURL/api/posts/this-day-all-users',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }



  static Future trendingapiThisweek() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/this-week-all-users');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future trendingapiThismonth() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/this-month-all-users');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future trendingapiThisday() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/this-day-all-users');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future trendingapiThisall() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/posts/this-day-all-users');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }



// static Future trendingapiThisweek(String status) async {
//   try {
//     var queryParameters = {

//     };
//     var dio = await DioHelper.getInstance();
//     var response = await dio.get('$baseURL/api/posts/top-six', queryParameters: queryParameters);
//     return response.data;
//   } catch (e) {
//     print('Error occurred: $e');
//     // Handle the error appropriately here
//     throw e; // Or handle it in another way
//   }
// }


}