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
        'login': 'testUser',
        'password': '222',
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
        'login': 'newUser0',
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
      final url = Uri.http('192.168.100.107', '/users/testUser');
      var json;
      try {
        json = await NetworkUtils.get(url, headers: {'x-access-token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIyMDE3OTk2ZC01ODIwLTQwY2YtYmJjYy1mNTgyZjVmZTA2ZmYiLCJpYXQiOjE2MDgyMTY2OTgsImV4cCI6MTYwODgyMTQ5OH0.Yhuxhs9NzRR_sZloUSa6pBE320uqdaorD2vBsDjtj5U'});
      } catch (Exeption) {
        json = null;
      }
      expect(json, isNotNull);
    });
    test('testChangePass', () async {
      final url = Uri.http('192.168.100.107', '/users/change/newUser0');
      final body = {'password': '111', 'newPassword': '222'};
      var json;
      try {
        json = await NetworkUtils.put(
            url,
            headers: {'Content-Type': 'application/json', 'x-access-token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIyMDE3OTk2ZC01ODIwLTQwY2YtYmJjYy1mNTgyZjVmZTA2ZmYiLCJpYXQiOjE2MDgyMTY2OTgsImV4cCI6MTYwODgyMTQ5OH0.Yhuxhs9NzRR_sZloUSa6pBE320uqdaorD2vBsDjtj5U'},
            body: body,
            encoding: Encoding.getByName('utf-8'),);
      } catch (Exeption) {
        json = null;
      }
      expect(json, isNotNull);
    });
  });
}
