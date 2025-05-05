import 'package:flutter/material.dart';
import 'package:moneymate/pages/dashboard.dart';
import 'package:moneymate/theme/theme_cubit.dart';
import 'package:moneymate/theme/theme_localstorage.dart';
import 'package:moneymate/injector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

// import 'package:flutter_app/Tugas_1/register.dart'; // Import halaman register
// import 'package:flutter_app/Tugas_1/login.dart'; // Import halaman login
// import 'package:flutter_app/day-3/home.dart';

// Removed unused import
// Removed unused import
final getIt = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjector();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
   Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(
            ThemeLocalStorage(
              getIt<SharedPreferences>(),
            ),
          )..init(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Demo',
            themeMode: state,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            // routes: routes,
            // initialRoute: AppRoutes.home,
           home: const DashboardPage(transactions: [],),
            
          );
        }
      ),
      // initialRoute: '/login', // Halaman awal adalah login
      // routes: {
      //   '/login': (context) => const Login(title: 'Login'), // Halaman login
      //   '/register': (context) => const Register(title: 'Register'), // Halaman register
      //   '/home': (context) => const Homepage(title: 'Home'), // Halaman home
      // },
    );
  }
}

