// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Subject {
  String title;
  String url;
  Subject({
    required this.title,
    required this.url,
  });
  

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
     title: json['title'],
      url: json['url']
    );
  }
}

class SubjectApiService {
  // static const String BASE_URL = 'https://example.com/api';
  
  Future<Map<String, SubjectService>> getSubjects(BuildContext context ,String? url) async {
   
    final http.Response response;
 
    response = await http.get(Uri.parse(url??""));
   
    if (response.statusCode == 200) {
      
      Fluttertoast.showToast(msg: 'Content loaded');
      final jsonList = response.body;
      return   subjectServiceFromJson(jsonList);
    } else {
      Fluttertoast.showToast(msg: 'Failed to get Subjects: ${response.statusCode}');
      return {};
    }
  }
  
  
  
}




Map<String, SubjectService> subjectServiceFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, SubjectService>(k, SubjectService.fromJson(v)));

String subjectServiceToJson(Map<String, SubjectService> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class SubjectService {
    SubjectService({
        required this.title,
        this.url,
    });

    String title;
    String? url;

    factory SubjectService.fromJson(Map<String, dynamic> json) => SubjectService(
        title: json["title"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "url": url,
    };
}