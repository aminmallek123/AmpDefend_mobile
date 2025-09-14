import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/feature.dart';
import '../../services/mock_data.dart';

class FeaturesPage extends StatefulWidget {
  const FeaturesPage({super.key});

  @override
  State<FeaturesPage> createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage> {
  String _selectedCategory = 'All';
  
  List<String> get categories {
    final cats = ['All'] + MockData.features.map((f) => f.category).toSet().toList();
    return cats;
  }
  
  List<Feature> get filteredFeatures {
    if (_selectedCategory == 'All') {
      return MockData.features;
    }
    return MockData.features.where((f) => f.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Fonctionnalités',
        showBackButton: true,
      ),
      body: Column(
        children: [
          _buildHeroSection(context),
          _buildCategoryFilter(context),
          Expanded(
            child: _buildFeaturesList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.security,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Fonctionnalités Avancées',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Découvrez toutes les capacités d\'AMPDefend pour protéger votre infrastructure',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            final isSelected = category == _selectedCategory;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                backgroundColor: Colors.transparent,
                selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                checkmarkColor: Theme.of(context).colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredFeatures.length,
      itemBuilder: (context, index) {
        final feature = filteredFeatures[index];
        return _buildExpandableFeatureCard(context, feature);
      },
    );
  }

  Widget _buildExpandableFeatureCard(BuildContext context, Feature feature) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ExpandablePanel(
        theme: const ExpandableThemeData(
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          tapBodyToCollapse: true,
          tapHeaderToExpand: true,
          hasIcon: true,
        ),
        header: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconFromPath(feature.iconPath),
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            feature.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (feature.isHighlighted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8, 
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'POPULAIRE',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      feature.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      feature.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        collapsed: Container(),
        
        expanded: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              
              const SizedBox(height: 16),
              
              Text(
                'Avantages Clés',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 12),
              
              ...feature.benefits.map((benefit) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      Expanded(
                        child: Text(
                          benefit,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showFeatureDetails(context, feature);
                      },
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Plus de détails'),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.go('/contact');
                      },
                      icon: const Icon(Icons.contact_mail),
                      label: const Text('Nous contacter'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFeatureDetails(BuildContext context, Feature feature) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                _getIconFromPath(feature.iconPath),
                                color: Theme.of(context).colorScheme.primary,
                                size: 32,
                              ),
                            ),
                            
                            const SizedBox(width: 16),
                            
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    feature.title,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  
                                  Text(
                                    feature.category,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        Text(
                          feature.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        Text(
                          'Avantages Détaillés',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        ...feature.benefits.map((benefit) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                                
                                const SizedBox(width: 12),
                                
                                Expanded(
                                  child: Text(
                                    benefit,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        
                        const SizedBox(height: 32),
                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.go('/contact');
                            },
                            icon: const Icon(Icons.rocket_launch),
                            label: const Text('Demander une démo'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getIconFromPath(String path) {
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