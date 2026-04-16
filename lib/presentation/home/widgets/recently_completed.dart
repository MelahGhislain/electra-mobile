import 'package:electra/presentation/home/model/task.dart';
import 'package:electra/presentation/home/widgets/task_item.dart';
import 'package:flutter/material.dart';

class RecentlyCompleted extends StatelessWidget {
  final List<Task> tasks;
  final VoidCallback onViewAllPressed;

  const RecentlyCompleted({
    super.key,
    required this.tasks,
    required this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recently Completed',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              TextButton(
                onPressed: onViewAllPressed,
                child: const Text('View all'),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return TaskItem(task: tasks[index]);
            },
          ),
        ),
      ],
    );
  }
}
