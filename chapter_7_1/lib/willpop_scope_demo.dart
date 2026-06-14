import 'package:flutter/material.dart';

// 应用入口

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: WillPopScopeDemo());
  }
}

/// 7.1 WillPopScope 演示（导航返回拦截）
/// 用于拦截用户点击返回按钮的行为
class WillPopScopeDemo extends StatefulWidget {
  const WillPopScopeDemo({super.key});

  @override
  State<WillPopScopeDemo> createState() => _WillPopScopeDemoState();
}

class _WillPopScopeDemoState extends State<WillPopScopeDemo> {
  DateTime? _lastPressedAt; // 上次点击返回键的时间
  bool _isEditing = false; // 是否处于编辑状态

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // onPopInvokedWithResult 返回拦截逻辑
      canPop: !_isEditing, // 编辑状态不允许直接返回
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // 已经 pop 了，无需处理

        if (_isEditing) {
          final shouldPop = await _showExitDialog();
          if (shouldPop && mounted) {
            Navigator.of(context).pop();
          }
          return;
        }

        // 双击退出逻辑
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt!) >
                const Duration(seconds: 2)) {
          // 第一次点击或间隔超过2秒 → 提示
          _lastPressedAt = DateTime.now();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('再按一次退出应用'),
                duration: Duration(seconds: 2),
              ),
            );
          }
          return; // 不退出
        }
        // 2秒内第二次点击 → 退出
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('7.1 WillPopScope 返回拦截')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('1. 双击返回退出（修改版）'),
              const SizedBox(height: 8),
              const Text(
                '连续按两次返回键退出页面',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // 编辑状态拦截
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('编辑状态: '),
                  Switch(
                    value: _isEditing,
                    onChanged: (val) {
                      setState(() => _isEditing = val);
                    },
                  ),
                ],
              ),
              const Text(
                '开启编辑状态后，返回时会弹出确认对话框',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),

              const SizedBox(height: 24),
              // 说明区域
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('💡 WillPopScope 说明：',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(
                      '• Flutter 3.12+ 中 WillPopScope 已废弃\n'
                      '• 替代方案：PopScope\n'
                      '• canPop: 控制是否允许直接返回\n'
                      '• onPopInvokedWithResult: 返回被触发时回调\n'
                      '• didPop=true 表示已经成功 pop\n'
                      '• 返回 false 阻止页面出栈',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示退出确认对话框
  Future<bool> _showExitDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('确认'),
          content: const Text('当前处于编辑状态，确定要退出吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('退出'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
