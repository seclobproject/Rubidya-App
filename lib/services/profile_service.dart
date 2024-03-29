
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


  static Future fetchbalance(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURLwallet/basic/creditBalanceAuto',data: data);
      return response;
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

  static Future syncwallet() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/sync-wallet');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future getpackage() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURL/api/users/get-packages');
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
    return response.data;
  }

  static Future verifyuser(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/users/verify-user',data:data);
    return response.data;
  }

  static Future deductrubideum(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/users/deduct-rubideum',data:data);
    return response.data;
  }


  static Future onvertinr(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/users/convert-inr',data:data);
    return response.data;
  }

  static Future verifyaccountrubidia(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURLwallet/basic/checkPayIdExist',data:data);
    return response.data;
  }



  static Future premiuminner(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/users/get-package-by-id',data:data);
    return response.data;
  }

  static Future profilestatus() async {
    var dio = await DioHelper.getInstance();
    var response = await dio.get('$baseURL/api/users/get-stats');
    return response.data;
  }



  static Future ProfileEditing(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.put('$baseURL/api/users/edit-profile',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future ProfileImageUpload(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/users/add-profile-pic',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


}
