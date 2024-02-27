
import '../networking/constant.dart';
import '../support/dio_helper.dart';

class ProfileService {


  static Future verificationimage(data) async {
    // print(username);
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/users/upload-image',data:data);
    return response;
  }

  static Future verification(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURLwallet/basic/checkPayIdExist',data:data);
    return response;
  }


  static Future checkpayid(data) async {
    var dio = await DioHelper.getInstance();
    var response = await dio.post('$baseURL/api/users/add-pay-id',data:data);
    return response;
  }


}
