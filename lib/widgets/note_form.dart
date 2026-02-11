import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteForm extends StatefulWidget {
  final Function(Note) onNoteAdded;

  const NoteForm({
    Key? key,
    required this.onNoteAdded,
  }) : super(key: key);

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final TextEditingController _matiereController = TextEditingController();
  final TextEditingController _controleController = TextEditingController();
  final TextEditingController _examenController = TextEditingController();
  final TextEditingController _coefficientController = TextEditingController();

  void _ajouterNote() {
    // Validation des champs
    if (_matiereController.text.isEmpty ||
        _controleController.text.isEmpty ||
        _examenController.text.isEmpty) {
      _showError('Veuillez remplir tous les champs obligatoires');
      return;
    }

    final noteControle = double.tryParse(_controleController.text);
    final noteExamen = double.tryParse(_examenController.text);

    if (noteControle == null || noteControle < 0 || noteControle > 20) {
      _showError('Note de contrôle invalide (0-20)');
      return;
    }

    if (noteExamen == null || noteExamen < 0 || noteExamen > 20) {
      _showError('Note d\'examen invalide (0-20)');
      return;
    }

    final coefficient = _coefficientController.text.isEmpty
        ? 1
        : (int.tryParse(_coefficientController.text) ?? 1);

    if (coefficient <= 0) {
      _showError('Le coefficient doit être supérieur à 0');
      return;
    }

    // Créer et ajouter la note
    final note = Note(
      matiere: _matiereController.text,
      noteControle: noteControle,
      noteExamen: noteExamen,
      coefficient: coefficient,
    );

    widget.onNoteAdded(note);

    // Réinitialiser le formulaire
    _matiereController.clear();
    _controleController.clear();
    _examenController.clear();
    _coefficientController.clear();

    _showSuccess('Note ajoutée avec succès !');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.add_circle, color: Colors.teal.shade700, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Ajouter une note',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _matiereController,
              decoration: InputDecoration(
                labelText: 'Matière *',
                hintText: 'Ex: Base de données',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.book),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controleController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Contrôle (40%) *',
                      hintText: '0-20',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.assignment),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _examenController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Examen (60%) *',
                      hintText: '0-20',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.edit_note),
                      filled: true,
                      fillColor: Colors.orange.shade50,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _coefficientController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Coefficient',
                hintText: '1 par défaut',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.opacity),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _ajouterNote,
                icon: const Icon(Icons.add),
                label: const Text(
                  'Ajouter la note',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _matiereController.dispose();
    _controleController.dispose();
    _examenController.dispose();
    _coefficientController.dispose();
    super.dispose();
  }
}
