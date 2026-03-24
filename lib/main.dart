import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/service_locator.dart' as di;
import 'auth/presentation/bloc/auth_bloc.dart';
import 'auth/presentation/screens/login_screen.dart';
import 'deals/presentation/bloc/deal_list/deal_list_bloc.dart';
import 'deals/presentation/screens/deal_list_screen.dart';
import 'deals/presentation/screens/my_interests_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()..add(AppStarted())),
        BlocProvider(create: (_) => di.sl<DealListBloc>()),
      ],
      child: MaterialApp(
        title: 'Investor Deal App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const DealListScreen();
            } else if (state is AuthUnauthenticated || state is AuthError) {
              return const LoginScreen();
            }
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        ),
        routes: {
          '/my-interests': (context) => const MyInterestsScreen(),
        },
      ),
    );
  }
}
