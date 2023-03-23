import 'dart:io';

abstract class IVideoService {
  Future<File?> getVideo();
}