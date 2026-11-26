import 'package:flutter/material.dart';

import '../../domain/models/plant_schedule.dart';
import 'app_theme.dart';

/// Ikon dan warna untuk tiap kategori jadwal.
extension ScheduleCategoryStyle on ScheduleCategory {
  IconData get icon {
    switch (this) {
      case ScheduleCategory.watering:
        return Icons.water_drop_rounded;
      case ScheduleCategory.fertilizing:
        return Icons.eco_rounded;
      case ScheduleCategory.maintenance:
        return Icons.content_cut_rounded;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ScheduleCategory.watering:
        return AppColors.water;
      case ScheduleCategory.fertilizing:
        return AppColors.fertilizer;
      case ScheduleCategory.maintenance:
        return AppColors.maintenance;
    }
  }

  Color get foregroundColor {
    switch (this) {
      case ScheduleCategory.watering:
        return AppColors.waterText;
      case ScheduleCategory.fertilizing:
        return AppColors.fertilizerText;
      case ScheduleCategory.maintenance:
        return AppColors.maintenanceText;
    }
  }
}

/// Badge kategori berwarna lembut.
class CategoryBadge extends StatelessWidget {
  const CategoryBadge({super.key, required this.category});

  final ScheduleCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: category.backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 14, color: category.foregroundColor),
          const SizedBox(width: 4),
          Text(
            category.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: category.foregroundColor,
                ),
          ),
        ],
      ),
    );
  }
}