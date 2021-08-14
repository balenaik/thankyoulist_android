/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  AssetGenImage get accountCircle20 =>
      const AssetGenImage('assets/icons/account_circle_20.png');
  AssetGenImage get plus30 => const AssetGenImage('assets/icons/plus_30.png');
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  AssetGenImage get listEmpty =>
      const AssetGenImage('assets/images/list_empty.png');
  AssetGenImage get loginImage =>
      const AssetGenImage('assets/images/login_image.png');
  AssetGenImage get splashImage =>
      const AssetGenImage('assets/images/splash_image.png');
}

class Assets {
  Assets._();

  static const AssetGenImage icFacebook =
      AssetGenImage('assets/ic_facebook.png');
  static const AssetGenImage icGoogle = AssetGenImage('assets/ic_google.png');
  static const AssetGenImage icLoginScreen =
      AssetGenImage('assets/ic_login_screen.png');
  static const String icThankyoulist = 'assets/ic_thankyoulist.key';
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
