import 'package:flutter/material.dart';

// 应用入口

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DialogDemo());
  }
}

/// 7.4 对话框和其他功能型组件演示
/// 包括 AlertDialog、SimpleDialog、SnackBar、BottomSheet 等
class DialogDemo extends StatefulWidget {
  const DialogDemo({super.key});

  @override
  State<DialogDemo> createState() => _DialogDemoState();
}

class _DialogDemoState extends State<DialogDemo> {
  String _selectedOption = '未选择';

  /// 1. AlertDialog
  Future<void> _showAlertDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('确认操作'),
          content: const Text('确定要执行此操作吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
    if (mounted) {
      _showSnackBar(result == true ? '已确认' : '已取消');
    }
  }

  /// 2. SimpleDialog（选项列表）
  Future<void> _showSimpleDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('请选择一项'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop('选项 A'),
              child: const Row(
                children: [
                  Icon(Icons.looks_one, color: Colors.blue),
                  SizedBox(width: 12),
                  Text('选项 A - 蓝色方案'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop('选项 B'),
              child: const Row(
                children: [
                  Icon(Icons.looks_two, color: Colors.green),
                  SizedBox(width: 12),
                  Text('选项 B - 绿色方案'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop('选项 C'),
              child: const Row(
                children: [
                  Icon(Icons.looks_3, color: Colors.orange),
                  SizedBox(width: 12),
                  Text('选项 C - 橙色方案'),
                ],
              ),
            ),
          ],
        );
      },
    );
    if (result != null) {
      setState(() => _selectedOption = result);
    }
  }

  /// 3. 自定义对话框（带输入框）
  Future<void> _showCustomDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Icon(Icons.edit, size: 40, color: Colors.blue),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: '输入内容',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.text_fields),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
    if (result != null && mounted) {
      _showSnackBar('输入内容: $result');
    }
    controller.dispose();
  }

  /// 辅助：显示 SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(label: '知道了', onPressed: () {}),
      ),
    );
  }

  /// 4. BottomSheet
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('分享到', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.wechat, color: Colors.green),
                title: const Text('微信'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.email, color: Colors.blue),
                title: const Text('邮件'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.grey),
                title: const Text('复制链接'),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('7.4 对话框 & 功能型组件')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // AlertDialog
          Card(
            child: ListTile(
              leading: const Icon(Icons.warning_amber, color: Colors.orange),
              title: const Text('AlertDialog'),
              subtitle: const Text('带确认/取消按钮的警告对话框'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showAlertDialog,
            ),
          ),
          const SizedBox(height: 8),

          // SimpleDialog
          Card(
            child: ListTile(
              leading: const Icon(Icons.list, color: Colors.blue),
              title: const Text('SimpleDialog'),
              subtitle: Text('当前选择: $_selectedOption'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showSimpleDialog,
            ),
          ),
          const SizedBox(height: 8),

          // 自定义对话框
          Card(
            child: ListTile(
              leading: const Icon(Icons.edit, color: Colors.teal),
              title: const Text('自定义对话框'),
              subtitle: const Text('带输入框的 AlertDialog'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showCustomDialog,
            ),
          ),
          const SizedBox(height: 8),

          // BottomSheet
          Card(
            child: ListTile(
              leading: const Icon(Icons.vertical_align_bottom, color: Colors.purple),
              title: const Text('ModalBottomSheet'),
              subtitle: const Text('从底部弹出的模态面板'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showBottomSheet,
            ),
          ),
          const SizedBox(height: 8),

          // SnackBar（直接触发）
          Card(
            child: ListTile(
              leading: const Icon(Icons.info, color: Colors.indigo),
              title: const Text('SnackBar'),
              subtitle: const Text('屏幕底部的轻量级消息提示'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showSnackBar('这是一条 SnackBar 消息'),
            ),
          ),
          const SizedBox(height: 24),

          // 说明
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.yellow.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '💡 对话框组件说明：\n'
              '• AlertDialog - 标准警告/确认对话框\n'
              '• SimpleDialog - 选项列表对话框\n'
              '• showDialog + 自定义 - 任意内容对话框\n'
              '• showModalBottomSheet - 底部弹出面板\n'
              '• SnackBar - 底部轻量消息（ScaffoldMessenger）\n'
              '• showDatePicker / showTimePicker - 日期时间选择\n'
              '• showAboutDialog - 关于对话框',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
