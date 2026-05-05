import 'package:task_tracker/domain/enums/category.dart';

extension CategoryExt on Category {
  String get categoryRu {
    switch (this) {
      case Category.work:
        return "Работа";
      case Category.personal:
        return "Личное";
    }
  }
}
