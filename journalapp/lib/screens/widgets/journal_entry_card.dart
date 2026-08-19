import 'package:flutter/material.dart';
import 'package:journalapp/Data/journal_entry_modal.dart';

class JournalEntryCard extends StatelessWidget {
  final JournalEntryModal entry;
  final VoidCallback? onDelete;

  const JournalEntryCard({
    super.key,
    required this.entry,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: const Color.fromARGB(255, 210, 233, 178),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Expanded(
                 child: Text(
                   entry.title,
                   style: const TextStyle(
                       fontSize: 20, fontWeight: FontWeight.bold),
                 ),
               ),
               if (onDelete != null)
                 IconButton(
                   onPressed: onDelete,
                   icon: const Icon(Icons.delete_outline, color: Colors.red),
                   tooltip: 'Delete entry',
                 ),
             ],
            ),
            const SizedBox(height: 8),
            Text(entry.content,
               style: const TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 8),
            Text(entry.date, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 8),
            Text("Purchase: \$${entry.purchase}",
               style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}