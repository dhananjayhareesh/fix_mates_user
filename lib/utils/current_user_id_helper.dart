import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static Future<void> storeUserDocumentId(String docId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userDocId', docId);
  }

  static Future<String?> getUserDocumentId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userDocId');
  }
}
