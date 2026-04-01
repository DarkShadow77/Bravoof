part of 'brand_bloc.dart';

enum BrandType { fetchBrands, followUnfollowBrand }

@immutable
class BrandState {
  final List<Brand> brands;

  BrandState({required this.brands});

  BrandState copWith({List<Brand>? brands}) {
    return BrandState(brands: brands ?? this.brands);
  }
}

class BrandInitialState extends BrandState {
  BrandInitialState({required super.brands});
}

class BrandLoadingState extends BrandState {
  final String? brandId;
  final BrandType type;
  BrandLoadingState({this.brandId, required this.type, required super.brands});
}

class BrandErrorState extends BrandState {
  final String? brandId;
  final String message;
  final BrandType type;
  BrandErrorState({
    this.brandId,
    required this.message,
    required this.type,
    required super.brands,
  });
}

class BrandSuccessState extends BrandState {
  final String? brandId;
  final String message;
  final BrandType type;
  BrandSuccessState({
    this.brandId,
    required this.message,
    required this.type,
    required super.brands,
  });
}
