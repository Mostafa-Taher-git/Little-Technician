import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:littletech/src/features/auth/data/services/auth_service.dart';
import 'package:littletech/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:littletech/src/features/auth/presentation/screens/login_screen.dart';
import 'package:littletech/src/features/home/presentation/bloc/counter_cubit.dart';
import 'package:littletech/src/features/home/presentation/screens/home_screen.dart';
import 'package:littletech/src/features/splash/presentation/screens/splash_screen.dart';
import 'package:littletech/src/features/game/data/repositories/game_repository.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/domain/cubit/theme_cubit.dart';

class LittleTechApp extends StatefulWidget {
  final Isar isar;

  const LittleTechApp({super.key, required this.isar});

  @override
  State<LittleTechApp> createState() => _LittleTechAppState();
}

class _LittleTechAppState extends State<LittleTechApp> {
  int? _userId;
  final _navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final userId = await AuthService.getFreshUserId();
    if (mounted) {
      setState(() => _userId = userId);
    }
  }

  void _onAuthChanged() {
    _loadUserId().then((_) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final nav = _navKey.currentState;
        if (nav == null) return;
        if (_userId != null) {
          nav.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (_) => false,
          );
        } else {
          nav.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (_) => false,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        if (_userId != null)
          BlocProvider(
            key: ValueKey('counter_$_userId'),
            create: (_) => CounterCubit(),
          ),
        BlocProvider(create: (_) => ThemeCubit()),
        if (_userId != null)
          BlocProvider(
            key: ValueKey('game_$_userId'),
            create: (_) => GameCubit(GameRepository(widget.isar), _userId!)..loadGame(),
          ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listener: (_, state) {
              if (state is LoginSuccess || state is RegisterSuccess || state is LogoutSuccess) {
                _onAuthChanged();
              }
            },
          ),
          if (_userId != null)
            BlocListener<GameCubit, GameState>(
              listenWhen: (prev, curr) =>
                  prev.progress.themeId != curr.progress.themeId ||
                  (prev.progress.userId != curr.progress.userId),
              listener: (context, state) {
                final themeId = state.progress.themeId;
                if (themeId != null) {
                  context.read<ThemeCubit>().applyTheme(themeId);
                } else {
                  context.read<ThemeCubit>().resetToDefault();
                }
              },
            ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeData>(
          builder: (_, theme) => MaterialApp(
            navigatorKey: _navKey,
            title: 'LittleTech',
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: const SplashScreen(),
          ),
        ),
      ),
    );
  }
}
