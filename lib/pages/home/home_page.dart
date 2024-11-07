import 'package:flutter/material.dart';
import 'package:petto_app/dependency_injection.dart';
import 'package:petto_app/pages/authentication/authentication_page.dart';
import 'package:petto_app/pages/home/home_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeViewModel _viewModel = DependencyInjection.container.resolve();

  @override
  void initState() {
    super.initState();
    _viewModel.logoutState.listen(
      (value) {
        if (value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const AuthenticationPage();
              },
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _viewModel.logoutState.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              _viewModel.logout();
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
    );
  }
}
