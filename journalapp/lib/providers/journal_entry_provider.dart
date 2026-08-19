

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:journalapp/Data/journal_entry_modal.dart';
import 'package:journalapp/service/journal_entry_service.dart';

final journalServiceProvider = Provider<JournalEntryService>((ref) {
  return JournalEntryService();
});

final journalEntriesProvider = StreamProvider<List<JournalEntryModal>>((ref) {
 final service = ref.read(journalServiceProvider);
 return service.getEntries();
});