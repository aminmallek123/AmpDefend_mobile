import 'package:flutter/material.dart';

class DateRangeFilterWidget extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?, DateTime?) onDateRangeChanged;

  const DateRangeFilterWidget({
    Key? key,
    this.startDate,
    this.endDate,
    required this.onDateRangeChanged,
  }) : super(key: key);

  @override
  State<DateRangeFilterWidget> createState() => _DateRangeFilterWidgetState();
}

class _DateRangeFilterWidgetState extends State<DateRangeFilterWidget> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtres temporels',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Filtres rapides
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickFilterChip('Dernière heure', _getLastHour),
                _buildQuickFilterChip('Dernières 6h', _getLast6Hours),
                _buildQuickFilterChip('Dernières 24h', _getLast24Hours),
                _buildQuickFilterChip('Dernière semaine', _getLastWeek),
                _buildQuickFilterChip('Dernier mois', _getLastMonth),
                _buildQuickFilterChip('Tout', _clearFilter),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            
            // Sélection de plage personnalisée
            Text(
              'Plage personnalisée',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectStartDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _startDate != null 
                          ? _formatDate(_startDate!)
                          : 'Date début',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectEndDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _endDate != null 
                          ? _formatDate(_endDate!)
                          : 'Date fin',
                    ),
                  ),
                ),
              ],
            ),
            
            if (_startDate != null || _endDate != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _buildDateRangeText(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  TextButton(
                    onPressed: _clearCustomRange,
                    child: const Text('Effacer'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFilterChip(String label, VoidCallback onPressed) {
    return ActionChip(
      label: Text(label),
      onPressed: onPressed,
      backgroundColor: Theme.of(context).colorScheme.surface,
      side: BorderSide(
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }

  void _getLastHour() {
    final now = DateTime.now();
    final start = now.subtract(const Duration(hours: 1));
    _updateDateRange(start, now);
  }

  void _getLast6Hours() {
    final now = DateTime.now();
    final start = now.subtract(const Duration(hours: 6));
    _updateDateRange(start, now);
  }

  void _getLast24Hours() {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 1));
    _updateDateRange(start, now);
  }

  void _getLastWeek() {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 7));
    _updateDateRange(start, now);
  }

  void _getLastMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 1, now.day);
    _updateDateRange(start, now);
  }

  void _clearFilter() {
    _updateDateRange(null, null);
  }

  void _clearCustomRange() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
    widget.onDateRangeChanged(null, null);
  }

  void _updateDateRange(DateTime? start, DateTime? end) {
    setState(() {
      _startDate = start;
      _endDate = end;
    });
    widget.onDateRangeChanged(start, end);
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      final time = await _selectTime(_startDate ?? DateTime.now());
      if (time != null) {
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        setState(() {
          _startDate = dateTime;
        });
        widget.onDateRangeChanged(_startDate, _endDate);
      }
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      final time = await _selectTime(_endDate ?? DateTime.now());
      if (time != null) {
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        setState(() {
          _endDate = dateTime;
        });
        widget.onDateRangeChanged(_startDate, _endDate);
      }
    }
  }

  Future<TimeOfDay?> _selectTime(DateTime initialDate) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _buildDateRangeText() {
    if (_startDate != null && _endDate != null) {
      final duration = _endDate!.difference(_startDate!);
      if (duration.inDays > 0) {
        return 'Période: ${duration.inDays} jour(s)';
      } else if (duration.inHours > 0) {
        return 'Période: ${duration.inHours} heure(s)';
      } else {
        return 'Période: ${duration.inMinutes} minute(s)';
      }
    } else if (_startDate != null) {
      return 'Depuis: ${_formatDate(_startDate!)}';
    } else if (_endDate != null) {
      return 'Jusqu\'à: ${_formatDate(_endDate!)}';
    }
    return '';
  }
}