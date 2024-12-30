import 'dart:convert';
import 'dart:developer';

import "package:http/http.dart" as http;
import 'package:logger/logger.dart';


String token =
    'tobeupdated';

class ApiHelper {
  //

  var logger = Logger(); //for debug

/*  getToken() async {
    //TODO Here we take token from share pre
  token = await appPreference.getToken();
    logger.log(Level.info, token);
  }*/

  Future<http.Response?> post({
    required String api,
    required Map<String, dynamic> body,
    required Function({required http.Response response}) onSuccess,
    required Function({required String message}) onFailure,
  }) async {
    // bool isInternetAvalble = await internetController.checkInternetConnection();
    //
    // if (!isInternetAvalble) {
    //   onFailure(message: 'Please check your internet connection');
    //   return null;
    // }
    logger.d("$api \n request ${jsonEncode(body)}");
   // await getToken();

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final res = await http
        .post(
      Uri.parse(api),
      headers: headers,
      body: jsonEncode(body),
    )
        .catchError((e) {
      logger.e('Api calling error');
      onFailure(message: e.message);
    });
    log(res.body);
    String status = checkStatus(res: res);
    if (status == 'success') {
      onSuccess(response: res);
      return res;
    } else {
      onFailure(message: status);
      return null;
    }
  }

  Future<dynamic> postMultipart({
    required String api,
    required Map<String, String> body,
    required List<http.MultipartFile> imageList, //this use for nat get proper time we remove latter
    required Function({required dynamic response}) onSuccess,
    required Function({required String message}) onFailure,
  }) async {
    // String path = image.path;
    logger.d("This is api  $api \n request ${jsonEncode(body)},\n Image Paths ");
  //  await getToken();
    Map<String, String> headers = {
      'Accept': '*/*',
      'Content-Type': 'multipart/form-data',

    };

    var request = http.MultipartRequest('POST', Uri.parse(api));
    request.fields.addAll(body);
    request.headers.addAll(headers);
    request.files.addAll(imageList);

    http.StreamedResponse response = await request.send();

    print(response.statusCode);

    final respStr = await response.stream.bytesToString();

    //String status = posImageErrorHandle(res: response, respStr: respStr);
    print(response.statusCode);
   // print(status);


    if (response.statusCode == 200) {
      onSuccess(response: respStr);
      return respStr;
    } else {
      onFailure(message: 'Sometingwent wrong');
      return '';
    }
  }

  Future<http.Response?> get({
    required String api,
    Map<String, dynamic>? body,
    required Function({required http.Response response}) onSuccess,
    required Function({required String message}) onFailure,
  }) async {
    logger.d("token \n $token ");

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    Uri url;
    if (body != null) {
      url = Uri.parse(api).replace(queryParameters: body);
    } else {
      url = Uri.parse(api);
    }
    logger.d("API Name  $url \n request ");

    final res = await http
        .get(
      url,
      headers: headers,
    )
        .catchError((e) {
      logger.e(e);

      log(e.toString());
    });
    String status = checkStatus(res: res);
    if (status == 'success') {
      onSuccess(response: res);
      return res;
    } else {
      logger.e(res.body);
      onFailure(message: status);
      return null;
    }
  }

  Future<http.Response?> put({
    required String api,
    required Map<String, dynamic> body,
    required Function({required http.Response response}) onSuccess,
    required Function({required String message}) onFailure,
  }) async {
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final res = await http
        .put(
      Uri.parse(api),
      body: jsonEncode(body),
      headers: headers,
    )
        .catchError((e) {
      log(e.toString());
    });
    String status = checkStatus(res: res);
    if (status == 'success') {
      onSuccess(response: res);
      return res;
    } else {
      onFailure(message: status);
      return null;
    }
  }

  Future<http.Response?> delete({
    required String api,
    required Map<String, dynamic> body,
    required Function({required http.Response response}) onSuccess,
    required Function({required String message}) onFailure,
  }) async {
    var headers = {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'};
    logger.d('this delete api \n $api');
    final res = await http
        .delete(
      Uri.parse(api),
      body: jsonEncode(body),
      headers: headers,
    )
        .catchError((e) {
      log(e.toString());
    });
    String status = checkStatus(res: res);
    if (status == 'success') {
      onSuccess(response: res);
      return res;
    } else {
      onFailure(message: status);
      return null;
    }
  }

  ///Add salon
  Future<dynamic> addSalonPostApi({
    required String api,
    required Map<String, String> body,
    required List<http.MultipartFile> imageList, //this use for nat get proper time we remove latter
    required Function({required dynamic response}) onSuccess,
    required Function({required String message}) onFailure,
  }) async {
    // String path = image.path;
    logger.d("This is api  $api \n request ${jsonEncode(body)},\n Image Paths ${imageList.length}");

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest('POST', Uri.parse(api));
    request.fields.addAll(body);
    request.files.add(imageList[0]);
    request.files.add(imageList[1]);
    request.files.add(imageList[2]);
    request.files.add(imageList[3]);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    final respStr = await response.stream.bytesToString();

    String status = posImageErrorHandle(res: response, respStr: respStr);
    if (status == 'success') {
      onSuccess(response: response);
      return respStr;
    } else {
      onFailure(message: status);
      return '';
    }
  }

  ///Error handler
  static String checkStatus({required http.Response res}) {
    String status = '';

    switch (res.statusCode) {
      case 200:
        status = 'success';

        break;
      case 401:
        // authController.logOut();

        /// here we logout user
        break;
      case 400:
        status = jsonDecode(res.body)['message'];

        break;
      case 409:
        status = jsonDecode(res.body)['message'];
        break;

      case 422:
        status = jsonDecode(res.body)['message'];

        break;
      case 500:
        status = 'Internal server error';

        break;

      default:
        status = 'other error ${res.statusCode}';
    }
    return status;
  }

  ///Error image handle
  static String posImageErrorHandle({required http.StreamedResponse res, required String respStr}) {
    String status = '';
    Map<String, dynamic> obj = jsonDecode(respStr);

    switch (res.statusCode) {
      case 200:
        status = 'success';

        break;
      case 401:
        // authController.logOut();

        /// here we logout user
        break;
      case 400:
        status = obj['message'];
        break;
      case 409:
        status = obj['message'];
        break;

      case 422:
        status = obj['message'];

        break;
      case 500:
        status = 'Internal server error';

        break;

      default:
        status = 'other error ${res.statusCode}';
    }
    return status;
  }
}
