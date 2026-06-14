import 'package:flutter/material.dart';

// 应用入口

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: InheritedWidgetDemo());
  }
}

/// 7.2 InheritedWidget 演示（数据共享）
/// InheritedWidget 在 Widget 树中从上到下跨级共享数据
class InheritedWidgetDemo extends StatefulWidget {
  const InheritedWidgetDemo({super.key});

  @override
  State<InheritedWidgetDemo> createState() => _InheritedWidgetDemoState();
}

class _InheritedWidgetDemoState extends State<InheritedWidgetDemo> {
  int _sharedData = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('7.2 InheritedWidget 数据共享')),
      body: _ShareDataWidget(
        data: _sharedData,
        onIncrement: () {
          setState(() => _sharedData++);
        },
        child: const Column(
          children: [
            SizedBox(height: 16),
            // 子组件通过 InheritedWidget 获取共享数据
            _DataDisplay(), // 使用 dependOnInheritedWidgetOfExactType
            SizedBox(height: 8),
            _DataDisplayNoDepend(), // 使用 getElementForInheritedWidgetOfExactType
            SizedBox(height: 16),
            _DataUpdateButton(), // 通过 Builder 获取 context 更新数据
          ],
        ),
      ),
    );
  }
}

// ========== InheritedWidget ==========

/// 自定义 InheritedWidget：在子树中共享 data
class _ShareDataWidget extends InheritedWidget {
  final int data;
  final VoidCallback onIncrement; // 回调：通知父级更新数据

  const _ShareDataWidget({
    required this.data,
    required this.onIncrement,
    required super.child,
  });

  /// 供子组件获取共享数据（注册依赖关系）
  static _ShareDataWidget of(BuildContext context) {
    // dependOnInheritedWidgetOfExactType 会注册依赖关系
    return context.dependOnInheritedWidgetOfExactType<_ShareDataWidget>()!;
  }

  /// 不注册依赖关系（使用 getElementFor...获取实例）
  static _ShareDataWidget? maybeOf(BuildContext context) {
    final element = context
        .getElementForInheritedWidgetOfExactType<_ShareDataWidget>();
    return element?.widget as _ShareDataWidget?;
  }

  @override
  bool updateShouldNotify(_ShareDataWidget oldWidget) {
    // data 变化时通知所有依赖的子树
    return oldWidget.data != data;
  }
}

// ========== 子组件 ==========

/// 子组件1：使用 dependOnInheritedWidgetOfExactType（会注册依赖）
class _DataDisplay extends StatelessWidget {
  const _DataDisplay();

  @override
  Widget build(BuildContext context) {
    // 通过 of(context) 获取共享数据，建立依赖关系
    final shareData = _ShareDataWidget.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              '组件 A (注册依赖)',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 4),
            Text(
              '共享数据: ${shareData.data}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 4),
            const Text(
              '数据变化时此组件会收到通知并重建',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// 子组件2：不注册依赖（使用 getElementFor...）
class _DataDisplayNoDepend extends StatefulWidget {
  const _DataDisplayNoDepend();

  @override
  State<_DataDisplayNoDepend> createState() => _DataDisplayNoDependState();
}

class _DataDisplayNoDependState extends State<_DataDisplayNoDepend> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 如果父级 InheritedWidget 变化，此回调被触发
    print('_DataDisplayNoDependState.didChangeDependencies called');
  }

  @override
  Widget build(BuildContext context) {
    // 不注册依赖 — 使用 getElementForInheritedWidgetOfExactType
    final element = context
        .getElementForInheritedWidgetOfExactType<_ShareDataWidget>();
    final shareData = element?.widget as _ShareDataWidget?;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              '组件 B (不注册依赖)',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 4),
            Text(
              '共享数据: ${shareData?.data ?? "无"}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 4),
            const Text(
              '数据变化时此组件不会主动重建\n但 didChangeDependencies 仍会触发',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// 子组件3：更新共享数据
class _DataUpdateButton extends StatelessWidget {
  const _DataUpdateButton();

  @override
  Widget build(BuildContext context) {
    // 使用 Builder 获取正确 context 层级
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // 通过 InheritedWidget 获取回调，不直接操作父级 State
            final shareDataWidget = _ShareDataWidget.of(context);
            shareDataWidget.onIncrement();
          },
          child: const Text('增加共享数据 (+1)'),
        ),
        const SizedBox(height: 8),
        const Text(
          '点击后，组件A会重建(注册了依赖)\n组件B不会自动重建(未注册依赖)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.yellow.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '💡 InheritedWidget 核心要点：\n'
            '• dependOn... → 注册依赖，数据变 → 子树重建\n'
            '• getElementFor... → 不注册依赖，不主动重建\n'
            '• updateShouldNotify → 控制是否通知\n'
            '• didChangeDependencies → 依赖变化时回调\n'
            '• Flutter 内部用于 Theme、MediaQuery 等',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
