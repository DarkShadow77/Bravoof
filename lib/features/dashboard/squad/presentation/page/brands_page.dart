import 'package:bravoo/features/dashboard/squad/data/model/response/brand_model.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../bloc/brand_bloc.dart';
import '../widget/brands_card.dart';

class BrandsPage extends StatefulWidget {
  const BrandsPage({super.key});

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<BrandBloc>();
    bloc.add(FetchBrandsEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.black05,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowLeft02,
                  color: Colors.black,
                  strokeWidth: 1.5,
                ),
              ),
            ),
            Expanded(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Brands",
                  style: TextStyles.titleSemiBold20(context),
                ),
              ),
            ),
            Opacity(
              opacity: 0,
              child: CircleAvatar(
                backgroundColor: AppColors.black05,
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowLeft02,
                  color: Colors.black,
                  strokeWidth: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/earn_bg.png", fit: BoxFit.fill),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: kToolbarHeight + MediaQuery.of(context).padding.top,
              ),
              Expanded(
                child: BlocBuilder<BrandBloc, BrandState>(
                  builder: (context, state) {
                    List<Brand> brands = state.brands;
                    bool isLoading =
                        state is BrandLoadingState &&
                        state.type == BrandType.fetchBrands;

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<BrandBloc>().add(FetchBrandsEvent());
                        // Wait until the bloc emits a non-loading state
                        await context.read<BrandBloc>().stream.firstWhere(
                          (s) =>
                              s is BrandLoadingState &&
                                  s.type == BrandType.fetchBrands ||
                              s is BrandErrorState &&
                                  s.type == BrandType.fetchBrands,
                        );
                      },
                      child: CustomScrollView(
                        physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        slivers: [
                          if (isLoading && brands.isEmpty)
                            SliverPadding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              sliver: SliverGrid.builder(
                                itemCount: 9,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: FadeShimmer(
                                          width: 120.w,
                                          height: 132.h,
                                          radius: 14.r,
                                          baseColor: AppColors.darkPrimary05,
                                          highlightColor: AppColors.grey300
                                              .withValues(alpha: .25),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: FadeShimmer(
                                          width: 50.w,
                                          height: 50.h,
                                          radius: 10000.r,
                                          baseColor: AppColors.darkPrimary05,
                                          highlightColor: AppColors.grey300
                                              .withValues(alpha: .25),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 120.w,
                                      mainAxisExtent: 150.h,
                                      crossAxisSpacing: 10.w,
                                      mainAxisSpacing: 12.h,
                                    ),
                              ),
                            )
                          else if (brands.isEmpty)
                            SliverPadding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              sliver: SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                      text: "No Brands",
                                      style: TextStyles.bodyMedium16(
                                        context,
                                        opacity: .65,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else
                            SliverPadding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              sliver: SliverGrid.builder(
                                itemCount: brands.length,
                                itemBuilder: (context, index) {
                                  Brand brand = brands[index];
                                  return BrandTile(brand: brand);
                                },
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 120.w,
                                      mainAxisExtent: 150.h,
                                      crossAxisSpacing: 10.w,
                                      mainAxisSpacing: 12.h,
                                    ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
