class ErrorResponse implements Exception {
  String? name;
  String? message;

  ErrorResponse({
    this.name,
    this.message,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      name: json['name'].toString(),
      message: json['message'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'message': message,
    };
  }

  @override
  String toString() {
    return message ?? 'Unknown Error';
  }
}
