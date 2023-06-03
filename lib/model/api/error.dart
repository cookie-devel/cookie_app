class ErrorResponse implements Exception {
  String? name;
  String? message;

  ErrorResponse({
    this.name,
    this.message,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      name: json['name'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'message': message,
    };
  }
}
