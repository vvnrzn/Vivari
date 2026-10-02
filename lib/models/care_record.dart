enum TaskRecurrence { none, basic, customInterval, weekdays, monthDays }

class CareTask {
  const CareTask({
    required this.title,
    required this.category,
    required this.aquariumName,
    required this.dueAt,
    this.aquariumNames,
    this.recurrence = TaskRecurrence.none,
    this.recurrenceUnit = 'Days',
    this.recurrenceInterval = 1,
    this.weekdays = const {},
    this.monthDays = const {},
  });

  final String title;
  final String category;
  final String aquariumName;
  final List<String>? aquariumNames;
  final DateTime dueAt;
  final TaskRecurrence recurrence;
  final String recurrenceUnit;
  final int recurrenceInterval;
  final Set<int> weekdays;
  final Set<int> monthDays;

  List<String> get associatedAquariumNames =>
      aquariumNames ?? (aquariumName.isEmpty ? const [] : [aquariumName]);

  bool isAssociatedWithAquarium(String name) =>
      associatedAquariumNames.contains(name);

  bool isDueOn(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    final start = DateTime(dueAt.year, dueAt.month, dueAt.day);
    if (day.isBefore(start)) return false;
    if (recurrence == TaskRecurrence.none) return day == start;

    final elapsedDays = day.difference(start).inDays;
    final interval = recurrenceInterval < 1 ? 1 : recurrenceInterval;
    return switch (recurrence) {
      TaskRecurrence.none => day == start,
      TaskRecurrence.basic => switch (recurrenceUnit) {
        'Weeks' => elapsedDays % (7 * interval) == 0,
        'Months' =>
          day.day == start.day &&
              ((day.year - start.year) * 12 + day.month - start.month) %
                      interval ==
                  0,
        _ => elapsedDays % interval == 0,
      },
      TaskRecurrence.customInterval => switch (recurrenceUnit) {
        'Weeks' => elapsedDays % (7 * interval) == 0,
        'Months' =>
          day.day == start.day &&
              ((day.year - start.year) * 12 + day.month - start.month) %
                      interval ==
                  0,
        _ => elapsedDays % interval == 0,
      },
      TaskRecurrence.weekdays => weekdays.contains(date.weekday % 7),
      TaskRecurrence.monthDays => monthDays.contains(date.day),
    };
  }
}

class CareActivity {
  const CareActivity({
    required this.name,
    required this.category,
    required this.aquariumName,
    required this.loggedAt,
    this.amount,
    this.unit,
    this.note,
  });

  final String name;
  final String category;
  final String aquariumName;
  final DateTime loggedAt;
  final String? amount;
  final String? unit;
  final String? note;
}

class CareTaskCompletion {
  const CareTaskCompletion({
    required this.task,
    required this.scheduledDate,
    required this.completedAt,
  });

  final CareTask task;
  final DateTime scheduledDate;
  final DateTime completedAt;
}

class ActivityTemplate {
  const ActivityTemplate({
    required this.name,
    required this.category,
    this.amount,
    this.unit,
    this.note,
  });

  final String name;
  final String category;
  final String? amount;
  final String? unit;
  final String? note;
}
