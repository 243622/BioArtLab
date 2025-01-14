import 'package:flutter/material.dart';
import 'package:timeline_tile_plus/timeline_tile_plus.dart';

import '../../models/classes/Task.dart';

class TimeLineTileTasks extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final Task task;

  const TimeLineTileTasks({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
          color: isPast ? Colors.deepPurple : Colors.deepPurple.shade500,
          thickness: 2,
        ),
        indicatorStyle: IndicatorStyle(
          width: 30,
          color: isPast ? Colors.deepPurple : Colors.deepPurple.shade300,
          iconStyle: IconStyle(
            iconData: isPast ? Icons.done : Icons.pending,
            color: isPast ? Colors.white : Colors.deepPurple.shade100,
          ),
        ),
        endChild: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isPast ? Colors.deepPurple : Colors.deepPurple.shade300,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  task.title.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Type: ${task.taskTypeString}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Deadline: ${task.deadline != null ? task.deadline.toString() : 'No deadline'}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
