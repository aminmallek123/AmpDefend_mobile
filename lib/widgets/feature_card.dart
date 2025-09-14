import 'package:flutter/material.dart';
import '../models/feature.dart';

class FeatureCard extends StatelessWidget {
  final Feature feature;
  final VoidCallback? onTap;
  final bool isHighlighted;

  const FeatureCard({
    super.key,
    required this.feature,
    this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isHighlighted ? 8 : 4,
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isHighlighted
                ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      Colors.transparent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getIconFromPath(feature.iconPath),
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          feature.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          feature.category,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isHighlighted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'FEATURED',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        feature.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.4,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: feature.benefits.take(2).map((benefit) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              benefit,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconFromPath(String path) {
    // Map icon paths to Material Icons
    switch (path) {
      case 'assets/icons/shield.svg':
        return Icons.shield;
      case 'assets/icons/alert.svg':
        return Icons.notifications_active;
      case 'assets/icons/analytics.svg':
        return Icons.analytics;
      case 'assets/icons/deploy.svg':
        return Icons.rocket_launch;
      case 'assets/icons/intelligence.svg':
        return Icons.psychology;
      case 'assets/icons/api.svg':
        return Icons.api;
      default:
        return Icons.help_outline;
    }
  }
}