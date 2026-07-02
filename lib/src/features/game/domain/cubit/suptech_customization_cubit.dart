import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littletech/src/features/game/constants/skin_tiers.dart';
import 'package:littletech/src/features/game/data/services/suptech_customization_service.dart';
import 'package:littletech/src/features/game/domain/models/suptech_customization.dart';

class SupTechCustomizationCubit extends Cubit<SupTechCustomization> {
  SupTechCustomizationCubit() : super(const SupTechCustomization()) {
    _load();
  }

  Future<void> _load() async {
    emit(await SupTechCustomizationService.load());
  }

  Future<void> setExpression(SupTechExpression? value) async {
    final next = state.copyWith(expression: value);
    emit(next);
    await SupTechCustomizationService.save(next);
  }

  Future<void> setHeadAccessory(SupTechHeadAccessory? value) async {
    final next = state.copyWith(headAccessory: value);
    emit(next);
    await SupTechCustomizationService.save(next);
  }

  Future<void> setEarAccessory(SupTechEarAccessory? value) async {
    final next = state.copyWith(earAccessory: value);
    emit(next);
    await SupTechCustomizationService.save(next);
  }

  Future<void> setChestAccessory(SupTechChestAccessory? value) async {
    final next = state.copyWith(chestAccessory: value);
    emit(next);
    await SupTechCustomizationService.save(next);
  }

  Future<void> setPose(SupTechPose? value) async {
    final next = state.copyWith(pose: value);
    emit(next);
    await SupTechCustomizationService.save(next);
  }

  Future<void> reset() async {
    emit(const SupTechCustomization());
    await SupTechCustomizationService.save(const SupTechCustomization());
  }
}
