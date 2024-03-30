
import '../networking/constant.dart';
import '../support/dio_helper.dart';

class UploadService {


  static Future uploadimage(data) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post('$baseURL/api/users/upload-image',data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }




}
