import 'package:flutter/material.dart';
import 'package:bio_art_planner_v2/services/email_service.dart';

class EmailSenderScreen extends StatelessWidget {
  final EmailService emailService = EmailService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Email'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            emailService.sendEmail(
              'jaap.jordan@bioartlab.com',
              'food stock',
              'Dear Jaap, I would like to order 10kg of potatoes.',
            );
          },
          child: Text('Send Email'),
        ),
      ),
    );
  }
}