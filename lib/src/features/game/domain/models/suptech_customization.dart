import '../../constants/skin_tiers.dart';

class SupTechCustomization {
  final SupTechExpression? expression;
  final SupTechHeadAccessory? headAccessory;
  final SupTechEarAccessory? earAccessory;
  final SupTechChestAccessory? chestAccessory;
  final SupTechPose? pose;

  const SupTechCustomization({
    this.expression,
    this.headAccessory,
    this.earAccessory,
    this.chestAccessory,
    this.pose,
  });

  bool get isEmpty =>
      expression == null &&
      headAccessory == null &&
      earAccessory == null &&
      chestAccessory == null &&
      pose == null;

  SupTechCustomization copyWith({
    Object? expression = _sentinel,
    Object? headAccessory = _sentinel,
    Object? earAccessory = _sentinel,
    Object? chestAccessory = _sentinel,
    Object? pose = _sentinel,
    bool clearExpression = false,
    bool clearHeadAccessory = false,
    bool clearEarAccessory = false,
    bool clearChestAccessory = false,
    bool clearPose = false,
  }) {
    return SupTechCustomization(
      expression: clearExpression
          ? null
          : (expression == _sentinel ? this.expression : expression as SupTechExpression?),
      headAccessory: clearHeadAccessory
          ? null
          : (headAccessory == _sentinel
              ? this.headAccessory
              : headAccessory as SupTechHeadAccessory?),
      earAccessory: clearEarAccessory
          ? null
          : (earAccessory == _sentinel
              ? this.earAccessory
              : earAccessory as SupTechEarAccessory?),
      chestAccessory: clearChestAccessory
          ? null
          : (chestAccessory == _sentinel
              ? this.chestAccessory
              : chestAccessory as SupTechChestAccessory?),
      pose: clearPose
          ? null
          : (pose == _sentinel ? this.pose : pose as SupTechPose?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (expression != null) 'expression': expression!.name,
      if (headAccessory != null) 'headAccessory': headAccessory!.name,
      if (earAccessory != null) 'earAccessory': earAccessory!.name,
      if (chestAccessory != null) 'chestAccessory': chestAccessory!.name,
      if (pose != null) 'pose': pose!.name,
    };
  }

  factory SupTechCustomization.fromJson(Map<String, dynamic> json) {
    return SupTechCustomization(
      expression: json['expression'] != null
          ? SupTechExpression.values.firstWhere(
              (e) => e.name == json['expression'],
              orElse: () => SupTechExpression.neutral,
            )
          : null,
      headAccessory: json['headAccessory'] != null
          ? SupTechHeadAccessory.values.firstWhere(
              (e) => e.name == json['headAccessory'],
              orElse: () => SupTechHeadAccessory.none,
            )
          : null,
      earAccessory: json['earAccessory'] != null
          ? SupTechEarAccessory.values.firstWhere(
              (e) => e.name == json['earAccessory'],
              orElse: () => SupTechEarAccessory.none,
            )
          : null,
      chestAccessory: json['chestAccessory'] != null
          ? SupTechChestAccessory.values.firstWhere(
              (e) => e.name == json['chestAccessory'],
              orElse: () => SupTechChestAccessory.none,
            )
          : null,
      pose: json['pose'] != null
          ? SupTechPose.values.firstWhere(
              (e) => e.name == json['pose'],
              orElse: () => SupTechPose.none,
            )
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupTechCustomization &&
          runtimeType == other.runtimeType &&
          expression == other.expression &&
          headAccessory == other.headAccessory &&
          earAccessory == other.earAccessory &&
          chestAccessory == other.chestAccessory &&
          pose == other.pose;

  @override
  int get hashCode => Object.hash(
        expression,
        headAccessory,
        earAccessory,
        chestAccessory,
        pose,
      );
}

const _sentinel = Object();
