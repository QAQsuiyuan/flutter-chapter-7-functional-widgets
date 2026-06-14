import 'package:flutter/material.dart';

// 应用入口

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ThemeDemo());
  }
}

/// 7.3 Theme 演示（主题）
/// Theme 组件内部通过 InheritedWidget 共享样式数据
class ThemeDemo extends StatefulWidget {
  const ThemeDemo({super.key});

  @override
  State<ThemeDemo> createState() => _ThemeDemoState();
}

class _ThemeDemoState extends State<ThemeDemo> {
  bool _darkMode = false;
  bool _localBlue = false; // 是否局部使用蓝色主题

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 获取系统默认主题
      theme: _darkMode ? ThemeData.dark() : ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('7.3 Theme 主题'),
          actions: [
            // 切换深色模式
            IconButton(
              icon: Icon(_darkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() => _darkMode = !_darkMode);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 获取当前主题数据
              const Text('1. 获取当前主题数据',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              // 使用 Theme.of(context) 获取主题
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.palette, color: Theme.of(context).colorScheme.onPrimaryContainer),
                    const SizedBox(width: 8),
                    Text(
                      '当前是 ${_darkMode ? "深色" : "浅色"} 模式',
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. 使用主题样式的组件
              const Text('2. 使用主题样式的组件',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Headline Medium',
                          style: Theme.of(context).textTheme.headlineMedium),
                      Text('Title Large',
                          style: Theme.of(context).textTheme.titleLarge),
                      Text('Body Medium',
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text('Label Small',
                          style: Theme.of(context).textTheme.labelSmall),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Icon(Icons.favorite, color: Theme.of(context).colorScheme.error),
                          const SizedBox(width: 8),
                          Icon(Icons.thumb_up, color: Theme.of(context).colorScheme.tertiary),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. 局部主题覆盖（Theme + copyWith）
              const Text('3. Theme + copyWith 局部主题覆盖',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text('默认主题', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Icon(Icons.star, size: 32),
                            Text('默认 Icon 样式'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Theme(
                      // 使用 copyWith 局部修改主题
                      data: Theme.of(context).copyWith(
                        iconTheme: const IconThemeData(
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                      child: const Card(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text('局部蓝色主题',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Icon(Icons.star, size: 32),
                              Text('蓝色 Icon'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('切换局部蓝色 Icon 主题'),
                value: _localBlue,
                onChanged: (val) {
                  setState(() => _localBlue = val);
                },
              ),
              const SizedBox(height: 16),

              // 4. ThemeData 常用属性说明
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '💡 ThemeData 常用属性：\n'
                  '• primaryColor - 主色\n'
                  '• colorScheme - 颜色方案\n'
                  '• brightness - 亮度模式\n'
                  '• textTheme - 文本主题\n'
                  '• iconTheme - 图标主题\n'
                  '• appBarTheme - AppBar 主题\n'
                  '• cardTheme - 卡片主题\n'
                  '• buttonTheme - 按钮主题\n'
                  '• inputDecorationTheme - 输入框装饰主题\n\n'
                  '使用 copyWith() 可以在不改变全局主题\n的前提下临时修改局部样式。',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
