import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalapp/providers/auth_provider.dart';
import 'package:journalapp/providers/journal_entry_provider.dart';
import 'package:journalapp/screens/login_screen.dart';
import 'package:journalapp/screens/widgets/add_entry_bottom_sheet.dart';
import 'package:journalapp/screens/widgets/journal_entry_card.dart';

class JournalHomeScreen extends ConsumerStatefulWidget {
 const JournalHomeScreen({super.key});

 @override
 ConsumerState<JournalHomeScreen> createState() => _JournalHomeScreenState();
}

class _JournalHomeScreenState extends ConsumerState<JournalHomeScreen> {

  void _logout() async {
   final authService =  ref.read(authServiceProvider);
   await authService.signOut();
   Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder:(context) => 
    LoginScreen(),), 
    (route) => false,
    );
  }
 @override
 Widget build(BuildContext context) {
  final entriesValue = ref.watch(journalEntriesProvider);

  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'My Daily Thoughts',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
      ],
    ),
    body: entriesValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      data: (entries) {
        if (entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.note_outlined, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'No entries yet',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Start writing your thoughts by tapping the + button',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return JournalEntryCard(
              entry: entry,
              onDelete: () async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete entry?'),
                    content: Text('Delete "${entry.title}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );

                if (shouldDelete != true) return;

                try {
                  final service = ref.read(journalServiceProvider);
                  await service.deleteEntry(entry.id);
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Failed to delete entry: $e',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            );
          },
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return AddEntryBottomSheet(
              onSave: (entry) async {
                try {
                  final service = ref.read(journalServiceProvider);
                  await service.addEntry(entry);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Failed to save entry: $e",
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            );
          },
        );
      },
      backgroundColor: const Color.fromARGB(255, 210, 233, 178),
      child: const Icon(Icons.add, color: Colors.black),
    ),
  );
 }
}