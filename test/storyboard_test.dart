import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyboard/storyboard.dart';

class IconFaceNatureStory extends Story {
  @override
  List<Widget> get storyContent =>
      [const Icon(Icons.face), const Icon(Icons.nature)];
}

class IconHomePhotostory extends Story {
  @override
  List<Widget> get storyContent =>
      [const Icon(Icons.home), const Icon(Icons.photo)];
}

class IconFullscreenStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        new SimpleDialog(
            children: [const Icon(Icons.cloud), const Icon(Icons.local_drink)]),
      ];
}

class IconFullscreenMultiStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        new SimpleDialog(
            children: [const Icon(Icons.alarm), const Icon(Icons.android)]),
        new SimpleDialog(
            children: [const Icon(Icons.ac_unit), const Icon(Icons.block)]),
      ];
}

void main() {
  testWidgets('Storybook scaffold test', (WidgetTester tester) async {
    await tester.pumpWidget(new StoryboardApp([new IconFaceNatureStory()]));
    await tester.pump(); // triggers a frame
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('Single story test', (WidgetTester tester) async {
    await tester.pumpWidget(new StoryboardApp([new IconFaceNatureStory()]));
    await tester.pump(); // triggers a frame

    Finder expTileFinder = find.byType(ExpansionTile);
    expect(expTileFinder, findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
    await tester.tap(expTileFinder);
    await tester.pump(); // start animation
    expect(find.byIcon(Icons.face, skipOffstage: true), findsOneWidget);
    expect(find.byIcon(Icons.nature, skipOffstage: true), findsOneWidget);
  });

  testWidgets('Two story test', (WidgetTester tester) async {
    await tester.pumpWidget(new StoryboardApp(
        [new IconFaceNatureStory(), new IconHomePhotostory()]));
    await tester.pump(); // triggers a frame

    Finder expTileFinder = find.byType(ExpansionTile);
    expect(expTileFinder, findsNWidgets(2));
    expect(find.byType(ListTile), findsNWidgets(2));
    await tester.tap(expTileFinder.first);
    await tester.pump(); // start animation
    expect(find.byIcon(Icons.face, skipOffstage: true), findsOneWidget);
    expect(find.byIcon(Icons.nature, skipOffstage: true), findsOneWidget);
    await tester.tap(expTileFinder.last);
    await tester.pump(); // start animation
    expect(find.byIcon(Icons.home, skipOffstage: true), findsOneWidget);
    expect(find.byIcon(Icons.photo, skipOffstage: true), findsOneWidget);
  });

  testWidgets('Fullscreen single widget story ', (WidgetTester tester) async {
    await tester.pumpWidget(new StoryboardApp([new IconFullscreenStory()]));
    await tester.pump(); // triggers a frame

    Finder expTileFinder = find.byType(ExpansionTile);
    expect(expTileFinder, findsNothing);
    Finder listTileFinder = find.byType(ListTile);
    expect(listTileFinder, findsOneWidget);
    await tester.tap(listTileFinder);
    await tester.pump(); // start animation
    await tester.pump(const Duration(seconds: 1)); // end animation
    expect(find.byIcon(Icons.local_drink), findsOneWidget);
    expect(find.byIcon(Icons.cloud), findsOneWidget);
  });

  testWidgets('Fullscreen multi widget story ', (WidgetTester tester) async {
    await tester.pumpWidget(new StoryboardApp(
        [new IconFullscreenStory(), new IconFullscreenMultiStory()]));
    await tester.pump(); // triggers a frame

    Finder expTileFinder = find.byType(ExpansionTile);
    expect(expTileFinder, findsOneWidget);
    Finder listTileFinder = find.byType(ListTile);
    expect(listTileFinder, findsNWidgets(2));
    await tester.tap(expTileFinder);
    await tester.pump(); // start animation
    await tester.pump(const Duration(seconds: 1)); // end animation
    Finder childListFinder = find.byType(ListTile);
    expect(childListFinder, findsNWidgets(4));
    await tester.tap(childListFinder.last);
    await tester.pump(); // start animation
    await tester.pump(const Duration(seconds: 1)); // end animation
    expect(find.byIcon(Icons.ac_unit), findsOneWidget);
    expect(find.byIcon(Icons.block), findsOneWidget);
    expect(find.byIcon(Icons.alarm), findsNothing);
    expect(find.byIcon(Icons.android), findsNothing);
  });
}
