import '../models/AuthenticateResponse/authenticate_response.dart';
import 'base/base_service.dart';
import 'interface/ilogin_service.dart';

class LoginService extends BaseService implements ILoginService {
  @override
  Future<AuthenticateResponse?> authenticate(String? username, String? password) async {
    try {
      if (username == null || password == null) throw Exception();
      final url = '${baseUrlApi}login';

      final response = await super.post(
        url,
        {
          "username": username,
          "password": password,
        },
      );

      if (hasErrorResponse(response)) throw Exception();

      return AuthenticateResponse.fromJson(response.body);
    } catch (_) {
      return null;
    }
  }
}