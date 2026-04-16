import 'package:electra/presentation/home/model/task.dart';
import 'package:electra/presentation/home/widgets/task_item.dart';
import 'package:flutter/material.dart';

class RecentlyCompleted extends StatelessWidget {
  final List<Task> tasks;

  const RecentlyCompleted({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true, // ← Important
          physics: const NeverScrollableScrollPhysics(), // ← Important
          padding: const EdgeInsets.only(bottom: 20, left: 22, right: 22),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return TaskItem(task: tasks[index]);
          },
        ),
      ],
    );
  }
}
