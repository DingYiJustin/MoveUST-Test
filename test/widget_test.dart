// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/RedemptionPage/Encryption.dart';
import 'package:flutter_application_1/RedemptionPage/Redemption_Page.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  group('QR code widget', () {
    // testWidgets('Renders QR code with correct data', (WidgetTester tester) async {
    //   final mockData = AESEncryption.encryptMsg(jsonEncode({
    //     "user_id" : "0001",
    //     "redemption_time": "2019-09-26T16:17:24+05:00",
    //     "point": "500"})).getByte();
    //   await tester.pumpWidget(RedemptionPage(data: mockData));
    //   final qrCodeFinder = find.byType(QrImage);
    //   expect(qrCodeFinder, findsOneWidget);
    //   final qrCodeWidget = qrCodeFinder.evaluate().single.widget as QrImage;
    //   expect(qrCodeWidget.getData(), mockData);
    // });

    testWidgets('Renders student ID with correct format', (WidgetTester tester) async {
      final mockStudentId = '123456789';
      await tester.pumpWidget(RedemptionPage(data: jsonEncode({
        "user_id" : "0001",
        "redemption_time": "2019-09-26T16:17:24+05:00",
        "point": "500"}),));
      final studentIdFinder = find.text('Student ID: $mockStudentId');
      expect(studentIdFinder, findsOneWidget);
      // final studentIdWidget = studentIdFinder.evaluate().single.widget as Text;
      // expect(studentIdWidget.style, const TextStyle(fontWeight: FontWeight.bold));
      // expect(studentIdWidget.style?.color, equals(Colors.black));
    });

    // testWidgets('Renders student name with correct format', (WidgetTester tester) async {
    //   final mockStudentName = 'John Doe';
    //   await tester.pumpWidget(RedemptionPage(studentName: mockStudentName));
    //   final studentNameFinder = find.text(mockStudentName);
    //   expect(studentNameFinder, findsOneWidget);
    //   final studentNameWidget = studentNameFinder.evaluate().single.widget as Text;
    //   expect(studentNameWidget.style?.color, equals(Colors.grey[600]));
    // });
  });
}
