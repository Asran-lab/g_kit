import 'package:flutter/material.dart';
import 'package:g_core/app_lifecycle/facade/g_app_lifecycle.dart';

/// 앱 라이프사이클 사용 예제
class AppLifecycleExample extends StatefulWidget {
  const AppLifecycleExample({super.key});

  @override
  State<AppLifecycleExample> createState() => _AppLifecycleExampleState();
}

class _AppLifecycleExampleState extends State<AppLifecycleExample> {
  String _currentState = 'Unknown';
  String _lastEvent = 'None';

  @override
  void initState() {
    super.initState();

    // 리스너 추가
    GAppLifecycle.addListener(_onLifecycleChanged);

    // 현재 상태 설정
    _updateCurrentState();
  }

  @override
  void dispose() {
    // 리스너 제거
    GAppLifecycle.removeListener(_onLifecycleChanged);
    super.dispose();
  }

  void _onLifecycleChanged(AppLifecycleState state) {
    setState(() {
      _lastEvent = state.toString();
      _updateCurrentState();
    });
  }

  void _updateCurrentState() {
    final state = GAppLifecycle.currentState;
    if (state != null) {
      setState(() {
        _currentState = state.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Lifecycle Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current State:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentState,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Last Event:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _lastEvent,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status Checks:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusItem(
                        'Is Foreground', GAppLifecycle.isForeground),
                    _buildStatusItem(
                        'Is Background', GAppLifecycle.isBackground),
                    _buildStatusItem('Is Resumed', GAppLifecycle.isResumed),
                    _buildStatusItem('Is Paused', GAppLifecycle.isPaused),
                    _buildStatusItem('Is Inactive', GAppLifecycle.isInactive),
                    _buildStatusItem('Is Detached', GAppLifecycle.isDetached),
                    _buildStatusItem('Is Hidden', GAppLifecycle.isHidden),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Instructions:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• 앱을 백그라운드로 보내려면 홈 버튼을 누르세요\n'
                      '• 앱을 다시 포그라운드로 가져오려면 앱 아이콘을 탭하세요\n'
                      '• 상태 변경이 실시간으로 표시됩니다',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            color: value ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: $value',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
