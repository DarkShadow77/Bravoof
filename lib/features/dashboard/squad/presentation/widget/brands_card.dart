import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../common/app_enum.dart';
import '../../data/model/response/brand_model.dart';
import '../bloc/brand_bloc.dart';
import '../page/brand_details_page.dart';

class BrandsCard extends StatelessWidget {
  const BrandsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h,
      child: BlocBuilder<BrandBloc, BrandState>(
        builder: (context, state) {
          List<Brand> brands = state.brands.take(5).toList();

          bool isLoading =
              state is BrandLoadingState && state.type == BrandType.fetchBrands;

          if (brands.isEmpty && isLoading) {
            return Center(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 120.w,
                    height: 150.h,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: FadeShimmer(
                            width: 120.w,
                            height: 132.h,
                            radius: 14.r,
                            baseColor: AppColors.darkPrimary05,
                            highlightColor: AppColors.grey300.withValues(
                              alpha: .25,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: FadeShimmer(
                            width: 50.w,
                            height: 50.h,
                            radius: 10000.r,
                            baseColor: AppColors.darkPrimary05,
                            highlightColor: AppColors.grey300.withValues(
                              alpha: .25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, _) => SizedBox(width: 10.w),
              ),
            );
          } else if (brands.isEmpty) {
            return Center(
              child: RichText(
                text: TextSpan(
                  text: 'No Brand Available',
                  style: TextStyles.normalRegular14(context),
                ),
              ),
            );
          } else {
            return ListView.separated(
              shrinkWrap: true,
              itemCount: brands.length,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemBuilder: (context, index) {
                Brand brand = brands[index];
                return BrandTile(brand: brand);
              },
              separatorBuilder: (_, _) => SizedBox(width: 10.w),
            );
          }
        },
      ),
    );
  }
}

class BrandTile extends StatelessWidget {
  const BrandTile({super.key, required this.brand});

  final Brand brand;

  @override
  Widget build(BuildContext context) {
    final textColor = hexToColor(brand.textColor);
    final inverseTextColor = hexToColor(brand.inverseTextColor);
    final displayCount = brand.followers.length > 5
        ? 5
        : brand.followers.length;
    return BlocBuilder<BrandBloc, BrandState>(
      builder: (context, state) {
        bool isLoading =
            state is BrandLoadingState &&
            state.type == BrandType.followUnfollowBrand &&
            state.brandId == brand.id;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BrandDetailsPage(brand: brand)),
            );
          },
          child: SizedBox(
            width: 120.w,
            height: 150.h,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 132.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 9.w,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          hexToColor(brand.gradientColor.end),
                          hexToColor(brand.gradientColor.start),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: 21.h),
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: brand.name,
                            style: TextStyles.bodyBold16(
                              context,
                            ).copyWith(color: textColor),
                          ),
                        ),
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text:
                                "${formatAmount(brand.missionCount, uniComp: true)} missions",
                            style: TextStyles.cardBold10(
                              context,
                            ).copyWith(color: textColor),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 3.h,
                                horizontal: 4.w,
                              ),
                              decoration: BoxDecoration(
                                color: textColor.withValues(alpha: .05),
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              child: Row(
                                spacing: 3.w,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ...List.generate(displayCount, (index) {
                                    final user = brand.followers[index];
                                    return Row(
                                      spacing: 2.w,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CachedImageRadius(
                                          imageUrl: user.profileImage,
                                          size: 10.r,
                                          circle: true,
                                          color: textColor.withValues(
                                            alpha: .1,
                                          ),
                                        ),
                                        if (index != displayCount - 1)
                                          Container(
                                            width: 1.w,
                                            height: 9.h,
                                            color: textColor.withValues(
                                              alpha: .1,
                                            ),
                                          ),
                                      ],
                                    );
                                  }),
                                  if (brand.followers.length < 2) ...[
                                    if (brand.followers.length > 0)
                                      Container(
                                        width: 1.w,
                                        height: 9.h,
                                        color: textColor.withValues(alpha: .1),
                                      ),
                                    SvgPicture.asset(
                                      AssetsSvgIcons.user,
                                      width: 8.w,
                                      height: 8.h,
                                      fit: BoxFit.contain,
                                      colorFilter: ColorFilter.mode(
                                        textColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ],
                                  if (brand.followers.length > 5) ...[
                                    Container(
                                      width: 1.w,
                                      height: 9.h,
                                      color: textColor.withValues(alpha: .1),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2.28.w,
                                        vertical: 1.52.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: textColor.withValues(alpha: .08),
                                        borderRadius: BorderRadius.circular(
                                          100.r,
                                        ),
                                      ),
                                      child: Row(
                                        spacing: 1.5.w,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            AssetsSvgIcons.userMultiple,
                                            width: 5.32.w,
                                            height: 5.32.h,
                                            fit: BoxFit.contain,
                                            colorFilter: ColorFilter.mode(
                                              textColor,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text:
                                                  "+${formatAmount(brand.followers.length - 5, uniComp: true)}",
                                              style:
                                                  TextStyles.smallCardSemibold8(
                                                    context,
                                                  ).copyWith(
                                                    fontSize: 4.6.sp,
                                                    color: textColor,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        IconTextButton(
                          height: 25,
                          iconSize: 12,
                          onPressed: () {
                            if (!isLoading)
                              context.read<BrandBloc>().add(
                                FollowUnfollowBrandEvent(brandId: brand.id),
                              );
                          },
                          text: brand.isFollowing
                              ? "Following"
                              : "Follow Brand",
                          textSize: 8,
                          textColor: AppColors.white,
                          paddingW: .25,
                          paddingH: .25,
                          innerShadow: textColor.withValues(alpha: .2),
                          color: brand.isFollowing
                              ? AppColors.grey550
                              : inverseTextColor,
                          innerShadowOffset: Offset(-1, 0),
                          buttonState: isLoading
                              ? AppButtonState.loading
                              : AppButtonState.idle,
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hexToColor(brand.logoBgColor),
                    ),
                    child: Center(
                      child: CachedImageRadius(
                        imageUrl: brand.logo,
                        size: 30,
                        color: Colors.transparent,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
