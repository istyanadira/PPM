import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/plant_schedule_repository.dart';
import '../../domain/models/plant_schedule.dart';
import '../core/app_theme.dart';
import '../core/category_badge.dart';
import 'schedule_view_model.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScheduleViewModel>(
      create: (context) => ScheduleViewModel(
        scheduleRepository: context.read<PlantScheduleRepository>(),
      )..load(),
      child: const _ScheduleView(),
    );
  }
}

class _ScheduleView extends StatelessWidget {
  const _ScheduleView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ScheduleViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          0,
        ),
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Jadwal Perawatan', style: textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Pilih kategori untuk melihat jadwalnya.',
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.sage),
                ),
                const SizedBox(height: AppSpacing.md),
                _CategorySelector(viewModel: viewModel),
                const SizedBox(height: AppSpacing.md),
                Expanded(child: _ScheduleBody(viewModel: viewModel)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector({required this.viewModel});

  final ScheduleViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<ScheduleCategory>(
        showSelectedIcon: false,
        segments: ScheduleCategory.values
            .map(
              (category) => ButtonSegment<ScheduleCategory>(
                value: category,
                icon: Icon(category.icon, size: 18),
                label: Text(category.label),
              ),
            )
            .toList(),
        selected: {viewModel.selectedCategory},
        onSelectionChanged: (selection) {
          viewModel.selectCategory(selection.first);
        },
        style: SegmentedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.sage,
          selectedBackgroundColor: AppColors.lightGreen,
          selectedForegroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.lightGreen),
        ),
      ),
    );
  }
}

class _ScheduleBody extends StatelessWidget {
  const _ScheduleBody({required this.viewModel});

  final ScheduleViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null) {
      return _ErrorState(
        message: viewModel.error!,
        onRetry: viewModel.load,
      );
    }

    final schedules = viewModel.schedules;
    if (schedules.isEmpty) {
      return Center(
        child: Text(
          'Belum ada jadwal untuk kategori ini.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.sage),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      itemCount: schedules.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        return _ScheduleCard(schedule: schedules[index]);
      },
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.schedule});

  final PlantSchedule schedule;

  /// "Hari ini", "Besok", atau tanggal lengkap berbahasa Indonesia.
  String _dateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) return 'Hari ini';
    if (diff == 1) return 'Besok';
    return DateFormat('EEEE, d MMM y', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                        schedule.plantName,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.sage,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(schedule.description, style: textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(
                  Icons.event_rounded,
                  size: 16,
                  color: AppColors.sage,
                ),
                const SizedBox(width: 6),
                Text(
                  _dateLabel(schedule.date),
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                CategoryBadge(category: schedule.category),
              ],
            ),
          ],
        ),
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
    );
  }
}