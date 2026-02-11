import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class StorageService {
  static const String _notesKey = 'notes_list';

  // Sauvegarder la liste des notes
  static Future<void> saveNotes(List<Note> notes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesJson = notes.map((note) => note.toJson()).toList();
      final notesString = jsonEncode(notesJson);
      await prefs.setString(_notesKey, notesString);
    } catch (e) {
      print('Erreur lors de la sauvegarde: $e');
    }
  }

  // Charger la liste des notes
  static Future<List<Note>> loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notesString = prefs.getString(_notesKey);

      if (notesString == null || notesString.isEmpty) {
        return [];
      }

      final List<dynamic> notesJson = jsonDecode(notesString);
      return notesJson.map((json) => Note.fromJson(json)).toList();
    } catch (e) {
      print('Erreur lors du chargement: $e');
      return [];
    }
  }

  // Effacer toutes les notes
  static Future<void> clearNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notesKey);
    } catch (e) {
      print('Erreur lors de la suppression: $e');
    }
  }
}
