import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littletech/src/features/home/data/counter_service.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0) {
    _load();
  }

  Future<void> _load() async {
    emit(await CounterService.load());
  }

  Future<void> increment() async {
    final v = state + 1;
    emit(v);
    await CounterService.save(v);
  }

  Future<void> decrement() async {
    if (state > 0) {
      final v = state - 1;
      emit(v);
      await CounterService.save(v);
    }
  }
}
