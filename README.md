A small library that simplifies widget layout and helps to remove deep nesting of flutter widgets.

## Features

- Remove deep nesting of widgets.
- Provide useful widgets with simpler control over their layout.
- Provide a wrapper widget to make layout of existing flutter widgets simpler.

## Getting started

- Install the package via "flutter pub get super_duper_widget".
- Import the library.
- You are ready to go.

## Usage

Use provided widgets with simpler layout control: 
```dart
import 'package:super_duper_widget/super_duper_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) =>
      $Page(
        appBar: $Text(isCentered: true, "Welcome"),
        [
          $List(
              borderTop: [1, Colors.green[400]!],
              marginTop: 9,
              isScrollable: true,
              [
                $ImageAsset(
                    width: 230,
                    padding: const [0, 40],
                    paddingBottom: 20,
                    "media/image1.png"
                ),

                $ImageAsset(
                    width: 230,
                    padding: const [0, 40],
                    paddingBottom: 20,
                    "media/image2.png"
                ),
              ]
          ),
        ],
      );
}
```

Wrap an existing flutter widget and use simpler layout controls:
```dart
import 'package:super_duper_widget/super_duper_widget.dart';

class SpecialImage extends StatelessWidget {
  const SpecialImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      $(
        margin: const [10, 20],
        paddingBottom: 5,
        [
          Image.asset(
              "media/image1.png"
          ),
        ],
      );
}
```

## Additional information

Currently this is just a small project to fulfill my own needs but maybe this will grow into something bigger at some point.
