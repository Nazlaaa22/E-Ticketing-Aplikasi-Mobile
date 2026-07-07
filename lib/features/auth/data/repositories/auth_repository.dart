import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:8000/api",
      headers: {
        "Accept": "application/json",
      },
    ),
  );

  /// ================= LOGIN =================
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print("===== LOGIN =====");
      print(email);

      final response = await _dio.post(
        "/login",
        data: {
          "email": email,
          "password": password,
        },
      );

      print("LOGIN BERHASIL");
      print(response.data);

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      print("LOGIN ERROR");
      print(e.response?.statusCode);
      print(e.response?.data);

      throw Exception(
        e.response?.data["message"] ?? "Login gagal",
      );
    }
  }

  /// ================= REGISTER =================
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      print("===== REGISTER =====");
      print(name);
      print(email);

      final response = await _dio.post(
        "/register",
        data: {
          "name": name,
          "email": email,
          "password": password,
        },
      );

      print("REGISTER BERHASIL");
      print(response.data);

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      print("REGISTER ERROR");
      print(e.response?.statusCode);
      print(e.response?.data);

      throw Exception(
        e.response?.data["message"] ?? "Register gagal",
      );
    }
  }

  /// ================= PROFILE =================
  Future<Map<String, dynamic>> getProfile(int id) async {
    try {
      final response = await _dio.get("/profile/$id");

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Gagal mengambil profil",
      );
    }
  }

  /// ================= UPDATE PROFILE =================
  Future<Map<String, dynamic>> updateProfile({
    required int id,
    required String name,
    required String username,
    required String email,
    required String phone,
  }) async {
    try {
      final response = await _dio.put(
        "/profile/$id",
        data: {
          "name": name,
          "username": username,
          "email": email,
          "phone": phone,
        },
      );

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Update profil gagal",
      );
    }
  }

  /// ================= GANTI PASSWORD =================
  Future<Map<String, dynamic>> changePassword({
    required int id,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.put(
        "/change-password/$id",
        data: {
          "old_password": oldPassword,
          "new_password": newPassword,
        },
      );

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Ganti password gagal",
      );
    }
  }
}