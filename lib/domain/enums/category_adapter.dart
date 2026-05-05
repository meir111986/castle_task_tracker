import 'package:hive/hive.dart';
import 'package:task_tracker/domain/enums/category.dart';

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 2;

  @override
  Category read(BinaryReader reader) {
    return Category.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer.writeInt(obj.index);
  }
}
