
import '../networking/constant.dart';
import '../support/dio_helper.dart';

class WalletService {


  static Future marketvalue() async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get('$baseURLwallet/api/endPoint1/RBD_INR');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }


  static Future walletbalance(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURLwallet/api/endPoint1/RBD_INR',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }






}
