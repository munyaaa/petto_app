import 'package:flutter/material.dart';
import 'package:petto_app/dependency_injection.dart';
import 'package:petto_app/pages/home/home_page.dart';
import 'package:petto_app/pages/login/login_page.dart';
import 'package:petto_app/pages/main/main_view_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainViewModel _viewModel = DependencyInjection.container.resolve();

  @override
  Widget build(BuildContext context) {
    return _viewModel.isLogin() ? const HomePage() : const LoginPage();
  }
}
