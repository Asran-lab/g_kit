import 'dart:developer';

import 'package:g_core/g_core_initializer.dart';
import 'package:g_core/network/g_network_initializer.dart';
import 'package:g_core/network/facade/g_network.dart';
import 'package:g_core/network/common/g_network_option.dart';

/// 네트워크 테스트 클래스
/// JSONPlaceholder API를 이용한 사용자 정보 GET 요청 테스트
void main() async {
  log('🚀 G Network 테스트 시작');

  // 1. G Core Initializer를 이용한 네트워크 초기화
  await initializeGNetwork();

  // 2. Mock API에서 사용자 정보 가져오기 테스트
  await testGetUserInfo();

  log('✅ 모든 테스트 완료');
}

/// G Core Initializer를 이용한 네트워크 초기화
Future<void> initializeGNetwork() async {
  log('\n📡 네트워크 초기화 중...');

  try {
    // HTTP 네트워크 옵션 설정 (JSONPlaceholder API 사용)
    final httpOptions = HttpNetworkOption(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      defaultHeaders: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      timeout: const Duration(seconds: 30),
    );

    // 네트워크 초기화자 생성
    final networkInitializer = GNetworkInitializer(
      httpOptions: httpOptions,
      autoConnect: true,
    );

    // G Core Initializer를 통한 초기화
    final coreInitializer = GCoreInitializer([networkInitializer]);
    await coreInitializer.initializeAll();

    log('✅ 네트워크 초기화 완료');
    log('   Base URL: ${httpOptions.baseUrl}');
    log('   Connected: ${GNetwork.isConnected}');
  } catch (e) {
    log('❌ 네트워크 초기화 실패: $e');
    rethrow;
  }
}

/// 사용자 정보 모델
class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final Map<String, dynamic> address;
  final Map<String, dynamic> company;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String,
      address: json['address'] as Map<String, dynamic>,
      company: json['company'] as Map<String, dynamic>,
    );
  }

  @override
  String toString() {
    return '''
User {
  ID: $id
  Name: $name
  Username: $username
  Email: $email
  Phone: $phone
  Website: $website
  Address: ${address['city']}, ${address['zipcode']}
  Company: ${company['name']}
}''';
  }
}

/// Mock API에서 사용자 정보 GET 테스트
Future<void> testGetUserInfo() async {
  log('\n👤 사용자 정보 가져오기 테스트 시작');

  try {
    // 1. 단일 사용자 정보 가져오기 (ID: 1)
    log('\n📊 사용자 ID 1 정보 가져오기...');

    final userResponse = await GNetwork.get<User>(
      path: '/users/1',
      fromJsonT: (json) => User.fromJson(json as Map<String, dynamic>),
    );

    userResponse.fold(
      (exception) {
        log('❌ 사용자 정보 가져오기 실패: ${exception.message}');
        log('   상태 코드: ${exception.statusCode}');
      },
      (response) {
        log('✅ 사용자 정보 가져오기 성공');
        log('   상태 코드: ${response.statusCode}');
        log('   메시지: ${response.message ?? 'N/A'}');
        log('   사용자 정보:');
        log(response.data.toString());
      },
    );

    // 2. 모든 사용자 목록 가져오기
    log('\n📋 모든 사용자 목록 가져오기...');

    final usersResponse = await GNetwork.get<List<User>>(
      path: '/users',
      fromJsonT: (json) {
        final userList = json as List<dynamic>;
        return userList
            .map((userData) => User.fromJson(userData as Map<String, dynamic>))
            .toList();
      },
    );

    usersResponse.fold(
      (exception) {
        log('❌ 사용자 목록 가져오기 실패: ${exception.message}');
        log('   상태 코드: ${exception.statusCode}');
      },
      (response) {
        log('✅ 사용자 목록 가져오기 성공');
        log('   상태 코드: ${response.statusCode}');
        final users = response.data;
        if (users != null) {
          log('   총 사용자 수: ${users.length}명');

          // 처음 3명의 사용자 정보만 출력
          for (int i = 0; i < 3 && i < users.length; i++) {
            log('\n   사용자 ${i + 1}:');
            log('     이름: ${users[i].name}');
            log('     이메일: ${users[i].email}');
            log('     회사: ${users[i].company['name']}');
          }

          if (users.length > 3) {
            log('   ... 외 ${users.length - 3}명');
          }
        } else {
          log('   사용자 데이터가 null입니다.');
        }
      },
    );

    // 3. 존재하지 않는 사용자 요청 (에러 핸들링 테스트)
    log('\n🔍 존재하지 않는 사용자 요청 테스트 (ID: 999)...');

    final notFoundResponse = await GNetwork.get<User>(
      path: '/users/999',
      fromJsonT: (json) => User.fromJson(json as Map<String, dynamic>),
    );

    notFoundResponse.fold(
      (exception) {
        log('✅ 예상된 에러 처리 성공');
        log('   상태 코드: ${exception.statusCode}');
        log('   메시지: ${exception.message}');
      },
      (response) {
        log('⚠️ 예상치 못한 성공 응답');
        log('   상태 코드: ${response.statusCode}');
      },
    );

    log('\n✅ 모든 사용자 정보 테스트 완료');
  } catch (e) {
    log('❌ 테스트 중 예외 발생: $e');
    rethrow;
  }
}
