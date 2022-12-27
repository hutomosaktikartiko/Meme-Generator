import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class DotEnvInfo {
  String? imgflipApiUrl();
  String? imgflipUsername();
  String? imgflipPassword();
}

class DotEnvInfoImpl implements DotEnvInfo {
  @override
  String? imgflipApiUrl() {
    return _getData(key: "API_URL");
  }

  @override
  String? imgflipUsername() {
    return _getData(key: "USERNAME");
  }

  @override
  String? imgflipPassword() {
    return _getData(key: "PASSWORD");
  }


  String? _getData({
    required String key
  }) {
    return dotenv.get(key);
  }
}