import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/common/flowva_text_field.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';



class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstName=TextEditingController();
  final lastName=TextEditingController();
  final address=TextEditingController();
  final phoneNumber=TextEditingController();

  final List<String> countries = ['Nigeria', 'Ghana', 'Kenya'];
  final List<String> cities = ['Bwari', 'Kuje', 'Gwagwalada'];
  final List<String> states = ['Federal Capital Territory', 'Lagos', 'Kano'];

  String? selectedCountry = 'Nigeria';
  String? selectedCity = 'Bwari';
  String? selectedState = 'Federal Capital Territory';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: ()=>Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.black)),
        title:  Text('Delivery Address',
            style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 20
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Country/Region

              Row(
                children: [
                   Text('Country/Region ',
                      style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                        fontSize: 12
                      )),
                  const Text(' *',
                      style: TextStyle(color: Color(0xFFFF8687))),
                ],
              ),
              const SizedBox(height: 8),
              _buildDropdownField(

                value: selectedCountry,
                items: countries,
                onChanged: (val) => setState(() => selectedCountry = val),
              ),
              const SizedBox(height: 16),

              // First Name

              Row(
                children: [
                   Text('First name',
                      style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 12
                      )),
                  const Text(' *',
                      style: TextStyle(color: Color(0xFFFF8687))),
                ],
              ),
              const SizedBox(height: 8),
              _buildTextField(name: firstName, hint: 'James'),
              const SizedBox(height: 16),

              // Last Name
              Row(
                children: [
                   Text('Last name',
                       style: GoogleFonts.dmSans(
                           fontWeight: FontWeight.w500,
                           fontSize: 12
                       )),
                  const Text(' *',
                      style: TextStyle(color: Color(0xFFFF8687))),
                ],
              ),

              const SizedBox(height: 8),
              _buildTextField(name:lastName, hint: 'Martins'),
              const SizedBox(height: 16),

              // Phone Number
              Row(
                children: [
                   Text('Phone number',
                      style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 12
                      )),
                  const Text(' *',
                      style: TextStyle(color: Color(0xFFFF8687))),
                ],
              ),
              const SizedBox(height: 8),
              PhoneBox(
                onChanged: (phone) {
                  phoneNumber.text = phone!;
                },
                validator:(v){
                  {
                    if (v.length < 10||v.length>10) {
                      return 'Invalid Phone Number';
                    } else if (v.isEmpty) {
                      return "Please input phone Number";
                    }
                  }
                }
              ),
              const SizedBox(height: 16),

              // Delivery address
              Row(
                children: [
                  Text('Delivery address',
                      style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 12
                      )),
                  const Text(' *',
                      style: TextStyle(color: Color(0xFFFF8687))),
                ],
              ),
              const SizedBox(height: 8),
              _buildTextField(
                name: address,
                hint:
                'Flat 05 C9 Off Oladimeji Folorunsho Street, Katampe Road, Mpape, Abuja.',
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // City
              Row(
                children: [
                  Text('City',
                      style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 12
                      )),
                  const Text(' *',
                      style: TextStyle(color: Color(0xFFFF8687))),
                ],
              ),

              const SizedBox(height: 8),
              _buildDropdownField(

                value: selectedCity,
                items: cities,
                onChanged: (val) => setState(() => selectedCity = val),
              ),
              const SizedBox(height: 16),

              // State
              Row(
                children: [
                  Text('State',
                      style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 12
                      )),
                  const Text(' *',
                      style: TextStyle(color: Color(0xFFFF8687))),
                ],
              ),
              const SizedBox(height: 8),
              _buildDropdownField(

                value: selectedState,
                items: states,
                onChanged: (val) => setState(() => selectedState = val),
              ),
              const SizedBox(height: 30),

              // Confirm button
              SizedBox(
                width: double.infinity,
                child: FlowvaButton.blueButton(
                  name: "Confirm"
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController name,
    String? hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: name,
      decoration: InputDecoration(
        hintText: "Email address",
        hintStyle: GoogleFonts.inter(
          fontSize: 12,
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
          borderRadius: BorderRadius.circular(8),

          borderSide: BorderSide(
            width: 0.5,
            color: Colors.grey.shade500,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),

          borderSide: BorderSide(
            width: 0.5,
            color: Colors.grey.shade500,
          ),
        ),
      ),
      maxLines: maxLines,
      validator: RequiredValidator(
        errorText: "Email is required",
      ),
    );
  }

  Widget _buildDropdownField({

    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),

          borderSide: BorderSide(
            width: 0.5,
            color: Colors.grey.shade500,
          ),
        ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),

            borderSide: BorderSide(
              width: 0.5,
              color: Colors.grey.shade500,
            ),
          )
      ),
      icon: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: HugeIcon(icon: HugeIcons.strokeRoundedArrowDown01,size: 18,),
      ),

      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }
}
