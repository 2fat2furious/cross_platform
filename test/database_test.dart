import 'dart:convert';

import 'package:cross_platform/data/remote/api_service.dart';
import 'package:cross_platform/data/remote/response/token_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cross_platform/data/remote/network_utils.dart';


void main() {
  ApiService apiService;

  group('db test', () {
    setUp(() async {
      apiService = ApiService();
    });

    test('testLogin', () async {
      final url = Uri.http('192.168.100.107', '/users/login');
      final body = <String, String>{
        'login': 'testUserZ',
        'password': '111',
      };
      var decoded;
      try {
        decoded = await NetworkUtils.post(url,
            body: body,
            headers: {'Content-Type': 'application/json'},
            encoding: Encoding.getByName('utf-8'));
      } catch (Exeption) {
        decoded = null;
      }
      expect(decoded, isNotNull);
    });
    test('testRegister', () async {
      final url = Uri.http('192.168.100.107', '/users');
      final body = <String, String>{
        'login': 'newUser197',
        'password': '111',
      };
      var decoded;
      try {
        decoded = decoded = await NetworkUtils.post(url, body: body, headers: {'Content-Type': 'application/json'},encoding: Encoding.getByName('utf-8'));
      } catch (Exeption) {
        decoded = null;
      }
      expect(decoded, isNotNull);
    });
    test('testGet', () async {
      final url = Uri.http('192.168.100.107', '/users/testUserZ');
      var json;
      try {
        json = await NetworkUtils.get(url, headers: {'x-access-token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJiOTA3ODM3Yy1lNjY3LTQwYTgtODA3Yi1iZTY1Mzg5M2EzOGIiLCJpYXQiOjE2MDgyMTc3NTcsImV4cCI6MTYwODgyMjU1N30.pq0sGWmvbSzT28fHBnNILsE1qyHxybkiZmH02h22A-8'});
      } catch (Exeption) {
        json = null;
      }
      expect(json, isNotNull);
    });
    test('testChangePass', () async {
      final url = Uri.http('192.168.100.107', '/users/change/testUserZ');
      final body = {'password': '111', 'newPassword': '111'};
      var json;
      try {
        json = await NetworkUtils.put(
            url,
            headers: {'Content-Type': 'application/json', 'x-access-token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJiOTA3ODM3Yy1lNjY3LTQwYTgtODA3Yi1iZTY1Mzg5M2EzOGIiLCJpYXQiOjE2MDgyMTc3NTcsImV4cCI6MTYwODgyMjU1N30.pq0sGWmvbSzT28fHBnNILsE1qyHxybkiZmH02h22A-8'},
            body: body,
            encoding: Encoding.getByName('utf-8'),);
      } catch (Exeption) {
        json = null;
      }
      expect(json, isNotNull);
    });
  });
}
