import 'package:flutter_test/flutter_test.dart';
import 'package:griot_app/core/services/griot_video_services.dart';

void main() {
  group('GriotVideoService', () {
    test('creates instance correctly', () async {
      final videoService =
          GriotVideoService(videoUrl: 'http://dummy_video_url.com');

      expect(videoService, isNotNull);
    });
  });
}
