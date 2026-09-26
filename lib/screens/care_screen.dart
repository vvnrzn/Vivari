import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class CareScreen extends StatefulWidget {
  const CareScreen({super.key});

  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> {
  int _selectedView = 0;

  @override
  Widget build(BuildContext context) {
    final views = [
      _CareColumn(
        title: 'LIST',
        body: _ListCareView(),
      ),
      _CareColumn(
        title: 'WEEK',
        body: _WeekCareView(),
      ),
      _CareColumn(
        title: 'MONTH',
        body: _MonthCareView(),
      ),
      _CareColumn(
        title: 'HISTORY',
        body: _HistoryCareView(),
      ),
    ];

    return Scaffold(
      backgroundColor: VivariColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                'CARE VIEWS',
                style: GoogleFonts.spaceGrotesk(
                  color: VivariColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(views.length, (index) {
                      final view = views[index];
                      final selected = index == _selectedView;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedView = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOut,
                          width: 290,
                          margin: const EdgeInsets.only(right: 22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 4,
                                  bottom: 12,
                                ),
                                child: Text(
                                  view.title,
                                  style: GoogleFonts.spaceGrotesk(
                                    color: selected
                                        ? VivariColors.textPrimary
                                        : VivariColors.textMuted,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                              view.body,
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CareColumn extends StatelessWidget {
  const _CareColumn({required this.title, required this.body});

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class _ListCareView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionCard(
          title: 'Schedule',
          child: Column(
            children: [
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _Pill(label: 'List', active: true),
                  _Pill(label: 'Week'),
                  _Pill(label: 'Month'),
                  _Pill(label: 'History'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _TaskSection(
          label: 'OVERDUE (3)',
          items: [
            _TaskItem(label: 'Clean Algae Scraper', location: 'Amazon Basin', status: 'Overdue'),
          ],
        ),
        const SizedBox(height: 18),
        _TaskSection(
          label: 'DUE TODAY (3)',
          items: [
            _TaskItem(label: 'Water Change 20%', location: 'Pacific Reef', status: 'Today'),
            _TaskItem(label: 'Test Parameters', location: 'Pacific Reef', status: 'Today'),
            _TaskItem(label: 'Feed Corals', location: 'Pacific Reef', status: 'Today'),
          ],
        ),
        const SizedBox(height: 18),
        _TaskSection(
          label: 'UPCOMING - NEXT 7 DAYS (3)',
          items: [
            _TaskItem(label: 'Trim Plants', location: 'Amazon Basin', date: 'Sep 26'),
            _TaskItem(label: 'Dose Calcium', location: 'Pacific Reef', date: 'Sep 28'),
            _TaskItem(label: 'Filter Media Check', location: 'Amazon Basin', date: 'Monthly'),
          ],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _AddButton(),
          ),
        ),
      ],
    );
  }
}

class _WeekCareView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionCard(
          title: 'Schedule',
          child: Column(
            children: [
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _Pill(label: 'List'),
                  _Pill(label: 'Week', active: true),
                  _Pill(label: 'Month'),
                  _Pill(label: 'History'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _DayScheduleRow(
          dayLabel: '23',
          title: 'Today',
          tasks: const [
            _TaskItem(label: 'Water Change 20%', location: 'Pacific Reef', status: 'Today'),
          ],
        ),
        _DayScheduleRow(
          dayLabel: '24',
          title: 'Thu',
          tasks: const [
            _TaskItem(label: 'Test Parameters', location: 'Pacific Reef', status: 'Today'),
          ],
        ),
        _DayScheduleRow(
          dayLabel: '25',
          title: 'Fri',
          tasks: const [
            _TaskItem(label: 'Feed Corals', location: 'Pacific Reef', status: 'Today'),
          ],
        ),
        _DayScheduleRow(
          dayLabel: '26',
          title: 'Sat',
          tasks: const [
            _TaskItem(label: 'Trim Plants', location: 'Amazon Basin', date: 'Sep 26'),
          ],
        ),
        _DayScheduleRow(
          dayLabel: '27',
          title: 'Sun',
          tasks: const [],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: _AddButton(),
        ),
      ],
    );
  }
}

class _MonthCareView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionCard(
          title: 'Schedule',
          child: Column(
            children: [
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _Pill(label: 'List'),
                  _Pill(label: 'Week'),
                  _Pill(label: 'Month', active: true),
                  _Pill(label: 'History'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: VivariColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: VivariColors.border),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.chevron_left, size: 18, color: VivariColors.textMuted),
                  Text(
                    'September 2026',
                    style: GoogleFonts.dmSans(
                      color: VivariColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 18, color: VivariColors.textMuted),
                ],
              ),
              const SizedBox(height: 10),
              const _CalendarGrid(),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: _AddButton(),
        ),
      ],
    );
  }
}

class _HistoryCareView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionCard(
          title: 'Schedule',
          child: Column(
            children: [
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  _Pill(label: 'List'),
                  _Pill(label: 'Week'),
                  _Pill(label: 'Month'),
                  _Pill(label: 'History', active: true),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _HistoryItem(date: 'SEP 22', title: 'Dose Alkalinity', location: 'Pacific Reef'),
        _HistoryItem(date: 'SEP 20', title: 'Feed Fish', location: 'Amazon Basin'),
        _HistoryItem(date: 'SEP 16', title: 'Test Parameters', location: 'Amazon Basin'),
        _HistoryItem(date: 'SEP 16', title: 'Skimmer Cleaning', location: 'Pacific Reef'),
        _HistoryItem(date: 'SEP 16', title: 'Water Change 25%', location: 'Pacific Reef'),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: _AddButton(),
        ),
      ],
    );
  }
}

class _TaskSection extends StatelessWidget {
  const _TaskSection({required this.label, required this.items});

  final String label;
  final List<_TaskItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                color: VivariColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.7,
              ),
            ),
          ),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: item,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  const _TaskItem({
    required this.label,
    this.location,
    this.status,
    this.date,
  });

  final String label;
  final String? location;
  final String? status;
  final String? date;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: VivariColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VivariColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: VivariColors.textMuted, width: 1.6),
              color: Colors.transparent,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: textTheme.titleMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (status != null)
                      Text(
                        status!,
                        style: GoogleFonts.dmSans(
                          color: VivariColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                if (location != null || date != null)
                  const SizedBox(height: 4),
                if (location != null)
                  Text(
                    location!,
                    style: textTheme.bodySmall?.copyWith(
                      color: VivariColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                if (date != null && location == null)
                  Text(
                    date!,
                    style: textTheme.bodySmall?.copyWith(
                      color: VivariColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayScheduleRow extends StatelessWidget {
  const _DayScheduleRow({
    required this.dayLabel,
    required this.title,
    required this.tasks,
  });

  final String dayLabel;
  final String title;
  final List<_TaskItem> tasks;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: VivariColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VivariColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  dayLabel,
                  style: GoogleFonts.spaceGrotesk(
                    color: VivariColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    color: VivariColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (tasks.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...tasks.map((task) => Padding(padding: const EdgeInsets.only(bottom: 8), child: task)),
            ],
          ],
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({
    required this.date,
    required this.title,
    required this.location,
  });

  final String date;
  final String title;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: VivariColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VivariColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: VivariColors.textMuted, width: 1.5),
              color: Colors.transparent,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: GoogleFonts.dmSans(
                    color: VivariColors.textMuted,
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: VivariColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
      decoration: BoxDecoration(
        color: VivariColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: VivariColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.dmSans(
              color: VivariColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: active ? VivariColors.primary : VivariColors.secondary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: active ? VivariColors.primary : VivariColors.border,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          color: active ? VivariColors.background : VivariColors.textPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid();

  @override
  Widget build(BuildContext context) {
    final weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    final cells = [
      '1', '2', '3', '4', '5', '', '',
      '', '7', '8', '9', '10', '11', '12',
      '13', '14', '15', '16', '17', '18', '19',
      '20', '21', '22', '23', '24', '25', '26',
      '27', '28', '29', '30', '', '', '',
    ];

    return Column(
      children: [
        Row(
          children: weekDays
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: GoogleFonts.dmSans(
                        color: VivariColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cells.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.2,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemBuilder: (context, index) {
            final value = cells[index];
            if (value.isEmpty) {
              return const SizedBox();
            }

            final isSelected = value == '23';
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? VivariColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value,
                style: GoogleFonts.dmSans(
                  color: isSelected ? VivariColors.background : VivariColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: VivariColors.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: VivariColors.primary.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(Icons.add, color: VivariColors.background, size: 22),
    );
  }
}
