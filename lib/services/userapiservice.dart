import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:teamsyncai/model/user_model.dart';

class UserApiService {
  static const String baseUrl = "http://192.168.128.154:3000";

  static Future<User> authenticateUser(String email, String password) async {
    try {
      final Uri requestUri = Uri.parse('$baseUrl/user/loginclient');
      final Map<String, String> requestBody = {
        'email': email,
        'password': password,
      };

      final http.Response response = await http.post(
        requestUri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return User.fromJson(responseData['user']);
      } else {
        throw Exception('Authentication failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Authentication failed with error: $e');
      throw Exception('Authentication failed: $e');
    }
  }


  static Future<User> fetchUserProfileByEmail(String email) async {
    final Uri requestUri = Uri.parse('$baseUrl/user/profile?email=$email');

    final http.Response response = await http.get(
      requestUri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return User.fromJson(responseData);
    } else {
      throw Exception('Failed to fetch user profile by email');
    }
  }
  static Future<User> fetchUserProfile(String userId) async {
    final Uri requestUri = Uri.parse('$baseUrl/user/profile/$userId');

    final http.Response response = await http.get(
      requestUri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return User.fromJson(responseData);
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  static Future<void> findByCredentials(String email, String password) async {
    final Uri requestUri = Uri.parse('$baseUrl/user/loginclient');
    final Map<String, String> requestBody = {
      'email': email,
      'password': password,
    };

    final http.Response response = await http.post(
      requestUri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send credentials by email');
    }
  }

  static Future<User> createUser(String username, String email, String numTel, String password, String specialty, File? cvFile) async {
    try {
      final Uri requestUri = Uri.parse('$baseUrl/user/registerclient');

      // Create a multipart request
      var request = http.MultipartRequest('POST', requestUri);

      // Add text fields to the request
      request.fields['username'] = username;
      request.fields['email'] = email;
      request.fields['numTel'] = numTel;
      request.fields['password'] = password;
      request.fields['specialty'] = specialty;

      // Add the PDF file to the request if available
      if (cvFile != null) {
        var cvStream = http.ByteStream(cvFile.openRead());
        var length = await cvFile.length();

        var cvFilePart = http.MultipartFile(
          'cv',
          cvStream,
          length,
          filename: basename(cvFile.path),
        );
        request.files.add(cvFilePart);
      }

      // Send the request and get the response
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return User.fromJson(responseData);
      } else {
        print('Failed to create user: ${response.body}');
        throw Exception('Failed to create user');
      }
    } catch (e) {
      print('Failed to create user: $e');
      throw Exception('Failed to create user: $e');
    }
  }
}