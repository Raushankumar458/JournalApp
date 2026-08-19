import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntryModal {
  final String id;
  final String title;
  final String content;
  final String date;
  final int purchase;

  JournalEntryModal({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.purchase,
  });

  Map<String,dynamic> toMap(){
    return {
      "title": title,
      "content": content,
      "date": date,
      "purchase": purchase,
    };
  }

  factory JournalEntryModal.fromFirestore(DocumentSnapshot doc){
    final data = doc.data() as Map<String, dynamic>;
    return JournalEntryModal(id: doc.id, title: data['title'], content: data['content'], date: data['date'], purchase: data['purchase'] );
  }

  factory JournalEntryModal.fromJson(Map<String, dynamic> json) {
    return JournalEntryModal(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      date: json['date'] as String? ?? DateTime.now().toIso8601String(),
      purchase: (json['purchase'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'purchase': purchase,
    };
  }
}