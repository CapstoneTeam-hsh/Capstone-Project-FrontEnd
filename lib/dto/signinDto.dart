import 'dart:convert';
import 'package:flutter/material.dart';
//import 'dart:convert';

class Info {
  final int? id;
  final String? uid;
  final String? name;
  final String? email;
  final String? token;
  Info({
    this.id,
    this.uid,
    this.name,
    this.email,
    this.token,
  });

  factory Info.fromJson(Map<String, dynamic> json){
    return Info(
      id: json["id"],
      uid: json["uid"],
      name: json["name"],
      email: json[ "email"],
      token: json["token"],
    );
  }
  // 디코딩 메서드 추가
  factory Info.fromJsonString(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Info.fromJson(jsonMap);
  }
}