import 'package:flutter/material.dart';

class LendPage extends StatefulWidget {
  const LendPage({super.key});

  @override
  State<LendPage> createState() => _LendPageState();
}

class _LendPageState extends State<LendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lend'),
      ),
      body: const Center(
        child: Text('Lista de livros disponíveis para empréstimo'),
      ),
    );
  }
}
