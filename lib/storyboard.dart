library storyboard;

import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

/// A material app intended to display a Storyboard.
///
/// ## Sample code
///
/// ```dart
/// runApp(new StoryboardApp([
///     new MyFancyWidgetStory(),
///     new MyBasicWidgetStory(),
/// ]));
/// ```
class StoryboardApp extends MaterialApp {
  /// Creates a new Storyboard App.
  ///
  ///  * [stories] defines the list of stories that will be combined into
  ///  a storyboard.
  StoryboardApp(List<Story> stories)
      : assert(stories != null),
        super(home: new Storyboard(stories));
}

/// A Storyboard is a widget displaying a collection of [Story] widgets.
///
/// The Storyboard is a simple [Scaffold] widget that displays its [Story]
/// widgets in vertical [ListView].
///
/// See also [StoryboardApp] for a simple Material app consisting of a single
/// Storyboard.
///
/// ## Sample code
///
/// ```dart
/// runApp(
///     new MaterialApp(
///         home: new Storyboard([
///             new MyFancyWidgetStory(),
///             new MyBasicWidgetStory(),
///         ])));
/// ```
class Storyboard extends StatelessWidget {
  final _kStoryBoardTitle = "Storyboard";

  Storyboard(this.stories)
      : assert(stories != null),
        super();

  final List<Story> stories;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(_kStoryBoardTitle)),
        body: new ListView.builder(
          itemBuilder: (BuildContext context, int index) => stories[index],
          itemCount: stories.length,
        ));
  }
}

/// A Story widget is intended as a single "page" of a [Storyboard].  It is
/// intended that authors write their own concrete implementations of Stories
/// to include in a [Storyboard].
///
/// A story consists of one or more Widgets.  Each Story is rendered as either
/// a [ExpansionTile] or, in the case when there exists only a single
/// fullscreen widget, as [ListTile].
///
/// The story's Widget children are arranged as a series of [Row]s within an
/// ExpansionTile, or if the widget is full screen, is displayed by navigating
/// to a new route.
abstract class Story extends StatelessWidget {
  const Story({Key key}) : super(key: key);

  List<Widget> get storyContent;

  String get title => new ReCase(runtimeType.toString()).titleCase;

  bool get isFullScreen => false;

  Widget _widgetListItem(Widget w) =>
      new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        new Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0), child: w)
      ]);

  Widget _widgetTileLauncher(Widget w, String title, BuildContext context) =>
      new ListTile(
          leading: const Icon(Icons.launch),
          title: new Text(title),
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute<Null>(builder: (BuildContext context) {
              return w;
            }));
          });

  @override
  Widget build(BuildContext context) {
    if (!isFullScreen) {
      return new ExpansionTile(
        leading: const Icon(Icons.list),
        key: new PageStorageKey<Story>(this),
        title: new Text(title),
        children: storyContent.map(_widgetListItem).toList(),
      );
    } else {
      if (storyContent.length == 1) {
        return _widgetTileLauncher(storyContent[0], title, context);
      } else {
        return new ExpansionTile(
          leading: const Icon(Icons.fullscreen),
          key: new PageStorageKey<Story>(this),
          title: new Text(title),
          children: storyContent
              .map((Widget w) => _widgetTileLauncher(w, title, context))
              .toList(),
        );
      }
    }
  }
}

/// A convenience abstract class for implementing a full screen [Story].
abstract class FullScreenStory extends Story {
  bool get isFullScreen => true;
}
