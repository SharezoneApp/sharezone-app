import 'upload_task_snapshot.dart';
import 'upload_task_type.dart';

class UploadTaskEvent {
  final UploadTaskSnapshot snapshot;
  final UploadTaskEventType type;
  const UploadTaskEvent({
    this.snapshot,
    this.type,
  });
}
