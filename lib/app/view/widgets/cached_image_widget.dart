import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';

class CachedImageRadius extends StatelessWidget {
  final String imageUrl;
  final double size;
  final Color borderColor;
  final Color? color;
  final double borderWidth;
  final double borderRadius;
  final bool circle;
  final BoxFit fit;

  const CachedImageRadius({
    super.key,
    required this.imageUrl,
    this.size = 30.0,
    this.borderColor = Colors.transparent,
    this.color,
    this.borderWidth = 1.0,
    this.borderRadius = 0.0,
    this.circle = false,
    this.fit = BoxFit.cover,
  });

  bool get _isSvg => imageUrl.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    return _isSvg ? _buildSvg() : _buildRaster();
  }

  Widget _buildRaster() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildPlaceholder(),
      imageBuilder: (context, imageProvider) => _buildContainer(
        child: Image(image: imageProvider, fit: fit),
      ),
    );
  }

  Widget _buildSvg() {
    return _buildContainer(
      child: SvgPicture.network(
        imageUrl,
        fit: fit,
        placeholderBuilder: (_) => _buildPlaceholder(),
      ),
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      height: size.h,
      width: size.w,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        border: Border.all(width: borderWidth.w, color: borderColor),
        borderRadius: circle ? null : BorderRadius.circular(borderRadius.r),
      ),
      child: child,
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: size.h,
      width: size.w,
      decoration: BoxDecoration(
        color: color ?? AppColors.grey,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        border: Border.all(width: borderWidth.w, color: borderColor),
        borderRadius: circle ? null : BorderRadius.circular(borderRadius.r),
      ),
    );
  }
}

class CachedImageSize extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final Color borderColor;
  final Color? color;
  final double borderWidth;
  final double borderRadius;
  final Widget? child;
  final BoxFit? fit;

  const CachedImageSize({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderColor = Colors.transparent,
    this.color,
    this.borderWidth = 1.0,
    this.borderRadius = 1.0,
    this.child,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      errorWidget: (context, url, error) => _buildPlaceholder(),
      placeholder: (context, url) => _buildPlaceholder(),
      imageBuilder: (context, imageProvider) {
        return Container(
          height: height.h,
          width: width.w,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(width: borderWidth.w, color: borderColor),
            borderRadius: BorderRadius.circular(borderRadius.r),
            image: DecorationImage(
              image: imageProvider,
              alignment: Alignment.center,
              fit: fit ?? BoxFit.cover,
            ),
          ),
          child: child,
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: height.h,
      width: width.w,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: color ?? AppColors.grey,
        border: Border.all(width: borderWidth.w, color: borderColor),
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      child: child,
    );
  }
}
