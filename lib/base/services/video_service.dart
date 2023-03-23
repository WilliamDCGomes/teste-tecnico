import 'base/base_service.dart';
import 'interface/ivideo_service.dart';

class VideoService extends BaseService implements IVideoService {
  @override
  Future<String?> getVideo() async {
    try {
      final token = await getToken();
      final url = '${baseUrlApi}video/bunny.mp4';
      final response = await get(url, headers: {'X-Access-Token': token});

      if (hasErrorResponse(response)) throw Exception();

      return response.body["url"];
    } catch (_) {
      return null;
    }
  }
}
