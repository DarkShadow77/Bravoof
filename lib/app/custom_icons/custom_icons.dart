import 'package:flutter_app_icon_changer/flutter_app_icon_changer.dart';

/// A class containing static instances of custom icons.
class CustomIcons {
  /// The blue background icon instance.
  static final blueBgIcon = BlueBgIcon();

  /// The mix background icon instance.
  static final mixBgIcon = MixBgIcon();

  /// The black text icon instance.
  static final blackTxtIcon = BlackTxtIcon();

  /// The purple text icon instance.
  static final purpleTxtIcon = PurpleTxtIcon();

  /// The purple background icon instance.
  static final purpleBgIcon = PurpleBgIcon();

  /// The default icon instance.
  static final defaultIcon = DefaultIcon();

  /// A list of all available [CustomIcon] instances.
  static final List<CustomIcon> list = [
    CustomIcons.defaultIcon,
    CustomIcons.purpleBgIcon,
    CustomIcons.blackTxtIcon,
    CustomIcons.purpleTxtIcon,
    CustomIcons.mixBgIcon,
    CustomIcons.blueBgIcon,
  ];
}

/// A sealed class representing a custom app icon with a preview path.
///
/// This class cannot be extended outside of its library.
sealed class CustomIcon extends AppIcon {
  /// The file path to the preview image of the icon.
  final String previewPath;

  CustomIcon({
    required this.previewPath,
    required super.iOSIcon,
    required super.androidIcon,
    required super.isDefaultIcon,
  });

  /// Creates a [CustomIcon] instance from a string [icon] name.
  ///
  /// Returns the corresponding [CustomIcon] if found;
  /// Otherwise, returns the default icon.
  factory CustomIcon.fromString(String? icon) {
    if (icon == null) return CustomIcons.defaultIcon;

    return CustomIcons.list.firstWhere(
      (e) => e.iOSIcon == icon || e.androidIcon == icon,
      orElse: () => CustomIcons.defaultIcon,
    );
  }
}

final class BlueBgIcon extends CustomIcon {
  BlueBgIcon()
    : super(
        iOSIcon: 'AppIconBlueBg',
        androidIcon: 'MainActivityBlueBg',
        previewPath: 'assets/logo/icon_blue_bg.png',
        isDefaultIcon: false,
      );
}

final class MixBgIcon extends CustomIcon {
  MixBgIcon()
    : super(
        iOSIcon: 'AppIconMixBg',
        androidIcon: 'MainActivityMixBg',
        previewPath: 'assets/logo/icon_mix_bg.png',
        isDefaultIcon: false,
      );
}

final class BlackTxtIcon extends CustomIcon {
  BlackTxtIcon()
    : super(
        iOSIcon: 'AppIconBlackTxt',
        androidIcon: 'MainActivityBlackTxt',
        previewPath: 'assets/logo/icon_black_txt.png',
        isDefaultIcon: false,
      );
}

final class PurpleTxtIcon extends CustomIcon {
  PurpleTxtIcon()
    : super(
        iOSIcon: 'AppIconPurpleTxt',
        androidIcon: 'MainActivityPurpleTxt',
        previewPath: 'assets/logo/icon_purple_txt.png',
        isDefaultIcon: false,
      );
}

final class PurpleBgIcon extends CustomIcon {
  PurpleBgIcon()
    : super(
        iOSIcon: 'AppIconPurpleBg',
        androidIcon: 'MainActivityPurpleBg',
        previewPath: 'assets/logo/icon_purple_bg.png',
        isDefaultIcon: false,
      );
}

/// A final class representing the default app icon.
final class DefaultIcon extends CustomIcon {
  DefaultIcon()
    : super(
        iOSIcon: 'AppIcon',
        androidIcon: 'MainActivityDefault',
        previewPath: 'assets/logo/icon.png',
        isDefaultIcon: true,
      );
}
