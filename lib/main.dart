import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'providers/auth_provider.dart';
import 'providers/account_provider.dart';
import 'providers/transfer_provider.dart';
import 'providers/fee_provider.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/account_service.dart';
import 'services/transfer_service.dart';
import 'services/fee_service.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/transfer_screen.dart';
import 'screens/fees_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const BankMoreApp());
}

class BankMoreApp extends StatelessWidget {
  const BankMoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    const storage = FlutterSecureStorage();
    final apiService = ApiService();
    final authService = AuthService(apiService, storage);
    final accountService = AccountService(apiService);
    final transferService = TransferService(apiService);
    final feeService = FeeService(apiService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService),
        ),
        ChangeNotifierProvider(
          create: (_) => AccountProvider(accountService),
        ),
        ChangeNotifierProvider(
          create: (_) => TransferProvider(transferService),
        ),
        ChangeNotifierProvider(
          create: (_) => FeeProvider(feeService),
        ),
      ],
      child: MaterialApp(
        title: 'BankMore',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/transfer': (context) => const TransferScreen(),
          '/fees': (context) => const FeesScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
