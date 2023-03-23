import '../../models/AuthenticateResponse/authenticate_response.dart';

abstract class ILoginService {
  Future<AuthenticateResponse?> authenticate(String? username, String? password);
}