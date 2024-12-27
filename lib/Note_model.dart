import 'package:hive/hive.dart';

part 'Note_model.g.dart';

@HiveType(typeId: 0) 
class Note {
  @HiveField(0) 
   String text;

  @HiveField(1)
   bool isFavorite;

  @HiveField(2)
   String category;

  Note({
    required this.text,
    required this.isFavorite, 
    required this.category,
  });
}
