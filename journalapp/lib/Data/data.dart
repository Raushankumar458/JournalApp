import 'dart:convert';

import 'package:journalapp/Data/journal_entry_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _journalEntriesKey = 'journal_entries';

List<JournalEntryModal> listOfEntry = [];

List<JournalEntryModal> _defaultEntries() {
 return [
  JournalEntryModal(
    id: '1',
    title: 'Raushan',
    content: 'Fun',
    date: '30/03/2026',
    purchase: 80000000,
  ),
  JournalEntryModal(
    id: '2',
    title: 'Raush',
    content: 'Fun or die',
    date: '30/03/2026',
    purchase: 900000,
  ),
 ];
}

Future<void> loadJournalEntries() async {
 final prefs = await SharedPreferences.getInstance();
 final savedEntries = prefs.getStringList(_journalEntriesKey);

 if (savedEntries == null || savedEntries.isEmpty) {
  listOfEntry = _defaultEntries();
  await saveJournalEntries();
  return;
 }

 listOfEntry = savedEntries
    .map((entry) {
      final decoded = jsonDecode(entry);
      if (decoded is Map<String, dynamic>) {
        return JournalEntryModal.fromJson(decoded);
      }
      return null;
    })
    .whereType<JournalEntryModal>()
    .toList();
}

Future<void> saveJournalEntries() async {
 final prefs = await SharedPreferences.getInstance();
 final encodedEntries = listOfEntry
    .map((entry) => jsonEncode(entry.toJson()))
    .toList();

 await prefs.setStringList(_journalEntriesKey, encodedEntries);
}