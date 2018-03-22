# Storyboard

[![pub package](https://img.shields.io/pub/v/storyboard.svg)](https://pub.dartlang.org/packages/storyboard)

Faster iterative development of Flutter user interfaces by isolating widgets from your app, inspired by [Storybook](https://storybook.js.org/). Stage a collection of Widgets outside their normal app context.  By repeating the same widget in various configurations or states in a single view, the effect of code changes to the Widget can quickly be assessed. This is especially useful for cosmetic changes, but also effective for behavior changes.

## Adding Stories

The first step is to build a few stories, from which your Storyboard will be composed. Building stories is done by providing concrete children of the Story abstract class, e.g.


```dart
import 'package:mypackage/contacts.dart';
import 'package:storyboard/storyboard.dart';

class ContactsListStory extends Story {

  @override
  List<Widget> get storyContent {
    return [new ContactsList()];
  }
}
```

At a minimum, the abstract ```storyContent``` getter, which provides the widgets to be observed, must be overridden.  Overriding the ```title``` will alter the heading presented for the story.  Overriding ```isFullScreen``` (or implementing ```FullScreenStory```) will instruct the Widget to render itself within a new Navigator route without scaffolding.

The ```build``` method itself can also be overridden to completely customize the display of the Story.


## Building a Storyboard

A storyboard is little more than a collection of stories.  
```dart
import 'package:flutter/material.dart';
import 'package:storyboard/storyboard.dart';
import 'stories/contacts_story.dart';

void main() {
  runApp(new MaterialApp(
      home: new Storyboard([
        new ContactsListStory(),
        new ContactsCardStory(contact: new Contact("alice")),
        new ContactsCardStory(contact: new Contact("bob")),
        new ContactsCardStory(contact: new Contact("charlie")),
  ])));
}
```

Or more simply, run the convenience ```StoryboardApp``` directly.

```dart
void main() {
  runApp(new StoryboardApp([
    new ContactsListStory(),
    new ContactsCardStory(contact: new Contact("alice")),
    new ContactsCardStory(contact: new Contact("bob")),
    new ContactsCardStory(contact: new Contact("charlie")),
  ]));
}
```


## Further reading

See the article [Storyboarding Widgets in Flutter](https://proandroiddev.com/storyboarding-widgets-in-flutter-96d79d9a72f0).
