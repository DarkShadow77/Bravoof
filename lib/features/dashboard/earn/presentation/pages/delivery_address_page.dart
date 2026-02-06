import 'package:Bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:Bravoo/features/common/flowva_text_field.dart';
import 'package:Bravoo/features/dashboard/home/presentation/bloc/campaign_bloc.dart';
import 'package:country_state_city/models/city.dart';
import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/models/state.dart' as ss;
import 'package:country_state_city/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/bottom_modals/country_state_modal.dart';
import '../../../../../app/view/widgets/dialog/success_dialog.dart';
import '../../../../../app/view/widgets/loading/outer_loading.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../../home/data/model/campaign_response.dart';
import '../../../nav_bar.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key, required this.campaign});

  final CampaignResponseModel campaign;

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen>
    with UIToolMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  bool stateWait = false;
  bool cityWait = false;

  String isoCode = "";
  String stateIsoCode = "";

  List<Country> countriesList = [];
  List<ss.State> stateList = [];
  List<City> cityList = [];

  Country countryCode = Country(
    name: "United States",
    flag: "🇺🇸",
    isoCode: "US",
    currency: "USD",
    phoneCode: "+1",
    longitude: "-97.00000000",
    latitude: "38.00000000",
  );

  @override
  void initState() {
    super.initState();
    getCountries();

    // Add listeners to validate on change
    _countryController.addListener(_validateForm);
    _firstNameController.addListener(_validateForm);
    _lastNameController.addListener(_validateForm);
    _addressController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _stateController.addListener(_validateForm);
    _cityController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _countryController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> getCountries() async {
    countriesList = await getAllCountries();
    setState(() {});
  }

  Future<void> getStates() async {
    setState(() => stateWait = true);

    final states = await getStatesOfCountry(isoCode);

    setState(() {
      stateList = states;
      stateWait = false;
    });
  }

  Future<void> getCities() async {
    setState(() => cityWait = true);

    final cities = await getStateCities(isoCode, stateIsoCode);

    // Clean up counties in one go
    final filtered = cities
        .where((city) => !city.name.toLowerCase().contains("county"))
        .toList();

    setState(() {
      cityList = filtered;
      cityWait = false;
    });
  }

  void _validateForm() {
    setState(() {}); // Trigger rebuild to update button color
  }

  bool _isFormValid() {
    return _countryController.text.isNotEmpty &&
        _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _stateController.text.isNotEmpty &&
        _cityController.text.isNotEmpty;
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final phone =
          "${countryCode.phoneCode.toString().startsWith("+") ? "" : "+"}"
          "${countryCode.phoneCode}"
          "${_phoneController.text.trim()}";

      context.read<CampaignBloc>().add(
        ClaimWinnerReward(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phoneNumber: phone,
          country: _countryController.text.trim(),
          deliveryAddress: _addressController.text.trim(),
          city: _cityController.text.trim(),
          state: _stateController.text.trim(),
        ),
      );
    }
  }

  _loadingState(BuildContext context, CampaignLoadingState state) {
    if (state.type == CampaignType.claimWinnerReward) {
      outerLoadingDialog(text: "Claiming Reward");
    }
  }

  _successState(BuildContext context, CampaignSuccessState state) {
    if (state.type == CampaignType.claimWinnerReward) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      context.read<ProfileBloc>().add(GetProfileEvent());
      successDialog(
        title: "Details Received",
        subTitle: "Thank you! We’ll let you know once it’s sent.",
        mainBtnText: "Done",
        mainBtnPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => BottomNavBar(index: 0, missionIndex: 0),
            ),
            (route) => false,
          );
        },
      );
    }
  }

  _failureState(BuildContext context, CampaignFailureState state) {
    if (state.type == CampaignType.claimWinnerReward) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      showMessage(
        state.message,
        context,
        color: Colors.white,
        styleColor: Colors.black,
        iconColor: Colors.red,
        status: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFormValid = _isFormValid();
    return BlocListener<CampaignBloc, CampaignState>(
      listener: (context, state) {
        if (state is CampaignLoadingState) {
          _loadingState(context, state);
        }
        if (state is CampaignSuccessState) {
          _successState(context, state);
        }
        if (state is CampaignFailureState) {
          _failureState(context, state);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              spacing: 10.w,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back, color: Colors.black),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Delivery Address',
                    style: TextStyles.titleSemiBold20(context),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Country/Region
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Country/Region "),
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: AppColors.redBrown),
                      ),
                    ],
                    style: TextStyles.smallMedium12(context),
                  ),
                ),
                SizedBox(height: 8.h),
                AppTextFeild(
                  readOnly: true,
                  controller: _countryController,
                  hintText: "Select Country",
                  textInputType: TextInputType.number,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Country is required"),
                  ]).call,
                  onTap: () {
                    countryStateModal(
                      title: "Country",
                      onPressed: (value) {
                        if (value != null) {
                          setState(() {
                            _countryController.text = value.name;
                            isoCode = value.isoCode;
                            _stateController.text = "";
                            _cityController.text = "";
                          });
                          getStates();
                          if (_phoneController.text.isEmpty) {
                            setState(() => countryCode = value);
                          }
                        }
                      },
                      list: countriesList,
                    );
                  },
                ),
                SizedBox(height: 20.h),
                // First Name
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(text: "First Name "),
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: AppColors.redBrown),
                      ),
                    ],
                    style: TextStyles.smallMedium12(context),
                  ),
                ),
                SizedBox(height: 8.h),
                AppTextFeild(
                  controller: _firstNameController,
                  hintText: "James",
                  textInputType: TextInputType.text,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "First Name is required"),
                  ]).call,
                ),
                SizedBox(height: 20.h),
                // Last Name
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Last Name "),
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: AppColors.redBrown),
                      ),
                    ],
                    style: TextStyles.smallMedium12(context),
                  ),
                ),
                SizedBox(height: 8.h),
                AppTextFeild(
                  controller: _lastNameController,
                  hintText: "Martins",
                  textInputType: TextInputType.text,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Last Name is required"),
                  ]).call,
                ),
                SizedBox(height: 20.h),
                // Phone Number
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Phone number"),
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: AppColors.redBrown),
                      ),
                    ],
                    style: TextStyles.smallMedium12(context),
                  ),
                ),
                SizedBox(height: 8.h),
                AppTextFeild(
                  controller: _phoneController,
                  hintText: "Enter your phone number",
                  textInputType: TextInputType.number,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Phone Number is required"),
                  ]).call,
                  prefixIcon: IntrinsicHeight(
                    child: GestureDetector(
                      onTap: () {
                        getCountries();
                        countryStateModal(
                          title: "Country Code",
                          isPhone: true,
                          onPressed: (val) {
                            if (val != null) setState(() => countryCode = val);
                          },
                          list: countriesList,
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          spacing: 5.w,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: countryCode.flag,
                                style: TextStyles.normalMedium14(context),
                              ),
                            ),
                            Flexible(
                              child: RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text:
                                      "${countryCode.phoneCode.toString().startsWith("+") ? "" : "+"} ${countryCode.phoneCode}",
                                  style: TextStyles.normalMedium14(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                //Delivery Address
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Delivery Address"),
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: AppColors.redBrown),
                      ),
                    ],
                    style: TextStyles.smallMedium12(context),
                  ),
                ),
                SizedBox(height: 8.h),
                AppTextFeild(
                  maxLines: 4,
                  controller: _addressController,
                  hintText: "Enter your Delivery Address",
                  textInputType: TextInputType.text,
                  validator: MultiValidator([
                    RequiredValidator(
                      errorText: "Delivery Address is required",
                    ),
                  ]).call,
                ),
                SizedBox(height: 20.h),
                if (!stateWait && _countryController.text.isNotEmpty) ...[
                  // State
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(text: "State "),
                        TextSpan(
                          text: " *",
                          style: TextStyle(color: AppColors.redBrown),
                        ),
                      ],
                      style: TextStyles.smallMedium12(context),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  AppTextFeild(
                    enable: !stateWait,
                    readOnly: true,
                    controller: _stateController,
                    hintText: "Select State",
                    textInputType: TextInputType.number,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "State is required"),
                    ]).call,
                    onTap: () {
                      countryStateModal(
                        title: "State",
                        onPressed: (value) {
                          if (value != null) {
                            setState(() {
                              _stateController.text = value.name;
                              stateIsoCode = value.isoCode;
                              _cityController.text = "";
                            });
                            getCities();
                          }
                        },
                        list: stateList,
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
                if (!cityWait && _stateController.text.isNotEmpty) ...[
                  // City
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(text: "City "),
                        TextSpan(
                          text: " *",
                          style: TextStyle(color: AppColors.redBrown),
                        ),
                      ],
                      style: TextStyles.smallMedium12(context),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  AppTextFeild(
                    enable: !cityWait,
                    readOnly: true,
                    controller: _cityController,
                    hintText: "Select City",
                    textInputType: TextInputType.number,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "City is required"),
                    ]).call,
                    onTap: () {
                      countryStateModal(
                        title: "City",
                        onPressed: (value) {
                          if (value != null) {
                            setState(() {
                              _cityController.text = value.name;
                            });
                          }
                        },
                        list: cityList,
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
                // Confirm button
                IconTextButton(
                  height: 54,
                  onPressed: () => {if (isFormValid) _handleSubmit()},
                  text: "Confirm",
                  color: isFormValid ? AppColors.black : AppColors.grey200,
                  textColor: AppColors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
