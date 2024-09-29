import 'package:geolocator/geolocator.dart';

class Locationservice {
  Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스가 비활성화되어 있으면 사용자에게 활성화를 요청
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 권한이 거부되면 사용자에게 설정에서 권한을 활성화하도록 안내
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 권한이 영구적으로 거부되면 사용자에게 설정에서 권한을 활성화하도록 안내
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // 여기에 위치를 가져오는 코드를 작성
    return await Geolocator.getCurrentPosition();
    // position을 사용하여 필요한 작업 수행
  }
}
