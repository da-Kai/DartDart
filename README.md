# <img src="assets/icons/icon-colored.svg" width=25pt height=25pt></img> DartDart

DartDart, The Dart-Scoreboard App, is built using flutter and dart and is intended to be simple, modern and ad-free. It alows you to keep track of your dart games.

## Gamemodes

- X01
- Cricked (Planned)
- Round the Clock (Planned)

## Build

Update Icons with `flutter pub run flutter_launcher_icons`

### Android
```bash
flutter build apk 
```

### Web
```bash
flutter build web --base-href '/'
```

## Testing

### Web
```bash
flutter run -d "$BROWER" --web-renderer html
```

https://docs.flutter.dev/get-started/install/windows/desktop?tab=download

https://developer.android.com/studio/install