import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String apiUrlGlobal = 'fmklg.klgsys.com';

// Future getUnitList() async {
//   var url = Uri.https(apiUrlGlobal, 'ExitPassHOBackend/public/api/unit/list');

//   Map<String, String> requestHeader = {
//     // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
//   };

//   try {
//     var response = await http.get(url);
//     var data = json.decode(response.body);

//     return data;
//   } on Error catch (e) {
//     return e;
//   }
// }
