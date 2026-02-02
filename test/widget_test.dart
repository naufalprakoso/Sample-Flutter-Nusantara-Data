import 'package:flutter_test/flutter_test.dart';
import 'package:nusantara_data/nusantara_data.dart';
import 'package:nusantara_sample/main.dart';

void main() {
  setUpAll(() async {
    await NusantaraData.initialize();
  });

  testWidgets('App should display home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NusantaraSampleApp());

    // Verify that home screen is displayed
    expect(find.text('Nusantara Data'), findsOneWidget);
    expect(find.text('Location Picker'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Postal Code'), findsOneWidget);
    expect(find.text('Statistics'), findsOneWidget);
    expect(find.text('UI Components'), findsOneWidget);
  });
}
