import '../networking/constant.dart';
import '../support/dio_helper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService {
  static final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('wss://rubidya.com'), // Update with your WebSocket URL
  );

  static Future<Map<String, dynamic>> getChatHistory(
      {int page = 1, int limit = 15}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get(
          '$baseURL/api/message/get-all-conversation?page=$page&limit=$limit');
      return response.data;
    } catch (e) {
      print('Error fetching chat history: $e');
      throw e;
    }
  }

  static Future<String> getConversionId({int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get(
          '$baseURL/api/message/get-all-conversation?page=$page&limit=$limit');
      return response.data["conversationId"];
    } catch (e) {
      print('Error fetching conversation ID: $e');
      throw e;
    }
  }

  static Future<Map<String, dynamic>> getMessages(String conversationId,
      {int page = 1, int limit = 10}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response =
      await dio.get('$baseURL/api/message/get-messages', queryParameters: {
        'limit': limit,
        'page': page
      }, data: {
        'conversationId': conversationId,
      });
      return response.data;
    } catch (e) {
      print('Error fetching messages: $e');
      throw e;
    }
  }

  static Future<Map<String, dynamic>> sendMessage(
      String senderId, String message, String userId) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.post(
        '$baseURL/api/message/send-messages',
        data: {
          "senderId": senderId,
          "message": message,
          "recieverId": userId,
        },
      );
      return response.data;
    } catch (e) {
      print('Error sending message: $e');
      throw e;
    }
  }

  static void listenForMessages(Function onMessageReceived) {
    _channel.stream.listen((message) {
      onMessageReceived(message);
    }, onError: (error) {
      print('WebSocket error: $error');
    });
  }

  static void sendMessageViaWebSocket(String senderId, String message, String userId) {
    _channel.sink.add({
      "senderId": senderId,
      "message": message,
      "recieverId": userId,
    });
  }

  static void dispose() {
    _channel.sink.close();
  }
}
