import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RequestAssistant{

  static Future<dynamic> getRequest(String url) async{
      http.Response response=await http.get(Uri.parse(url));
      print('res:: ${response.body}');
     try{
       if(response.statusCode==200){
         String jsondata= response.body;
         var decodedata=jsonDecode(jsondata);
         return decodedata;
       }
       else{
         return "Failed";
       }
     }catch(exp){
       return "Failed";
     }
  }
}