import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onDelete;

  const NoteCard({
    Key? key,
    required this.note,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor:
              note.estValide ? Colors.green.shade100 : Colors.red.shade100,
          child: Text(
            note.noteFinale.toStringAsFixed(1),
            style: TextStyle(
              color:
                  note.estValide ? Colors.green.shade900 : Colors.red.shade900,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        title: Text(
          note.matiere,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text('Coefficient: ${note.coefficient}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildDetailRow(
                  'Contrôle Continu (40%)',
                  note.noteControle,
                  Colors.blue,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  'Examen (60%)',
                  note.noteExamen,
                  Colors.orange,
                ),
                const Divider(height: 24),
                _buildDetailRow(
                  'Note Finale',
                  note.noteFinale,
                  note.estValide ? Colors.green : Colors.red,
                  isBold: true,
                ),
                const SizedBox(height: 4),
                Text(
                  'Note pondérée: ${note.notePonderee.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, double value, Color color,
      {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: isBold ? 18 : 16,
            ),
          ),
        ),
      ],
    );
  }
}
