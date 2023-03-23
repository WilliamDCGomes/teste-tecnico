import 'dart:io';
import 'base/base_service.dart';
import 'interface/ivideo_service.dart';

class VideoService extends BaseService implements IVideoService {
  @override
  Future<File?> getVideo() async {
    try {
      final token = await getToken();
      final url = '${baseUrlApi}video/bunny.mp4';
      final response = await get(url, headers: {'X-Access-Token': token});

      if (hasErrorResponse(response)) throw Exception();

      print(response.body);
      return null;
    } catch (_) {
      return null;
    }
  }
}
