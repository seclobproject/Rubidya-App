
import '../networking/constant.dart';
import '../support/dio_helper.dart';

class ProfileService {


  static Future verificationimage(data) async {
    // print(username);
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/users/upload-image',data:data);
    return response;
  }


  static Future deductbalance(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURLwallet/basic/deductBalanceAuto',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future getProfileimage() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-media');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future getProfile() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/profile');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }



  // static Future verification(data) async {
  //   var dio = await DioHelper.getInstance();
  //   var response = await dio.post('$baseURLwallet/basic/checkPayIdExist',data:data);
  //   return response;
  // }


  static Future checkpayid(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/users/add-pay-id',data:data);
    return response;
  }

  static Future verifyuser(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/users/verify-user',data:data);
    return response;
  }


}
