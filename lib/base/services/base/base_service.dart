import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teste_tecnico/base/services/login_service.dart';

class BaseService extends GetConnect {
  SharedPreferences? sharedPreferences;
  final String baseUrlApi = "http://mobiletest.seventh.com.br/";

  BaseService() {
    httpClient.timeout = const Duration(seconds: 30);
    allowAutoSignedCert = true;
  }

  Future<String> getToken() async {
    try {
      sharedPreferences ??= sharedPreferences = await SharedPreferences.getInstance();

      String? oldToken = sharedPreferences!.getString('token');
      final String? login = sharedPreferences?.getString("login");
      final String? password = sharedPreferences?.getString("password");

      if (oldToken != null && login != null && password != null) {
        String? newToken = (await LoginService().authenticate(
          login,
          password,
        ))?.token;

        if (newToken == null) throw Exception();

        oldToken = newToken;
        sharedPreferences!.setString('Token', newToken);
      }

      return oldToken!;
    } catch (_) {
      throw Exception();
    }
  }

  bool hasErrorResponse(Response response) {
    return response.unauthorized || response.status.hasError || response.body == null;
  }

  @override
  Future<Response<T>> get<T>(
    String url,
    {
      Map<String, String>? headers,
      String? contentType,
      Map<String, dynamic>? query,
      Decoder<T>? decoder,
    }
  ) async {
    final response = await httpClient.get<T>(
      url,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
    );

    if (!response.unauthorized) return response;

    final token = await getToken();
    return httpClient.get<T>(
      url,
      contentType: contentType,
      query: query,
      headers: {"Authorization": 'Bearer $token'},
      decoder: decoder,
    );
  }

  @override
  Future<Response<T>> post<T>(
    String? url,
    dynamic body,
    {
      String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      Decoder<T>? decoder,
      Progress? uploadProgress,
    }
  ) async {
    final response = await httpClient.post<T>(
      url,
      body: body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
    );

    if (!response.unauthorized) return response;

    final token = await getToken();
    return httpClient.post<T>(
      url,
      body: body,
      contentType: contentType,
      query: query,
      headers: {"Authorization": 'Bearer $token'},
      decoder: decoder,
    );
  }
}
