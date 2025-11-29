import 'package:flutter/material.dart';

class ProgramStatusBadge extends StatelessWidget {
  final String status;

  const ProgramStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'completed':
        color = Colors.green;
        label = 'Tamamlandı';
        icon = Icons.check_circle;
        break;
      case 'processing':
        color = Colors.orange;
        label = 'Hazırlanıyor';
        icon = Icons.hourglass_empty;
        break;
      case 'failed':
        color = Colors.red;
        label = 'Başarısız';
        icon = Icons.error;
        break;
      default:
        color = Colors.grey;
        label = 'Bilinmiyor';
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
