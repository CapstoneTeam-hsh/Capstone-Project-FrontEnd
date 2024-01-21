

import 'dart:convert';

class Errordto {
  final String? details;
  final String? message;

  Errordto({
    this.details,
    this.message,
  });

  factory Errordto.fromJson(Map<String, dynamic> json) {
    return Errordto(
      details: json["details"],
      message: json["message"],
    );
  }

  factory Errordto.fromJsonString(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Errordto.fromJson(jsonMap);
  }
}