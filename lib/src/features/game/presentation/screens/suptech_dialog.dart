import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';

class SupTechDialog extends StatelessWidget {
  const SupTechDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: BlocBuilder<GameCubit, GameState>(
        builder: (_, state) {
           return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: scheme.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              const Gap(16),
              Row(
                children: [
                  Text(
                    'SupTech',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: scheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${state.availableSupTechUses} left',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: scheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(4),
              Text(
                'Pick an action to help with this step',
                style: TextStyle(
                  fontSize: 13,
                  color: scheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const Gap(20),
              _ActionButton(
                icon: Icons.lightbulb_outline,
                label: 'Hint',
                description: 'Get a helpful tip',
                color: scheme.tertiary,
                onTap: () => _useAction(context, 'hint'),
              ),
              const Gap(10),
              _ActionButton(
                icon: Icons.skip_next,
                label: 'Skip Step',
                description: 'Auto-solve this step',
                color: scheme.error,
                onTap: () => _useAction(context, 'skip'),
              ),
              const Gap(10),
              _ActionButton(
                icon: Icons.quiz_outlined,
                label: 'Diagnose',
                description: 'Ask guided questions',
                color: scheme.secondary,
                onTap: () => _useAction(context, 'diagnose'),
              ),
              const Gap(10),
              _ActionButton(
                icon: Icons.description_outlined,
                label: 'Explain',
                description: 'Simple explanation of this step',
                color: scheme.primary,
                onTap: () => _useAction(context, 'explain'),
              ),
              const Gap(12),
            ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _useAction(BuildContext context, String action) {
    context.read<GameCubit>().useSupTech(action);
    Navigator.pop(context);
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: color.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: color.withValues(alpha: 0.15)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: scheme.onSurface,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
