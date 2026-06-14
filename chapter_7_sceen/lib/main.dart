import 'package:flutter/material.dart';
import 'demos.dart';

void main() => runApp(const Chapter7Screen());

class Chapter7Screen extends StatelessWidget {
  const Chapter7Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ch7 功能型组件',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const Chapter7Home(),
    );
  }
}

class Chapter7Home extends StatelessWidget {
  const Chapter7Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('第7章 功能型组件 — 全部示例'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: chapter7Demos.length,
        separatorBuilder: (_, __) => const Divider(indent: 72),
        itemBuilder: (context, index) {
          final demo = chapter7Demos[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal.shade50,
              child: Icon(demo.icon, color: Colors.teal),
            ),
            title: Text(demo.title, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(demo.subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => demo.page)),
          );
        },
      ),
    );
  }
}
