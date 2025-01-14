import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailService {
  Future<void> sendEmail(String recipient, String subject, String body) async {
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: [recipient],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      print('Email sent successfully');
    } catch (error) {
      print('Failed to send email: $error');
    }
  }
}