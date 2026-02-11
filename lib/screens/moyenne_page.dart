import 'package:flutter/material.dart';
import '../models/note.dart';
import '../widgets/moyenne_display.dart';
import '../widgets/note_form.dart';
import '../widgets/note_card.dart';
import '../services/storage_service.dart';

class MoyennePage extends StatefulWidget {
  const MoyennePage({Key? key}) : super(key: key);

  @override
  State<MoyennePage> createState() => _MoyennePageState();
}

class _MoyennePageState extends State<MoyennePage> {
  final List<Note> _notes = [];
  double? _moyenne;
  int _totalCoefficients = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerNotes();
  }

  // Charger les notes sauvegardées
  Future<void> _chargerNotes() async {
    final notes = await StorageService.loadNotes();
    setState(() {
      _notes.addAll(notes);
      _isLoading = false;
    });
    _calculerMoyenne();
  }

  // Sauvegarder les notes
  Future<void> _sauvegarderNotes() async {
    await StorageService.saveNotes(_notes);
  }

  void _ajouterNote(Note note) {
    setState(() {
      _notes.add(note);
    });
    _calculerMoyenne();
    _sauvegarderNotes(); // Sauvegarde automatique
  }

  void _calculerMoyenne() {
    if (_notes.isEmpty) {
      setState(() {
        _moyenne = null;
        _totalCoefficients = 0;
      });
      return;
    }

    // Formule: somme[((contrôle * 0.4) + (examen * 0.6)) * coefficient] / somme_coefficients
    double sommeNotesPonderees = 0;
    int sommeCoefficients = 0;

    for (var note in _notes) {
      // Note finale = (contrôle * 0.4) + (examen * 0.6)
      // Note pondérée = noteFinale * coefficient
      sommeNotesPonderees += note.notePonderee;
      sommeCoefficients += note.coefficient;
    }

    setState(() {
      _moyenne = sommeNotesPonderees / sommeCoefficients;
      _totalCoefficients = sommeCoefficients;
    });
  }

  void _supprimerNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
    _calculerMoyenne();
    _sauvegarderNotes(); // Sauvegarde automatique

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note supprimée'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _reinitialiser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content:
            const Text('Voulez-vous vraiment supprimer toutes les notes ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _notes.clear();
                _moyenne = null;
                _totalCoefficients = 0;
              });
              await StorageService.clearNotes(); // Effacer le stockage
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Toutes les notes ont été supprimées'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _afficherDetailsCalcul() {
    if (_notes.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Détails du calcul'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Formule utilisée:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Moyenne = Σ[(Contrôle × 0.4 + Examen × 0.6) × Coef] / Σ Coef',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Calcul détaillé:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._notes.map((note) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.matiere,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '  = (${note.noteControle} × 0.4 + ${note.noteExamen} × 0.6) × ${note.coefficient}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          '  = ${note.noteFinale.toStringAsFixed(2)} × ${note.coefficient} = ${note.notePonderee.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  )),
              const Divider(),
              Text(
                'Somme notes pondérées: ${_notes.fold(0.0, (sum, note) => sum + note.notePonderee).toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'Somme coefficients: $_totalCoefficients',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Moyenne finale: ${_moyenne!.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculateur de Moyenne'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          if (_moyenne != null)
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: _afficherDetailsCalcul,
              tooltip: 'Voir les détails',
            ),
          if (_notes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _reinitialiser,
              tooltip: 'Réinitialiser',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Affichage de la moyenne
                    if (_moyenne != null)
                      MoyenneDisplay(
                        moyenne: _moyenne!,
                        totalCoefficients: _totalCoefficients,
                      ),
                    if (_moyenne != null) const SizedBox(height: 20),

                    // Formulaire d'ajout
                    NoteForm(onNoteAdded: _ajouterNote),
                    const SizedBox(height: 20),

                    // Liste des notes
                    if (_notes.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Vos notes (${_notes.length})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total: $_totalCoefficients crédits',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _notes.length,
                        itemBuilder: (context, index) {
                          return NoteCard(
                            note: _notes[index],
                            onDelete: () => _supprimerNote(index),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
