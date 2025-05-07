class TaskModel {
  String description;
  DateTime? dateTime;
  String? tag;
  bool isCompleted;

  TaskModel({
    required this.description,
    this.dateTime,
    this.tag,
    this.isCompleted = false,
  });

  TaskModel copyWith({
    String? description,
    DateTime? dateTime,
    bool? isCompleted,
  }) {
    return TaskModel(
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
