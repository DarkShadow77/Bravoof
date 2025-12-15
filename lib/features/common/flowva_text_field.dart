





import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class AppTextFeild extends StatelessWidget {
   AppTextFeild(
      {super.key,
        this.hintText,
        this.controller,
        this.validator,
        this.prefixIcon,
        this.maxLength,
        this.focusNode,
        this.enable=true,
        this.maxLines=1,
        this.textInputType = TextInputType.text,
        this.onChanged});
  final String? hintText;
  final int? maxLength;
  final int? maxLines;
  final bool enable;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final TextInputType textInputType;
  final ValueChanged? onChanged;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        onChanged: onChanged,
        focusNode: focusNode,
        maxLength: maxLength,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),

            borderSide: BorderSide(
              width: 0.5,
              color: Colors.grey.shade500,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),

            borderSide: BorderSide(
              width: 0.5,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        validator: validator
    );
  }
}

class PhoneBox extends StatelessWidget {



   PhoneBox({super.key, required  this.onChanged, required this.validator});
  Function(String v) ?validator;
  Function(String? v)?onChanged;
  @override
  Widget build(BuildContext context) {
    return  IntlPhoneField(
        decoration:  InputDecoration(
          // labelText: 'Phone Number',
          hintText: "Enter Phone Number...",
          
          enabledBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 0.5,
              color: Colors.grey.shade500,
            ),
          ),
          border:OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
              color: Colors.grey.shade500,
            ),),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
        ),
        languageCode: "en",
        onChanged: (val) =>onChanged!(val.number),
        onCountryChanged: (country) {
        },
        initialCountryCode: "NG",
        dropdownIconPosition: IconPosition.trailing,
        dropdownIcon: Icon(Icons.keyboard_arrow_down_outlined),
        disableLengthCheck: true,
        validator: (v) =>validator!(v!.number));
  }



}

class AppPassword extends StatefulWidget {
   AppPassword({super.key,
  this.hintText,
  this.pass,
  this.validator,
  this.obscureText = true,
  this.isPasswordobscure = false,
  this.textInputType = TextInputType.text,
  this.onChanged});
  final TextInputType textInputType;
  final String? hintText;
  bool obscureText;
  bool isPasswordobscure;
  final ValueChanged? onChanged;
  final FormFieldValidator<String>? validator;
  final TextEditingController? pass;

  @override
  State<AppPassword> createState() => _AppPasswordState();
}

class _AppPasswordState extends State<AppPassword> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.pass,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                !widget.obscureText
                    ? widget.obscureText = true
                    : widget.obscureText = false;
              });
            },
            icon: widget.isPasswordobscure
                ? Container(
              width: 2,
            )
                : widget.obscureText
                ? const Icon(Icons.visibility_off_outlined)
                : const Icon(Icons.visibility)),
        // suffixIcon: Image.asset(
        //   "assets/images/open_eye.png",
        //   height: 35,
        // ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 0.5,
            color: Colors.grey.shade500,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),

          borderSide: BorderSide(
            width: 0.5,
            color: Colors.grey.shade500,
          ),
        ),
      ),
      validator: (v){
        if(v!.length<0){
          return "Password is required";
        }else if(v.length<8){
          return "Password should be at least 6 character long";
        }
      },
    );
  }
}

