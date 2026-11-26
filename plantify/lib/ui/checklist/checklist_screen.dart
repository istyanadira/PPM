import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/plant_task_repository.dart';
import '../../domain/models/plant_task.dart';
import '../core/app_theme.dart';
import 'checklist_view_model.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChecklistViewModel>(
      create: (context) => ChecklistViewModel(
        taskRepository: context.read<PlantTaskRepository>(),
      )..load(),
      child: const _ChecklistView(),
    );
  }
}

class _ChecklistView extends StatelessWidget {
  const _ChecklistView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ChecklistViewModel>();

    return SafeArea(
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.error != null) {
            return _ErrorState(
              message: viewModel.error!,
              onRetry: viewModel.load,
            );
          }
          return _ChecklistContent(viewModel: viewModel);
        },
      ),
    );
  }
}

class _ChecklistContent extends StatelessWidget {
  const _ChecklistContent({required this.viewModel});

  final ChecklistViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pending = viewModel.pendingTasks;
    final completed = viewModel.completedTasks;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('Checklist Perawatan', style: textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Centang tugas yang sudah kamu kerjakan.',
          style: textTheme.bodyMedium?.copyWith(color: AppColors.sage),
        ),
        const SizedBox(height: AppSpacing.lg),
        _SectionTitle(title: 'Belum Selesai (${pending.length})'),
        const SizedBox(height: AppSpacing.sm),
        if (pending.isEmpty)
          const _EmptyText('Hebat! Semua tugas sudah selesai. 🎉')
        else
          ...pending.map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _TaskCheckTile(task: task, viewModel: viewModel),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        _SectionTitle(title: 'Sudah Selesai (${completed.length})'),
        const SizedBox(height: AppSpacing.sm),
        if (completed.isEmpty)
          const _EmptyText('Belum ada tugas yang selesai.')
        else
          ...completed.map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _TaskCheckTile(task: task, viewModel: viewModel),
            ),
          ),
      ],
    );
  }
}

class _TaskCheckTile extends StatelessWidget {
  const _TaskCheckTile({required this.task, required this.viewModel});

  final PlantTask task;
  final ChecklistViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final done = task.isCompleted;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: CheckboxListTile(
        value: done,
        onChanged: (value) {
          viewModel.setTaskCompleted(task.id, value ?? false);
        },
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        title: Text(
          task.title,
          style: textTheme.titleSmall?.copyWith(
            decoration: done ? TextDecoration.lineThrough : null,
            color: done ? AppColors.sage : AppColors.darkText,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            '${task.plantName} • ${task.description}',
            style: textTheme.bodySmall?.copyWith(
              color: done ? AppColors.sage : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }
}

class _EmptyText extends StatelessWidget {
  const _EmptyText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: AppColors.sage),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.sage),
            const SizedBox(height: AppSpacing.md),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            FilledButton(onPressed: onRetry, child: const Text('Coba Lagi')),
          ],
        ),
      ),
    );
  }
}