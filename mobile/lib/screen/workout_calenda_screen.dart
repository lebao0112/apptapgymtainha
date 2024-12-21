import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import '../notification_helper.dart';

class WorkoutCalendarScreen extends StatefulWidget {
  final List<dynamic> workouts;

  const WorkoutCalendarScreen({Key? key, required this.workouts}) : super(key: key);

  @override
  State<WorkoutCalendarScreen> createState() => _WorkoutCalendarScreenState();
}

class _WorkoutCalendarScreenState extends State<WorkoutCalendarScreen> {
  late final List<String> workoutTitles;

  final Map<String, bool> _notificationStatus = {
    'Thứ Hai': false,
    'Thứ Ba': false,
    'Thứ Tư': false,
    'Thứ Năm': false,
    'Thứ Sáu': false,
    'Thứ Bảy': false,
    'Chủ Nhật': false,
  };

  final Map<String, TimeOfDay> _notificationTimes = {
    'Thứ Hai': const TimeOfDay(hour: 12, minute: 0),
    'Thứ Ba': const TimeOfDay(hour: 12, minute: 0),
    'Thứ Tư': const TimeOfDay(hour: 12, minute: 0),
    'Thứ Năm': const TimeOfDay(hour: 12, minute: 0),
    'Thứ Sáu': const TimeOfDay(hour: 12, minute: 0),
    'Thứ Bảy': const TimeOfDay(hour: 12, minute: 0),
    'Chủ Nhật': const TimeOfDay(hour: 12, minute: 0),
  };

  final Map<String, String?> _selectedWorkoutTitles = {
    'Thứ Hai': null,
    'Thứ Ba': null,
    'Thứ Tư': null,
    'Thứ Năm': null,
    'Thứ Sáu': null,
    'Thứ Bảy': null,
    'Chủ Nhật': null,
  };

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    NotificationHelper.init();
    workoutTitles = widget.workouts.map((workout) => workout['Title'].toString()).toList();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final days = _notificationStatus.keys.toList();
    final status = await _loadNotificationStatus(days);
    final times = await _loadNotificationTimes(days);
    final workoutTitles = await _loadWorkoutTitles(days);

    setState(() {
      _notificationStatus.addAll(status);
      _notificationTimes.addAll(times);
      _selectedWorkoutTitles.addAll(workoutTitles);
    });
  }

  Future<Map<String, bool>> _loadNotificationStatus(List<String> days) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, bool> status = {};
    for (var day in days) {
      status[day] = prefs.getBool('notification_$day') ?? false;
    }
    return status;
  }

  Future<Map<String, TimeOfDay>> _loadNotificationTimes(List<String> days) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, TimeOfDay> times = {};
    for (var day in days) {
      final timeString = prefs.getString('time_$day');
      if (timeString != null) {
        final parts = timeString.split(':');
        times[day] = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      } else {
        times[day] = const TimeOfDay(hour: 12, minute: 0);
      }
    }
    return times;
  }

  Future<Map<String, String?>> _loadWorkoutTitles(List<String> days) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String?> workoutTitles = {};
    for (var day in days) {
      workoutTitles[day] = prefs.getString('workoutTitle_$day');
    }
    return workoutTitles;
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationStatus.forEach((day, value) {
      prefs.setBool('notification_$day', value);
    });
    _notificationTimes.forEach((day, time) {
      prefs.setString('time_$day', '${time.hour}:${time.minute}');
    });
    _selectedWorkoutTitles.forEach((day, workoutTitle) {
      if (workoutTitle != null) {
        prefs.setString('workoutTitle_$day', workoutTitle);
      }
    });
  }

  void _pickTime(String day) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _notificationTimes[day]!,
    );
    if (pickedTime != null) {
      setState(() {
        _notificationTimes[day] = pickedTime;
      });
    }
  }

  void _scheduleWorkoutNotification(String day) {
    if (_notificationStatus[day] == false) return;

    final TimeOfDay time = _notificationTimes[day]!;
    final now = DateTime.now();
    DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    final workoutTitle = _selectedWorkoutTitles[day] ?? "Bài tập chưa được chọn";

    NotificationHelper.scheduledNotification(
      'Lịch luyện tập: $day',
      'Đã đến giờ tập luyện bài: $workoutTitle',
      scheduledDate,
    );
  }

  void _saveAndScheduleNotifications() {
    _savePreferences();
    _notificationStatus.keys.forEach(_scheduleWorkoutNotification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt lịch luyện tập'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: _notificationStatus.keys.map((day) {
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  day,
                  style: const TextStyle(fontSize: 24),
                ),
                Text(
                  '${_notificationTimes[day]!.hour.toString().padLeft(2, '0')}:${_notificationTimes[day]!.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  value: _selectedWorkoutTitles[day],
                  hint: const Text("Chọn bài tập"),
                  items: workoutTitles.map((title) {
                    return DropdownMenuItem<String>(
                      value: title,
                      child: Text(title),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedWorkoutTitles[day] = newValue;
                      });
                    }
                  },
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _notificationStatus[day],
                      onChanged: (bool? value) {
                        setState(() {
                          _notificationStatus[day] = value ?? false;
                        });
                      },
                    ),
                    const Text('Bật thông báo')
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.access_time, color: Colors.orange),
              onPressed: () => _pickTime(day),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveAndScheduleNotifications,
        child: const Icon(Icons.save),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
