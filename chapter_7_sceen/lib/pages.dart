import 'package:flutter/material.dart';

// ============================================================
// 7.1 WillPopScope / PopScope
// ============================================================
class WillPopScopeDemoPage extends StatefulWidget {
  const WillPopScopeDemoPage({super.key});
  @override State<WillPopScopeDemoPage> createState() => _WillPopScopeDemoPageState();
}

class _WillPopScopeDemoPageState extends State<WillPopScopeDemoPage> {
  DateTime? _lastPressedAt;
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isEditing,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_isEditing) {
          final ok = await _showExitDialog();
          if (ok == true && mounted) Navigator.of(context).pop();
          return;
        }
        if (_lastPressedAt == null || DateTime.now().difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = DateTime.now();
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('再按一次退出'), duration: Duration(seconds: 2)));
          return;
        }
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('7.1 返回拦截')),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('1. 双击返回退出'),
            const SizedBox(height: 8),
            const Text('连续按两次返回键退出', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('编辑状态: '),
              Switch(value: _isEditing, onChanged: (v) => setState(() => _isEditing = v)),
            ]),
            const Text('开启后返回会弹出确认对话框', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
              child: const Text('💡 Flutter 3.12+ 中 WillPopScope 已废弃\n替代方案：PopScope\ncanPop 控制是否允许返回\nonPopInvokedWithResult 处理返回逻辑', style: TextStyle(fontSize: 13)),
            ),
          ]),
        ),
      ),
    );
  }

  Future<bool?> _showExitDialog() => showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
    title: const Text('确认'), content: const Text('编辑中，确定退出？'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('退出')),
    ],
  ));
}

// ============================================================
// 7.2 InheritedWidget
// ============================================================

class _ShareDataWidget extends InheritedWidget {
  final int data;
  final VoidCallback onIncrement;
  const _ShareDataWidget({required this.data, required this.onIncrement, required super.child});

  static _ShareDataWidget of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<_ShareDataWidget>()!;

  @override
  bool updateShouldNotify(_ShareDataWidget old) => old.data != data;
}

class InheritedWidgetDemoPage extends StatefulWidget {
  const InheritedWidgetDemoPage({super.key});
  @override State<InheritedWidgetDemoPage> createState() => _InheritedWidgetDemoPageState();
}

class _InheritedWidgetDemoPageState extends State<InheritedWidgetDemoPage> {
  int _data = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('7.2 InheritedWidget')),
      body: _ShareDataWidget(
        data: _data,
        onIncrement: () => setState(() => _data++),
        child: const Column(children: [
          SizedBox(height: 16),
          _DataDisplay(),
          SizedBox(height: 8),
          _DataDisplayNoDepend(),
          SizedBox(height: 16),
          _DataUpdateButton(),
        ]),
      ),
    );
  }
}

class _DataDisplay extends StatelessWidget {
  const _DataDisplay();

  @override
  Widget build(BuildContext context) {
    final d = _ShareDataWidget.of(context).data;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const Text('组件A (注册依赖)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(height: 4),
          Text('共享数据: $d', style: const TextStyle(fontSize: 20)),
          const Text('依赖变化时自动重建', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ]),
      ),
    );
  }
}

class _DataDisplayNoDepend extends StatelessWidget {
  const _DataDisplayNoDepend();

  @override
  Widget build(BuildContext context) {
    final el = context.getElementForInheritedWidgetOfExactType<_ShareDataWidget>();
    final d = (el?.widget as _ShareDataWidget?)?.data;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const Text('组件B (不注册依赖)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
          const SizedBox(height: 4),
          Text('共享数据: ${d ?? "无"}', style: const TextStyle(fontSize: 20)),
          const Text('数据变化时不会主动重建', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ]),
      ),
    );
  }
}

class _DataUpdateButton extends StatelessWidget {
  const _DataUpdateButton();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ElevatedButton(
        onPressed: () => _ShareDataWidget.of(context).onIncrement(),
        child: const Text('增加共享数据 (+1)'),
      ),
      const SizedBox(height: 8),
      const Text('A 会重建，B 不会重建', style: TextStyle(fontSize: 12, color: Colors.grey)),
      const SizedBox(height: 12),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.yellow.shade50, borderRadius: BorderRadius.circular(8)),
        child: const Text('💡 dependOn... → 注册依赖\ngetElementFor... → 不注册依赖\nupdateShouldNotify → 控制通知\ndidChangeDependencies → 依赖变化回调', style: TextStyle(fontSize: 12)),
      ),
    ]);
  }
}

// ============================================================
// 7.3 Theme
// ============================================================
class ThemeDemoPage extends StatefulWidget {
  const ThemeDemoPage({super.key});
  @override State<ThemeDemoPage> createState() => _ThemeDemoPageState();
}

class _ThemeDemoPageState extends State<ThemeDemoPage> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _dark ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('7.3 Theme 主题'),
          actions: [IconButton(icon: Icon(_dark ? Icons.light_mode : Icons.dark_mode), onPressed: () => setState(() => _dark = !_dark))],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('1. 获取主题', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                Icon(Icons.palette, color: Theme.of(context).colorScheme.onPrimaryContainer),
                const SizedBox(width: 8),
                Text('当前是 ${_dark ? "深色" : "浅色"} 模式', style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer)),
              ]),
            ),
            const SizedBox(height: 16),
            const Text('2. 使用主题样式', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Headline Medium', style: Theme.of(context).textTheme.headlineMedium),
                  Text('Title Large', style: Theme.of(context).textTheme.titleLarge),
                  Text('Body Medium', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8), const Divider(), const SizedBox(height: 8),
                  Row(children: [
                    Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Icon(Icons.favorite, color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: 8),
                    Icon(Icons.thumb_up, color: Theme.of(context).colorScheme.tertiary),
                  ]),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            const Text('3. copyWith 局部主题覆盖', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: Card(
                  child: Padding(padding: const EdgeInsets.all(12), child: Column(children: const [
                    Text('默认主题', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Icon(Icons.star, size: 32),
                    Text('默认'),
                  ])),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(iconTheme: const IconThemeData(color: Colors.blue, size: 40)),
                  child: Card(
                    child: Padding(padding: const EdgeInsets.all(12), child: Column(children: const [
                      Text('局部蓝色', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Icon(Icons.star, size: 32),
                      Text('蓝色Icon'),
                    ])),
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}

// ============================================================
// 7.4 对话框
// ============================================================
class DialogsDemoPage extends StatefulWidget {
  const DialogsDemoPage({super.key});
  @override State<DialogsDemoPage> createState() => _DialogsDemoPageState();
}

class _DialogsDemoPageState extends State<DialogsDemoPage> {
  String _selected = '未选择';

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));

  Future<void> _alert() async {
    final r = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('确认操作'), content: const Text('确定执行？'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('确定')),
      ],
    ));
    if (mounted) _snack(r == true ? '已确认' : '已取消');
  }

  Future<void> _simple() async {
    final r = await showDialog<String>(context: context, builder: (ctx) => SimpleDialog(
      title: const Text('请选择'),
      children: [
        SimpleDialogOption(onPressed: () => Navigator.pop(ctx, '选项A'), child: const Row(children: [Icon(Icons.looks_one, color: Colors.blue), SizedBox(width: 12), Text('选项A')])),
        SimpleDialogOption(onPressed: () => Navigator.pop(ctx, '选项B'), child: const Row(children: [Icon(Icons.looks_two, color: Colors.green), SizedBox(width: 12), Text('选项B')])),
        SimpleDialogOption(onPressed: () => Navigator.pop(ctx, '选项C'), child: const Row(children: [Icon(Icons.looks_3, color: Colors.orange), SizedBox(width: 12), Text('选项C')])),
      ],
    ));
    if (r != null) setState(() => _selected = r);
  }

  void _bottomSheet() => showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('分享到', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ListTile(leading: const Icon(Icons.wechat, color: Colors.green), title: const Text('微信'), onTap: () => Navigator.pop(ctx)),
        ListTile(leading: const Icon(Icons.email, color: Colors.blue), title: const Text('邮件'), onTap: () => Navigator.pop(ctx)),
        ListTile(leading: const Icon(Icons.copy, color: Colors.grey), title: const Text('复制链接'), onTap: () => Navigator.pop(ctx)),
      ]),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('7.4 对话框')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: ListTile(leading: const Icon(Icons.warning_amber, color: Colors.orange), title: const Text('AlertDialog'), subtitle: const Text('确认/取消对话框'), trailing: const Icon(Icons.chevron_right), onTap: _alert)),
        const SizedBox(height: 8),
        Card(child: ListTile(leading: const Icon(Icons.list, color: Colors.blue), title: const Text('SimpleDialog'), subtitle: Text('当前: $_selected'), trailing: const Icon(Icons.chevron_right), onTap: _simple)),
        const SizedBox(height: 8),
        Card(child: ListTile(leading: const Icon(Icons.vertical_align_bottom, color: Colors.purple), title: const Text('BottomSheet'), subtitle: const Text('底部弹出面板'), trailing: const Icon(Icons.chevron_right), onTap: _bottomSheet)),
        const SizedBox(height: 8),
        Card(child: ListTile(leading: const Icon(Icons.info, color: Colors.indigo), title: const Text('SnackBar'), subtitle: const Text('轻量消息提示'), trailing: const Icon(Icons.chevron_right), onTap: () => _snack('SnackBar 消息'))),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.yellow.shade50, borderRadius: BorderRadius.circular(8)), child: const Text('💡 AlertDialog / SimpleDialog / showModalBottomSheet / SnackBar / showDatePicker 等', style: TextStyle(fontSize: 12))),
      ]),
    );
  }
}
