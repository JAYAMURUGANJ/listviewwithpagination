import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:listviewwithpagination/model/nomination.dart';

Future<List<NominationDetails>> getNominationDetails() async {
  final response = await http.get(
    Uri.parse(
        "https://storage.googleapis.com/s3.codeapprun.io/userassets/jayamurugan/JAZDCtfqFYnomination.json"),
  );
  if (response.statusCode == 200) {
    var listofdata = response.body;
    //print(listofdata);
    List<NominationDetails> list = parseUsers(listofdata);
    return list;
  } else {
    throw Exception("Error");
  }
}

List<NominationDetails> parseUsers(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<dynamic, dynamic>>();
  return parsed
      .map<NominationDetails>((json) => NominationDetails.fromJson(json))
      .toList();
}
