import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../models/alert.dart';
import '../../models/alert_statistics.dart';
import '../../services/alert_service.dart';
import '../../services/auth_service.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = '7d'; // 1d, 7d, 30d, all

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Statistiques Sécurité'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/dashboard');
            },
            tooltip: 'Retour au Dashboard',
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  _handleLogout();
                } else {
                  setState(() {
                    _selectedPeriod = value;
                  });
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: '1d', child: Text('Dernières 24h')),
                const PopupMenuItem(value: '7d', child: Text('7 derniers jours')),
                const PopupMenuItem(value: '30d', child: Text('30 derniers jours')),
                const PopupMenuItem(value: 'all', child: Text('Toutes les données')),
                const PopupMenuItem(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Déconnexion'),
                  ),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_getPeriodLabel()),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.analytics), text: 'Vue d\'ensemble'),
              Tab(icon: Icon(Icons.pie_chart), text: 'Répartition'),
              Tab(icon: Icon(Icons.timeline), text: 'Tendances'),
              Tab(icon: Icon(Icons.map), text: 'Géographie'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildDistributionTab(),
            _buildTrendsTab(),
            _buildGeographyTab(),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    try {
      await AuthService.signOut();
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la déconnexion: $e')),
        );
      }
    }
  }

  String _getPeriodLabel() {
    switch (_selectedPeriod) {
      case '1d':
        return '24h';
      case '7d':
        return '7j';
      case '30d':
        return '30j';
      case 'all':
        return 'Tout';
      default:
        return '7j';
    }
  }

  Widget _buildOverviewTab() {
    return StreamBuilder<AlertStatistics>(
      stream: AlertService.getAlertStatistics(),
      builder: (context, snapshot) {
        print('🔍 DEBUG UI: État du snapshot: ${snapshot.connectionState}');
        print('🔍 DEBUG UI: A des données: ${snapshot.hasData}');
        print('🔍 DEBUG UI: A une erreur: ${snapshot.hasError}');
        if (snapshot.hasError) {
          print('🔍 DEBUG UI: Erreur: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          print('🔍 DEBUG UI: Total alertes reçues: ${snapshot.data!.total}');
        }

        // Afficher directement les données si disponibles, même en cours de chargement
        if (snapshot.hasData) {
          final stats = snapshot.data!;
          return _buildStatsContent(stats);
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur de chargement',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        }

        // Gestion de l'absence de données
        final stats = snapshot.data;
        if (stats == null || stats.total == 0) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune donnée disponible',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Les statistiques apparaîtront une fois que des alertes seront reçues',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => setState(() {}),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Recharger'),
                  ),
                ],
              ),
            ),
          );
        }

        // Afficher les statistiques
        return _buildStatsContent(stats);
      },
    );
  }

  Widget _buildSummaryCards(AlertStatistics stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3, // Légèrement plus d'espace vertical
      children: [
        _buildMetricCard(
          'Total Alertes',
          '${stats.total}',
          Icons.notifications,
          Colors.blue,
          subtitle: 'Toutes périodes',
        ),
        _buildMetricCard(
          'Dernières 24h',
          '${stats.last24Hours}',
          Icons.access_time,
          Colors.orange,
          subtitle: _getGrowthText(stats.last24Hours),
        ),
        _buildMetricCard(
          'Niveau Critique',
          '${stats.critical}',
          Icons.error,
          Colors.red,
          subtitle: '${stats.criticalPercentage.toStringAsFixed(1)}%',
        ),
        _buildMetricCard(
          'Niveau Élevé',
          '${stats.high}',
          Icons.warning,
          Colors.orange,
          subtitle: '${stats.highPercentage.toStringAsFixed(1)}%',
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, {String? subtitle}) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityChart(AlertStatistics stats) {
    if (stats.total == 0) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Aucune donnée pour le graphique'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Répartition par Gravité',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: Colors.red,
                      value: stats.critical.toDouble(),
                      title: 'Critique\n${stats.critical}',
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.orange,
                      value: stats.high.toDouble(),
                      title: 'Élevé\n${stats.high}',
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.yellow[700],
                      value: stats.medium.toDouble(),
                      title: 'Moyen\n${stats.medium}',
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.blue,
                      value: stats.low.toDouble(),
                      title: 'Faible\n${stats.low}',
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem('Critique', Colors.red),
        _buildLegendItem('Élevé', Colors.orange),
        _buildLegendItem('Moyen', Colors.yellow[700]!),
        _buildLegendItem('Faible', Colors.blue),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activité Récente',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<Alert>>(
              stream: AlertService.getAlertsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final alerts = snapshot.data ?? [];
                final recentAlerts = alerts.take(5).toList();

                if (recentAlerts.isEmpty) {
                  return const Text('Aucune activité récente');
                }

                return Column(
                  children: recentAlerts.map((alert) => 
                    ListTile(
                      leading: _getAlertIcon(alert.severityLevel),
                      title: Text(alert.formattedAlertType),
                      subtitle: Text('${alert.city}, ${alert.country} • ${alert.timeAgo}'),
                      trailing: Chip(
                        label: Text(
                          alert.severity.toUpperCase(),
                          style: const TextStyle(fontSize: 10),
                        ),
                        backgroundColor: _getSeverityColor(alert.severityLevel).withOpacity(0.2),
                      ),
                    ),
                  ).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopThreats(AlertStatistics stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Menaces',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...stats.topAlertTypes.entries.take(5).map((entry) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(entry.key.replaceAll('_', ' ').toUpperCase()),
                    ),
                    Text(
                      '${entry.value}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionTab() {
    return StreamBuilder<AlertStatistics>(
      stream: AlertService.getAlertStatistics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text('Erreur de chargement', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('${snapshot.error}', textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }

        final stats = snapshot.data;
        if (stats == null || stats.total == 0) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pie_chart, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Aucune donnée à analyser', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Les graphiques de distribution apparaîtront avec plus de données'),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildCountryDistribution(stats),
              const SizedBox(height: 24),
              _buildAlertTypeDistribution(stats),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCountryDistribution(AlertStatistics stats) {
    if (stats.topCountries.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Répartition par Pays',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Aucune donnée géographique disponible',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Répartition par Pays',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...stats.topCountries.entries.take(10).map((entry) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(entry.key)),
                        Text(
                          '${entry.value}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: stats.total > 0 ? (entry.value / stats.total) : 0.0,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertTypeDistribution(AlertStatistics stats) {
    if (stats.topAlertTypes.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Types d\'Alertes',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Aucun type d\'alerte à afficher',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Types d\'Alertes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final types = stats.topAlertTypes.keys.toList();
                          if (value.toInt() < types.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                types[value.toInt()].split('_').first,
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: stats.topAlertTypes.entries.toList().asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.value.toDouble(),
                          color: Theme.of(context).colorScheme.primary,
                          width: 20,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsTab() {
    return StreamBuilder<List<Alert>>(
      stream: AlertService.getAlertsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final alerts = snapshot.data ?? [];
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTimelineChart(alerts),
              const SizedBox(height: 24),
              _buildHourlyDistribution(alerts),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimelineChart(List<Alert> alerts) {
    // Grouper les alertes par jour
    Map<String, int> dailyAlerts = {};
    final now = DateTime.now();
    
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = DateFormat('MM-dd').format(date);
      dailyAlerts[dateKey] = 0;
    }

    for (var alert in alerts) {
      final alertDate = alert.parsedTimestamp;
      if (alertDate != null && alertDate.isAfter(now.subtract(const Duration(days: 7)))) {
        final dateKey = DateFormat('MM-dd').format(alertDate);
        dailyAlerts[dateKey] = (dailyAlerts[dateKey] ?? 0) + 1;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tendance (7 derniers jours)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final keys = dailyAlerts.keys.toList();
                          if (value.toInt() < keys.length) {
                            return Text(
                              keys[value.toInt()],
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: dailyAlerts.entries.toList().asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.value.toDouble());
                      }).toList(),
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      ),
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyDistribution(List<Alert> alerts) {
    // Grouper les alertes par heure
    Map<int, int> hourlyAlerts = {};
    for (int i = 0; i < 24; i++) {
      hourlyAlerts[i] = 0;
    }

    for (var alert in alerts) {
      final alertDate = alert.parsedTimestamp;
      if (alertDate != null) {
        hourlyAlerts[alertDate.hour] = (hourlyAlerts[alertDate.hour] ?? 0) + 1;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribution par Heure',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 4,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}h');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: hourlyAlerts.entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.toDouble(),
                          color: Theme.of(context).colorScheme.primary,
                          width: 8,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(2),
                            topRight: Radius.circular(2),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeographyTab() {
    return StreamBuilder<AlertStatistics>(
      stream: AlertService.getAlertStatistics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = snapshot.data;
        if (stats == null) {
          return const Center(child: Text('Aucune donnée disponible'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildWorldMap(),
              const SizedBox(height: 24),
              _buildCountryStats(stats),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWorldMap() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Carte Mondiale des Menaces',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Carte mondiale interactive'),
                    Text('(À implémenter avec une lib de cartes)'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryStats(AlertStatistics stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistiques par Pays',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...stats.topCountries.entries.map((entry) => 
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text('Pays: ${entry.key}'),
                  subtitle: Text('${((entry.value / stats.total) * 100).toStringAsFixed(1)}% du total'),
                  trailing: Chip(
                    label: Text('${entry.value}'),
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                ),
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }

  String _getGrowthText(int last24Hours) {
    // Simulation d'une croissance (à remplacer par un vrai calcul)
    return last24Hours > 0 ? '+${last24Hours}' : 'Stable';
  }

  Icon _getAlertIcon(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return Icon(Icons.error, color: Colors.red);
      case AlertSeverity.high:
        return Icon(Icons.warning, color: Colors.orange);
      case AlertSeverity.medium:
        return Icon(Icons.priority_high, color: Colors.yellow[700]);
      case AlertSeverity.low:
        return Icon(Icons.info, color: Colors.blue);
      default:
        return Icon(Icons.help_outline, color: Colors.grey);
    }
  }

  Color _getSeverityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return Colors.red;
      case AlertSeverity.high:
        return Colors.orange;
      case AlertSeverity.medium:
        return Colors.yellow[700]!;
      case AlertSeverity.low:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatsContent(AlertStatistics stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(stats),
          const SizedBox(height: 24),
          _buildSeverityChart(stats),
          const SizedBox(height: 24),
          _buildRecentActivity(),
          const SizedBox(height: 24),
          _buildTopThreats(stats),
        ],
      ),
    );
  }
}