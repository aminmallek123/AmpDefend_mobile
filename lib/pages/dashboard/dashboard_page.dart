import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/alert.dart';
import '../../models/alert_statistics.dart';
import '../../services/alert_service.dart';
import '../../services/auth_service.dart';
import '../../theme/theme_manager.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/date_range_filter_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedFilter = 'all';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showDateFilter = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Security Dashboard',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {}); // Force refresh
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                await AuthService.signOut();
                if (mounted) {
                  context.go('/');
                }
              } else if (value == 'test_alert') {
                try {
                  await AlertService.addMultipleTestAlerts();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Test alerts added to Firebase!')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              } else if (value == 'toggle_theme') {
                ThemeManager().toggleTheme();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'toggle_theme',
                child: ListTile(
                  leading: Icon(Icons.brightness_6),
                  title: Text('Dark Mode'),
                ),
              ),
              const PopupMenuItem(
                value: 'test_alert',
                child: ListTile(
                  leading: Icon(Icons.bug_report),
                  title: Text('Add Test'),
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with user information
              _buildUserHeader(),
              const SizedBox(height: 24),
              
              // Alert statistics
              _buildStatisticsSection(),
              const SizedBox(height: 24),
              
              // Filters
              _buildFiltersSection(),
              const SizedBox(height: 16),
              
              // Alert list
              _buildAlertsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    final user = AuthService.currentUser;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.security,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome ${user?.displayName ?? user?.email ?? 'User'}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'AmpDefend Dashboard - Real-time Monitoring',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '🟢 System active',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go('/statistics');
                    },
                    icon: const Icon(Icons.analytics),
                    label: const Text('Detailed Statistics'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Add configuration page
                    },
                    icon: const Icon(Icons.settings),
                    label: const Text('Settings'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return StreamBuilder<AlertStatistics>(
      stream: AlertService.getAlertStatistics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        final stats = snapshot.data;
        if (stats == null) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No data available'),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Alert statistics',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    context.go('/statistics');
                  },
                  icon: const Icon(Icons.bar_chart),
                  label: const Text('View details'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4, // Increase for more vertical space
              children: [
                _buildStatCard(
                  'Total',
                  '${stats.total}',
                  Icons.notifications,
                  Colors.blue,
                  'All alerts',
                ),
                _buildStatCard(
                  'Last 24h',
                  '${stats.last24Hours}',
                  Icons.access_time,
                  Colors.orange,
                  'Recent alerts',
                ),
                _buildStatCard(
                  'Critical',
                  '${stats.critical}',
                  Icons.warning,
                  Colors.red,
                  'Severe threats',
                ),
                _buildStatCard(
                  'High',
                  '${stats.high}',
                  Icons.priority_high,
                  Colors.deepOrange,
                  'Important risks',
                ),
                _buildStatCard(
                  'Medium',
                  '${stats.medium}',
                  Icons.info,
                  Colors.amber,
                  'Active monitoring',
                ),
                _buildStatCard(
                  'Low',
                  '${stats.low}',
                  Icons.check_circle,
                  Colors.green,
                  'Minor alerts',
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, [String? description]) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12), // Reduce padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Taille minimale
          children: [
            Icon(icon, size: 24, color: color), // Reduce size
            const SizedBox(height: 6), // Reduce spacing
            Flexible(
              child: Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 20, // Reduce font size
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12, // Smaller size
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            if (description != null) ...[
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 9, // Smaller
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1, // Single line
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Filters',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _showDateFilter = !_showDateFilter;
                });
              },
              icon: Icon(
                _showDateFilter ? Icons.expand_less : Icons.date_range,
                color: _startDate != null || _endDate != null 
                    ? Theme.of(context).colorScheme.primary 
                    : null,
              ),
              tooltip: 'Time filters',
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('all', 'All'),
              _buildFilterChip('critical', 'Critical'),
              _buildFilterChip('high', 'High'),
              _buildFilterChip('medium', 'Medium'),
              _buildFilterChip('low', 'Low'),
              _buildFilterChip('intrusion_detected', 'Intrusions'),
              _buildFilterChip('vpn_detected', 'VPN'),
              _buildFilterChip('malware_detected', 'Malware'),
            ],
          ),
        ),
        
        // Affichage conditionnel du filtre de date
        if (_showDateFilter) ...[
          const SizedBox(height: 16),
          DateRangeFilterWidget(
            startDate: _startDate,
            endDate: _endDate,
            onDateRangeChanged: (start, end) {
              setState(() {
                _startDate = start;
                _endDate = end;
              });
            },
          ),
        ],
        
        // Active filter indicator
        if (_startDate != null || _endDate != null || _selectedFilter != 'all') ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.filter_alt,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  _buildActiveFiltersText(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _startDate = null;
                      _endDate = null;
                      _selectedFilter = 'all';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All filters removed'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getFilterIcon(value),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
          // Afficher un message informatif
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Filter applied: $label'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        checkmarkColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.grey[100],
      ),
    );
  }

  Widget _getFilterIcon(String filterType) {
    switch (filterType) {
      case 'all':
        return Icon(Icons.apps, size: 16, color: Colors.blue);
      case 'critical':
        return Icon(Icons.error, size: 16, color: Colors.red);
      case 'high':
        return Icon(Icons.warning, size: 16, color: Colors.orange);
      case 'medium':
        return Icon(Icons.info, size: 16, color: Colors.amber);
      case 'low':
        return Icon(Icons.check_circle, size: 16, color: Colors.green);
      case 'intrusion_detected':
        return Icon(Icons.security, size: 16, color: Colors.purple);
      case 'vpn_detected':
        return Icon(Icons.vpn_key, size: 16, color: Colors.indigo);
      case 'malware_detected':
        return Icon(Icons.bug_report, size: 16, color: Colors.red[700]);
      default:
        return Icon(Icons.filter_alt, size: 16, color: Colors.grey);
    }
  }

  Widget _buildAlertsSection() {
    return StreamBuilder<List<Alert>>(
      stream: _getFilteredAlertsStream(),
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
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Connection error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final alerts = snapshot.data ?? [];
        
        if (alerts.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No alerts found',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your Raspberry Pi alerts will appear here',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent alerts (${alerts.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to detailed alerts page
                  },
                  child: const Text('View all'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                return AlertCard(alert: alerts[index]);
              },
            ),
          ],
        );
      },
    );
  }

  Stream<List<Alert>> _getFilteredAlertsStream() {
    // Determine the alert type to filter
    String? alertType;
    String? severity;
    
    if (_selectedFilter != 'all') {
      // Severity filters
      if (_selectedFilter == 'critical' || 
          _selectedFilter == 'high' || 
          _selectedFilter == 'medium' || 
          _selectedFilter == 'low') {
        severity = _selectedFilter;
        print('🔍 DEBUG: Severity filter applied: $severity');
      } else {
        // Alert type filters
        alertType = _selectedFilter;
        print('🔍 DEBUG: Type filter applied: $alertType');
      }
    }

    print('🔍 DEBUG: Filter parameters - Type: $alertType, Severity: $severity, Start date: $_startDate, End date: $_endDate');

    return AlertService.getFilteredAlertsStream(
      startDate: _startDate,
      endDate: _endDate,
      alertType: alertType,
      severity: severity,
    );
  }

  String _buildActiveFiltersText() {
    List<String> activeFilters = [];
    
    // Add type/severity filter if not "all"
    if (_selectedFilter != 'all') {
      switch (_selectedFilter) {
        case 'critical':
          activeFilters.add('Critical');
          break;
        case 'high':
          activeFilters.add('High');
          break;
        case 'medium':
          activeFilters.add('Medium');
          break;
        case 'low':
          activeFilters.add('Low');
          break;
        case 'intrusion_detected':
          activeFilters.add('Intrusions');
          break;
        case 'vpn_detected':
          activeFilters.add('VPN');
          break;
        case 'malware_detected':
          activeFilters.add('Malware');
          break;
        default:
          activeFilters.add(_selectedFilter);
      }
    }
    
    // Add date filter if it exists
    if (_startDate != null || _endDate != null) {
      if (_startDate != null && _endDate != null) {
        final duration = _endDate!.difference(_startDate!);
        if (duration.inDays > 0) {
          activeFilters.add('${duration.inDays}j');
        } else if (duration.inHours > 0) {
          activeFilters.add('${duration.inHours}h');
        } else {
          activeFilters.add('${duration.inMinutes}min');
        }
      } else if (_startDate != null) {
        activeFilters.add('Since ${_formatShortDate(_startDate!)}');
      } else if (_endDate != null) {
        activeFilters.add('Until ${_formatShortDate(_endDate!)}');
      }
    }
    
    if (activeFilters.isEmpty) {
      return 'No active filters';
    }
    
    return 'Active filters: ${activeFilters.join(', ')}';
  }



  String _formatShortDate(DateTime date) {
    return '${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class AlertCard extends StatelessWidget {
  final Alert alert;

  const AlertCard({Key? key, required this.alert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          _showAlertDetails(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _getSeverityIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.formattedAlertType,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          alert.rawMessage,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _getSeverityChip(),
                      const SizedBox(height: 4),
                      Text(
                        alert.timeAgo,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${alert.city}, ${alert.country}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.computer, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    alert.ipBlocked,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSeverityIcon() {
    switch (alert.severityLevel) {
      case AlertSeverity.critical:
        return Icon(Icons.error, color: Colors.red, size: 28);
      case AlertSeverity.high:
        return Icon(Icons.warning, color: Colors.orange, size: 28);
      case AlertSeverity.medium:
        return Icon(Icons.priority_high, color: Colors.yellow[700], size: 28);
      case AlertSeverity.low:
        return Icon(Icons.info, color: Colors.blue, size: 28);
      default:
        return Icon(Icons.help_outline, color: Colors.grey, size: 28);
    }
  }

  Widget _getSeverityChip() {
    Color color;
    switch (alert.severityLevel) {
      case AlertSeverity.critical:
        color = Colors.red;
        break;
      case AlertSeverity.high:
        color = Colors.orange;
        break;
      case AlertSeverity.medium:
        color = Colors.yellow[700]!;
        break;
      case AlertSeverity.low:
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        alert.severity.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  void _showAlertDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alert.formattedAlertType),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Message', alert.rawMessage),
              _buildDetailRow('Severity', alert.severity),
              _buildDetailRow('Blocked IP', alert.ipBlocked),
              _buildDetailRow('Public IP', alert.publicIp),
              _buildDetailRow('Location', '${alert.city}, ${alert.region}, ${alert.country}'),
              _buildDetailRow('Coordinates', alert.formattedLocation),
              _buildDetailRow('Organization', alert.organization),
              _buildDetailRow('VPN Likelihood', '${alert.vpnLikelihood}% (${alert.vpnLikelihoodDescription})'),
              _buildDetailRow('Device', alert.deviceId),
              _buildDetailRow('Timezone', alert.timezone),
              _buildDetailRow('Timestamp', alert.timestamp),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}