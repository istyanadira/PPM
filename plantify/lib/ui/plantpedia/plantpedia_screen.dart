import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/plant_info_repository.dart';
import '../../domain/models/plant_info.dart';
import '../core/app_theme.dart';
import 'plantpedia_view_model.dart';

class PlantpediaScreen extends StatelessWidget {
  const PlantpediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlantpediaViewModel>(
      create: (context) => PlantpediaViewModel(
        infoRepository: context.read<PlantInfoRepository>(),
      )..load(),
      child: const _PlantpediaView(),
    );
  }
}

class _PlantpediaView extends StatelessWidget {
  const _PlantpediaView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<PlantpediaViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Plantpedia', style: textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Pusat pengetahuan perawatan tanaman.',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.sage),
            ),
            const SizedBox(height: AppSpacing.md),
            SearchBar(
              hintText: 'Cari judul artikel...',
              leading: const Icon(Icons.search_rounded),
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: const WidgetStatePropertyAll(Colors.white),
              side: const WidgetStatePropertyAll(
                BorderSide(color: AppColors.lightGreen),
              ),
              onChanged: viewModel.search,
            ),
            const SizedBox(height: AppSpacing.sm),
            ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) => _CategoryFilter(viewModel: viewModel),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) => _Body(viewModel: viewModel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({required this.viewModel});

  final PlantpediaViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.xs,
        children: [
          ChoiceChip(
            label: const Text('Semua'),
            selected: viewModel.selectedCategory == null,
            onSelected: (_) => viewModel.selectCategory(null),
          ),
          ...InfoCategory.values.map(
            (category) => ChoiceChip(
              label: Text(category.label),
              selected: viewModel.selectedCategory == category,
              onSelected: (_) => viewModel.selectCategory(category),
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.viewModel});

  final PlantpediaViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.sage),
            const SizedBox(height: AppSpacing.md),
            Text(viewModel.error!, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: viewModel.load,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    final infos = viewModel.infos;
    if (infos.isEmpty) {
      return Center(
        child: Text(
          'Artikel tidak ditemukan.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.sage),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      itemCount: infos.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) => _InfoCard(info: infos[index]),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.info});

  final PlantInfo info;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => PlantInfoDetailScreen(info: info),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                ),
                child: const Icon(
                  Icons.local_florist_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.category.label,
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColors.sage,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(info.title, style: textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      info.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.sage),
            ],
          ),
        ),
      ),
    );
  }
}

/// Halaman detail artikel Plantpedia.
class PlantInfoDetailScreen extends StatelessWidget {
  const PlantInfoDetailScreen({super.key, required this.info});

  final PlantInfo info;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Artikel')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text(info.category.label),
                backgroundColor: AppColors.lightGreen,
                side: BorderSide.none,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(info.title, style: textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              info.description,
              style: textTheme.bodyLarge?.copyWith(color: AppColors.sage),
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.lightGreen),
            const SizedBox(height: AppSpacing.md),
            Text(
              info.content,
              style: textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}