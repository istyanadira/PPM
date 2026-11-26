import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/plant_schedule_repository.dart';
import '../../data/repositories/plant_task_repository.dart';
import '../../domain/models/plant_schedule.dart';
import '../../domain/models/plant_task.dart';
import '../core/app_theme.dart';
import '../core/category_badge.dart';
import 'home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(
        scheduleRepository: context.read<PlantScheduleRepository>(),
        taskRepository: context.read<PlantTaskRepository>(),
      )..load(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<HomeViewModel>();

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
          return _HomeContent(viewModel: viewModel);
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dateText =
        DateFormat('EEEE, d MMMM y', 'id_ID').format(viewModel.today);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('Halo, Pecinta Tanaman 🌿', style: textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          dateText,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.sage),
        ),
        const SizedBox(height: AppSpacing.lg),
        _SummaryCard(viewModel: viewModel),
        const SizedBox(height: AppSpacing.lg),
        _SectionTitle(title: 'Jadwal Hari Ini'),
        const SizedBox(height: AppSpacing.sm),
        if (viewModel.todaySchedules.isEmpty)
          const _EmptyText('Tidak ada jadwal perawatan hari ini.')
        else
          ...viewModel.todaySchedules.map(
            (schedule) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _ScheduleTile(schedule: schedule),
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        _SectionTitle(title: 'Checklist Belum Selesai'),
        const SizedBox(height: AppSpacing.sm),
        if (viewModel.pendingTasks.isEmpty)
          const _EmptyText('Hebat! Semua tugas sudah selesai. 🎉')
        else
          ...viewModel.pendingTasks.map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _TaskTile(task: task),
            ),
          ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final total = viewModel.totalTaskCount;
    final done = viewModel.completedCount;
    final progress = total == 0 ? 0.0 : done / total;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Hari Ini',
            style: textTheme.labelLarge?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _SummaryNumber(
                  value: '${viewModel.todaySchedules.length}',
                  label: 'Jadwal hari ini',
                ),
              ),
              Expanded(
                child: _SummaryNumber(
                  value: '$done/$total',
                  label: 'Tugas selesai',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.lightGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryNumber extends StatelessWidget {
  const _SummaryNumber({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: textTheme.headlineMedium?.copyWith(color: Colors.white),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: Colors.white70),
        ),
      ],
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

class _ScheduleTile extends StatelessWidget {
  const _ScheduleTile({required this.schedule});

  final PlantSchedule schedule;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: schedule.category.backgroundColor,
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
              child: Icon(
                schedule.category.icon,
                color: schedule.category.foregroundColor,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(schedule.activity, style: textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    schedule.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task});

  final PlantTask task;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            const Icon(Icons.radio_button_unchecked, color: AppColors.sage),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(task.plantName, style: textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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