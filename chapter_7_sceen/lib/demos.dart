import 'package:flutter/material.dart';
import 'pages.dart';

class DemoEntry {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;
  const DemoEntry({required this.title, required this.subtitle, required this.icon, required this.page});
}

final List<DemoEntry> chapter7Demos = [
  DemoEntry(
    title: '7.1 WillPopScope / PopScope',
    subtitle: '导航返回拦截：双击退出、编辑状态拦截、对话框确认',
    icon: Icons.arrow_back,
    page: const WillPopScopeDemoPage(),
  ),
  DemoEntry(
    title: '7.2 InheritedWidget',
    subtitle: '跨级数据共享：依赖注册 vs 不注册、didChangeDependencies',
    icon: Icons.share,
    page: const InheritedWidgetDemoPage(),
  ),
  DemoEntry(
    title: '7.3 Theme 主题',
    subtitle: '全局/局部换肤、深色模式切换、copyWith 局部主题覆盖',
    icon: Icons.palette,
    page: const ThemeDemoPage(),
  ),
  DemoEntry(
    title: '7.4 对话框 & 功能组件',
    subtitle: 'AlertDialog、SimpleDialog、BottomSheet、SnackBar',
    icon: Icons.chat,
    page: const DialogsDemoPage(),
  ),
];
