import 'package:shared_preferences/shared_preferences.dart';
import '../models/AuthenticateResponse/authenticate_response.dart';
import 'base/base_service.dart';
import 'interface/ilogin_service.dart';

class LoginService extends BaseService implements ILoginService {
  @override
  Future<AuthenticateResponse?> authenticate({String? username, String? password}) async {
    try {
      httpClient.timeout = const Duration(seconds: 30);
      final sharedPreferences = await SharedPreferences.getInstance();
      username ??= sharedPreferences.getString('user_logged');
      password ??= sharedPreferences.getString('password');
      if (username == null || password == null) throw Exception();
      final url = '${baseUrlApi}api-docs/#/Authorization/post%20login';

      final response = await super.post(
        url,
        null,
        query: {
          "username": username,
          "password": password,
        }).timeout(const Duration(seconds: 30));

      if (hasErrorResponse(response)) throw Exception();

      return AuthenticateResponse.fromJson(response.body);
    } catch (_) {
      return null;
    }
  }
}