import 'package:hive/hive.dart';
import 'package:task_tracker/domain/enums/priority.dart';

class PriorityAdapter extends TypeAdapter<Priority> {
  @override
  final int typeId = 1;

  @override
  Priority read(BinaryReader reader) {
    return Priority.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, Priority obj) {
    writer.writeInt(obj.index);
  }
}
