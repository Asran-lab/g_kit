import 'package:g_lib/g_lib_image.dart' as gimg;
import 'package:g_lib/g_lib_common.dart' as glib;

/// 이미지 선택 및 편집을 위한 유틸리티 클래스
class GImagePicker {
  /// 갤러리에서 이미지를 선택하고 크롭합니다
  static Future<String?> pickFromGalleryAndCrop({int quality = 90}) async {
    final picker = gimg.ImagePicker();
    final picked = await picker.pickImage(source: gimg.ImageSource.gallery);
    if (picked == null) return null;
    return _cropImage(picked.path, quality: quality);
  }

  /// 카메라에서 이미지를 촬영하고 크롭합니다
  static Future<String?> captureFromCameraAndCrop({int quality = 90}) async {
    final picker = gimg.ImagePicker();
    final picked = await picker.pickImage(source: gimg.ImageSource.camera);
    if (picked == null) return null;
    return _cropImage(picked.path, quality: quality);
  }

  /// 갤러리에서 여러 장 선택. cropEach=true이면 각 이미지에 대해 크롭 UI를 순차적으로 띄웁니다.
  static Future<List<String>> pickMultipleFromGallery({
    int quality = 90,
    bool cropEach = false,
  }) async {
    final picker = gimg.ImagePicker();
    final pickedList = await picker.pickMultiImage();
    if (pickedList.isEmpty) return const [];
    if (!cropEach) {
      return pickedList.map((x) => x.path).toList(growable: false);
    }

    final List<String> results = [];
    for (final x in pickedList) {
      final cropped = await _cropImage(x.path, quality: quality);
      if (cropped != null) results.add(cropped);
    }
    return results;
  }

  /// 이미지 크롭 처리
  static Future<String?> _cropImage(String path, {int quality = 90}) async {
    final result = await gimg.ImageCropper().cropImage(
      sourcePath: path,
      compressFormat: gimg.ImageCompressFormat.jpg,
      compressQuality: quality,
      uiSettings: [
        gimg.AndroidUiSettings(
          toolbarTitle: '이미지 편집',
          hideBottomControls: false,
          lockAspectRatio: false,
        ),
        gimg.IOSUiSettings(
          title: '이미지 편집',
          aspectRatioLockEnabled: false,
        ),
      ],
    );
    if (result == null) return null;
    if (result.path.isNotEmpty) {
      return result.path;
    }
    final tempDir = await glib.getTemporaryDirectory();
    return '${tempDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg';
  }
}
