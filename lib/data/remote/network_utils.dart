import 'dart:convert' show Encoding, json;

import 'package:http/http.dart' as http;
import 'package:cross_platform/data/exception/remote_data_source_exception.dart';

class NetworkUtils {
  static Future get(
    Uri url, {
    Map<String, String> headers,
  }) async {
    final response = await http.get(url, headers: headers);
    final body = response.body;
    final statusCode = response.statusCode;
    if (body == null) {
      throw RemoteDataSourceException(statusCode, 'Response body is null');
    }
    final decoded = json.decode(body);
    if (statusCode < 200 || statusCode >= 300) {
      throw RemoteDataSourceException(statusCode, decoded['message']);
    }
    return decoded;
  }

  static Future post(
    Uri url, {
    Map<String, String> headers,
    Map<String, String> body,
    Encoding encoding,
  }) =>
      _helper(
        'POST',
        url,
        headers: headers,
        body: body,
        encoding: encoding,
      );

  static Future _helper(
    String method,
    Uri url, {
    Map<String, String> headers,
    Map<String, String> body,
    Encoding encoding,
  }) async {
    final request = http.Request(method, url);
    if (body != null) {
      request.body = json.encode(body);
    }
    if (headers != null) {
      request.headers.addAll(headers);
    }
    if (encoding != null) {
      request.encoding = encoding;
    }
    final streamedResponse = await request.send();

    final statusCode = streamedResponse.statusCode;
    final decoded = json.decode(await streamedResponse.stream.bytesToString());

    if (statusCode < 200 || statusCode >= 300) {
      throw RemoteDataSourceException(statusCode, decoded['message']);
    }

    return decoded;
  }

  static Future put(
    Uri url, {
    Map<String, String> headers,
    body,
    Encoding encoding,
  }) =>
      _helper(
        'PUT',
        url,
        headers: headers,
        body: body,
        encoding: encoding,
      );
}
