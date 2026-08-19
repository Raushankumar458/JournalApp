import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journalapp/Data/journal_entry_modal.dart';

class JournalEntryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addEntry(JournalEntryModal entry) async {
    final userId = _auth.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection("entries")
        .add(entry.toMap());
  }

  Future<void> deleteEntry(String entryId) async {
    final userId = _auth.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('entries')
        .doc(entryId)
        .delete();
  }

  Stream<List<JournalEntryModal>> getEntries() {
    final userId = _auth.currentUser!.uid;
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('entries')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => JournalEntryModal.fromFirestore(doc))
            .toList());
  }
}