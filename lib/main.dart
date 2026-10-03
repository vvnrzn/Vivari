import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'models/aquarium.dart';
import 'models/care_record.dart';
import 'models/water_reading.dart';
import 'screens/care_screen.dart';
import 'screens/home_dashboard.dart';
import 'screens/parameters_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/vivari_bottom_navigation.dart';

void main() {
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vivari',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: VivariTheme.app,
      home: const VivariShell(),
    );
  }
}

class VivariShell extends StatefulWidget {
  const VivariShell({super.key});

  @override
  State<VivariShell> createState() => _VivariShellState();
}

class _CareDataNotifier extends ChangeNotifier {
  void update() => notifyListeners();
}

class _VivariShellState extends State<VivariShell> {
  final _navigatorKeys = List<GlobalKey<NavigatorState>>.generate(
    3,
    (_) => GlobalKey<NavigatorState>(),
  );
  int _selectedIndex = 1;
  final List<Aquarium> _aquariums = [];
  final List<CareTask> _tasks = [];
  final List<CareActivity> _activities = [];
  final List<WaterReading> _waterReadings = [];
  final List<CareTaskCompletion> _taskCompletions = [];
  final List<ActivityTemplate> _templates = [];
  final _CareDataNotifier _dataChanges = _CareDataNotifier();

  void _selectTab(int index) {
    setState(() => _selectedIndex = index);
  }

  void _addAquarium(Aquarium aquarium) {
    setState(() => _aquariums.add(aquarium));
    _dataChanges.update();
  }

  void _addTask(CareTask task) {
    setState(() => _tasks.add(task));
    _dataChanges.update();
  }

  void _logActivity(CareActivity activity, ActivityTemplate? template) {
    setState(() {
      _activities.add(activity);
      if (template != null) _templates.add(template);
    });
    _dataChanges.update();
  }

  void _logWaterReading(WaterReading reading) {
    setState(() => _waterReadings.add(reading));
    _dataChanges.update();
  }

  void _setTaskCompletion(
    CareTask task,
    DateTime scheduledDate,
    bool completed,
  ) {
    final date = DateUtils.dateOnly(scheduledDate);
    setState(() {
      _taskCompletions.removeWhere(
        (entry) =>
            identical(entry.task, task) &&
            DateUtils.isSameDay(entry.scheduledDate, date),
      );
      if (completed) {
        _taskCompletions.add(
          CareTaskCompletion(
            task: task,
            scheduledDate: date,
            completedAt: DateTime.now(),
          ),
        );
      }
    });
    _dataChanges.update();
  }

  Widget _buildTabNavigator(int index) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => AnimatedBuilder(
          animation: _dataChanges,
          builder: (context, child) => switch (index) {
            0 => ParametersScreen(
              aquariums: _aquariums,
              readings: _waterReadings,
              onReadingSaved: _logWaterReading,
            ),
            1 => HomeDashboard(
              onSelectTab: _selectTab,
              aquariums: _aquariums,
              tasks: _tasks,
              activities: _activities,
              onAquariumAdded: _addAquarium,
            ),
            _ => CareScreen(
              aquariums: _aquariums,
              tasks: _tasks,
              activities: _activities,
              waterReadings: _waterReadings,
              taskCompletions: _taskCompletions,
              templates: _templates,
              onTaskCreated: _addTask,
              onActivityLogged: _logActivity,
              onTaskCompletionChanged: _setTaskCompletion,
            ),
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dataChanges.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: List<Widget>.generate(3, _buildTabNavigator),
      ),
      bottomNavigationBar: VivariBottomNavigation(
        currentIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
      ),
    );
  }
}
