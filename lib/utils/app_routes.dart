import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/edit_profile_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const editProfile = '/edit_profile';

  static final routes = <String, WidgetBuilder>{
    splash: (_) => SplashScreen(),
    login: (_) => LoginScreen(),
    register: (_) => RegisterScreen(),
    home: (_) => HomeScreen(),
    editProfile: (_) => EditProfileScreen(),
  };
}
