import 'package:flutter/material.dart';
import '../extensions/g_gradient_theme_extension.dart';

/// 그라데이션 테마 사용 예제
class GGradientThemeExample extends StatelessWidget {
  const GGradientThemeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '그라데이션 테마 예제',
      theme: ThemeData(
        extensions: [
          // 분홍 -> 보라색 그라데이션을 primary로 설정
          GGradientThemeExtension(
            gradientMap: {
              'primary': const LinearGradient(
                colors: [Colors.pink, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              'secondary': const LinearGradient(
                colors: [Colors.blue, Colors.cyan],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              'tertiary': const LinearGradient(
                colors: [Colors.orange, Colors.red],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              'surface': const LinearGradient(
                colors: [Color(0xFFF5F5F5), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            },
          ),
        ],
      ),
      home: const GGradientExamplePage(),
    );
  }
}

/// 그라데이션 예제 페이지
class GGradientExamplePage extends StatelessWidget {
  const GGradientExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GGradientWidgets.gradientText(
          context: context,
          gradientKey: 'primary',
          text: '그라데이션 테마 예제',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. 그라데이션 컨테이너 예제
            GGradientWidgets.gradientContainer(
              context: context,
              gradientKey: 'primary',
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Primary 그라데이션 배경',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              borderRadius: BorderRadius.circular(12),
            ),

            const SizedBox(height: 16),

            // 2. Secondary 그라데이션 예제
            GGradientWidgets.gradientContainer(
              context: context,
              gradientKey: 'secondary',
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Secondary 그라데이션 배경',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              borderRadius: BorderRadius.circular(12),
            ),

            const SizedBox(height: 16),

            // 3. Tertiary 그라데이션 예제
            GGradientWidgets.gradientContainer(
              context: context,
              gradientKey: 'tertiary',
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Tertiary 그라데이션 배경',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              borderRadius: BorderRadius.circular(12),
            ),

            const SizedBox(height: 16),

            // 4. 그라데이션 텍스트 예제
            GGradientWidgets.gradientText(
              context: context,
              gradientKey: 'primary',
              text: '그라데이션 텍스트 예제',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // 5. 그라데이션 아이콘 예제
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GGradientWidgets.gradientIcon(
                  context: context,
                  gradientKey: 'primary',
                  icon: Icons.favorite,
                  size: 48,
                ),
                GGradientWidgets.gradientIcon(
                  context: context,
                  gradientKey: 'secondary',
                  icon: Icons.star,
                  size: 48,
                ),
                GGradientWidgets.gradientIcon(
                  context: context,
                  gradientKey: 'tertiary',
                  icon: Icons.thumb_up,
                  size: 48,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 6. 직접 그라데이션 사용 예제
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: context.getGradient('primary'),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  '직접 그라데이션 사용',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 7. 그라데이션 존재 여부 확인 예제
            Text(
              'Primary 그라데이션 존재: ${context.hasGradient('primary')}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Unknown 그라데이션 존재: ${context.hasGradient('unknown')}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

/// 동적 그라데이션 테마 변경 예제
class DynamicGradientExample extends StatefulWidget {
  const DynamicGradientExample({super.key});

  @override
  State<DynamicGradientExample> createState() => _DynamicGradientExampleState();
}

class _DynamicGradientExampleState extends State<DynamicGradientExample> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '동적 그라데이션 테마',
      theme: ThemeData(
        extensions: [
          GGradientThemeExtension(
            gradientMap: _isDarkMode ? _darkGradients : _lightGradients,
          ),
        ],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('동적 그라데이션 테마'),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GGradientWidgets.gradientContainer(
                context: context,
                gradientKey: 'primary',
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '동적 그라데이션 배경',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 라이트 모드 그라데이션
  static const Map<String, Gradient> _lightGradients = {
    'primary': LinearGradient(
      colors: [Colors.blue, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  };

  // 다크 모드 그라데이션
  static const Map<String, Gradient> _darkGradients = {
    'primary': LinearGradient(
      colors: [Colors.purple, Colors.indigo],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  };
}
