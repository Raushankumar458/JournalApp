import 'package:flutter/material.dart';
import 'package:journalapp/Data/journal_entry_modal.dart';

class AddEntryBottomSheet extends StatefulWidget {
  final Function(JournalEntryModal) onSave;

 const AddEntryBottomSheet({super.key, required this.onSave});

 @override
 State<AddEntryBottomSheet> createState() => _AddEntryBottomSheetState();
}

class _AddEntryBottomSheetState extends State<AddEntryBottomSheet> {
 final TextEditingController _titleEditingController = TextEditingController();
 final TextEditingController _contentEditingController = TextEditingController();

 void _clearFields() {
   _titleEditingController.clear();
   _contentEditingController.clear();
 }

 void _saveEntry() {
   final title = _titleEditingController.text.trim();
   final content = _contentEditingController.text.trim();

   if (title.isEmpty || content.isEmpty) {
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
         content: Text('Please enter both title and content.'),
       ),
     );
     return;
   }

   final entry = JournalEntryModal(
     id: DateTime.now().millisecondsSinceEpoch.toString(),
     title: title,
     content: content,
     date: DateTime.now().toIso8601String(),
     purchase: 0,
   );

   widget.onSave(entry);
   _clearFields();
   Navigator.pop(context);
 }

 @override
 void dispose() {
   _titleEditingController.dispose();
   _contentEditingController.dispose();
   super.dispose();
 }

 @override
 Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.all(8.0),
     child: Container(
       color: Colors.white,
       padding: const EdgeInsets.all(20),
       child: Column(
         children: [
           TextField(
             controller: _titleEditingController,
             decoration: const InputDecoration(
               border: OutlineInputBorder(),
               labelText: 'Title',
             ),
           ),
           const SizedBox(height: 16),
           TextField(
             controller: _contentEditingController,
             maxLines: 4,
             decoration: const InputDecoration(
               border: OutlineInputBorder(),
               labelText: 'content',
             ),
           ),
           const SizedBox(height: 16),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               OutlinedButton(
                 onPressed: () {
                   Navigator.pop(context);
                 },
                 child: const Text(
                   'cancel',
                   style: TextStyle(color: Colors.red),
                 ),
               ),
               ElevatedButton(
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.green,
                 ),
                 onPressed: _saveEntry,
                 child: const Text(
                   'save',
                   style: TextStyle(color: Colors.white),
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