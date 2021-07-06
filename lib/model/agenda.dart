import 'package:hive/hive.dart';
part 'agenda.g.dart';

@HiveType(typeId: 0)
class Agenda{
  @HiveField(0)
  String judul;
  @HiveField(1) 
  String deskripsi;
  @HiveField(2)
  String waktu;
  @HiveField(3)
  bool isDone;

  Agenda(this.judul, this.deskripsi, this.waktu, this.isDone);
}