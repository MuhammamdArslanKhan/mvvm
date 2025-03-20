class LoginResponse {
  final String? token;
  final String? message;
  final int? userId;
  // Add other fields from your API response

  LoginResponse({this.token, this.message, this.userId});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      message: json['message'],
      userId: json['userId'],
      // Parse other fields
    );
  }
}