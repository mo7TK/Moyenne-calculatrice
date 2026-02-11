import 'package:flutter/material.dart';

class MoyenneDisplay extends StatelessWidget {
  final double moyenne;
  final int totalCoefficients;

  const MoyenneDisplay({
    Key? key,
    required this.moyenne,
    required this.totalCoefficients,
  }) : super(key: key);

  Color _getCouleurMoyenne() {
    if (moyenne >= 16) return Colors.green;
    if (moyenne >= 14) return Colors.lightGreen;
    if (moyenne >= 12) return Colors.orange;
    if (moyenne >= 10) return Colors.deepOrange;
    return Colors.red;
  }

  String _getMention() {
    if (moyenne >= 16) return 'Très Bien';
    if (moyenne >= 14) return 'Bien';
    if (moyenne >= 12) return 'Assez Bien';
    if (moyenne >= 10) return 'Passable';
    return 'Insuffisant';
  }

  IconData _getIcon() {
    if (moyenne >= 16) return Icons.emoji_events;
    if (moyenne >= 14) return Icons.star;
    if (moyenne >= 12) return Icons.thumb_up;
    if (moyenne >= 10) return Icons.check_circle;
    return Icons.warning;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getCouleurMoyenne().withOpacity(0.1),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              _getIcon(),
              size: 48,
              color: _getCouleurMoyenne(),
            ),
            const SizedBox(height: 12),
            const Text(
              'Votre Moyenne',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              moyenne.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: _getCouleurMoyenne(),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '/ 20',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: _getCouleurMoyenne().withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getMention(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: _getCouleurMoyenne(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calculate, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  'Total des coefficients: $totalCoefficients',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
