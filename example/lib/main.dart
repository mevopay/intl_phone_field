import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<FormState> _formKey = GlobalKey();
  bool submitted = false;
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Phone Field Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                TextFormField(
                  autovalidateMode: submitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Email is required';
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                IntlPhoneField(
                  autovalidateMode: submitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                  focusNode: focusNode,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]'),
                    ),
                    FilteringTextInputFormatter.deny(
                      RegExp(r'^0+'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  validator: (String? phoneNumber, String countryISOCode, String countryCode) {
                    if (phoneNumber == null || phoneNumber.isEmpty) return 'Phone number is required';
                    try {
                      if (!PhoneNumber(
                        number: phoneNumber,
                        countryCode: countryCode,
                        countryISOCode: countryISOCode,
                      ).isValidNumber()) return 'Please enter a valid mobile number';
                    } catch (_) {
                      return 'Please enter a valid mobile number';
                    }
                    return null;
                  },
                  languageCode: "en",
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                  onCountryChanged: (country) {
                    print('Country changed to: ' + country.name);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  child: Text('Submit'),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    _formKey.currentState?.validate();
                    setState(() {
                      submitted = true;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
