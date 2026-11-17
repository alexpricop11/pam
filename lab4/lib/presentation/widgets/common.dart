import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/learning_cubit.dart';
import '../theme/app_theme.dart';

class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    heightFactor: 1,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: child,
    ),
  );
}

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.color = Colors.white,
  });
  final Widget child;
  final Color color;
  @override
  Widget build(BuildContext context) => Card(
    color: color,
    elevation: 0,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(padding: const EdgeInsets.all(20), child: child),
  );
}

class StatusMessage extends StatelessWidget {
  const StatusMessage({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.action,
    this.onAction,
  });
  final String title, message;
  final IconData icon;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 44, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          if (onAction != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: OutlinedButton(onPressed: onAction, child: Text(action!)),
            ),
        ],
      ),
    ),
  );
}

class LoadGate extends StatelessWidget {
  const LoadGate({super.key, required this.state, required this.child});
  final LearningState state;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    if (state.status == LoadStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(
          semanticsLabel: 'Loading learning data',
        ),
      );
    }
    if (state.status == LoadStatus.error) {
      return StatusMessage(
        title: 'Something went wrong',
        message: state.error!,
        icon: Icons.cloud_off_outlined,
        action: 'Try again',
        onAction: context.read<LearningCubit>().load,
      );
    }
    return child;
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.id});
  final String id;
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<LearningCubit, LearningState>(
        builder: (context, state) => IconButton(
          tooltip: state.favorites.contains(id)
              ? 'Remove from favorites'
              : 'Add to favorites',
          onPressed: () => context.read<LearningCubit>().toggleFavorite(id),
          icon: Icon(
            state.favorites.contains(id)
                ? Icons.bookmark
                : Icons.bookmark_border,
            color: AppColors.primary,
          ),
        ),
      );
}
