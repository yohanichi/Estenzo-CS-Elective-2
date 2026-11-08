import 'package:cs_elective_2/components/provider_form.dart';
import 'package:cs_elective_2/components/provider_home.dart';
import 'package:flutter/material.dart';

class ProviderDemo extends StatefulWidget {
  const ProviderDemo({super.key});

  @override
  State<ProviderDemo> createState() => _ProviderDemoState();
}

class _ProviderDemoState extends State<ProviderDemo> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Provider Demo'),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Home'),
              Tab(text: 'Form'),
            ],
          ),
        ),
        body: TabBarView(children: [ProviderHome(), ProviderForm()]),
      ),
    );
  }
}
