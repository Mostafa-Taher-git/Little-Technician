import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:littletech/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:littletech/src/features/home/presentation/bloc/counter_cubit.dart';
import 'package:littletech/src/features/splash/presentation/screens/splash_screen.dart';
import 'package:littletech/src/features/game/data/repositories/game_repository.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/domain/cubit/theme_cubit.dart';

class LittleTechApp extends StatelessWidget {
  final Isar isar;

  const LittleTechApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    final repository = GameRepository(isar);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => CounterCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => GameCubit(repository, 1)),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (_, theme) {
          return MaterialApp(
            title: 'LittleTech',
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
