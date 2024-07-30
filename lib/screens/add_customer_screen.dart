import 'package:flutter/material.dart';
import 'package:pixel_test/components/button.dart';
import 'package:pixel_test/components/global_snackbar.dart';
import 'package:pixel_test/models/customer_model.dart';
import 'package:pixel_test/provider/customer_provider.dart';
import 'package:pixel_test/routes/route.dart';
import 'package:pixel_test/screens/customer_list_screen.dart';
import 'package:provider/provider.dart';

class AddCustomerScreen extends StatefulWidget {
  final Customer? customer;
  final int? index;

  AddCustomerScreen({this.customer, this.index});

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _panController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  List<Address> _addresses = [];

  @override
  void initState() {
    if (widget.customer != null) {
      _panController.text = widget.customer!.pan;
      _fullNameController.text = widget.customer!.fullName;
      _emailController.text = widget.customer!.email;
      _mobileNumberController.text = widget.customer!.mobileNumber;
      _addresses = widget.customer!.addresses;
      postCodeController.text = widget.customer!.addresses.first.postcode;
      stateController.text = widget.customer!.addresses.first.state;
      cityController.text = widget.customer!.addresses.first.city;
      adressController.text = widget.customer!.addresses.first.addressLine1;
    }
    _panController.addListener(_checkPanLength);
    super.initState();
  }

  @override
  void dispose() {
    _panController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  void _checkPanLength() {
    if (_panController.text.length == 10) {
      _verifyPan();
    }
  }

  Future<void> _verifyPan() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Verifying PAN...'),
            ],
          ),
        );
      },
    );

    await Provider.of<CustomerProvider>(context, listen: false)
        .verifyPan(_panController.text);

    Navigator.of(context).pop();

    final isValid =
        Provider.of<CustomerProvider>(context, listen: false).isPanValid;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isValid ? 'Success' : 'Error'),
          content: Text(
              isValid ? 'PAN verified successfully' : 'Incorrect PAN number'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newCustomer = Customer(
        pan: _panController.text,
        fullName: _fullNameController.text,
        email: _emailController.text,
        mobileNumber: _mobileNumberController.text,
        addresses: _addresses,
      );
      if (widget.index == null) {
         showCustomSnackbar(
          context: context,
          message: 'Entity added successfully',
          backgroundColor: Colors.green);
        Provider.of<CustomerProvider>(context, listen: false)
            .addCustomer(newCustomer);
      } else {
         showCustomSnackbar(
          context: context,
          message: 'Entity updated successfully',
          backgroundColor: Colors.green);
        Provider.of<CustomerProvider>(context, listen: false)
            .editCustomer(widget.index!, newCustomer);
      }
      stateController.clear();
      stateController.text = '';
      cityController.text = '';
      postCodeController.text = '';
      _fullNameController.clear();
      _fullNameController.text = '';
      cityController.clear();
      postCodeController.clear();

      _panController.clear();
     
      Navigator.push(context, createRoute(const CustomerListScreen()));
      // Navigator.of(context).pop();
    }
  }

  Future<void> _fetchPostcodeDetails(int index, int postCode) async {
    if (postCodeController.text.length == 6) {
      final details =
          await Provider.of<CustomerProvider>(context, listen: false)
              .getPostcodeDetails(postCode);
      // if (details != null) {
      //   setState(() {
      //     _addresses[index].city = details['city']!;
      //     _addresses[index].state = details['state']!;
      //   });
      // }
    }
  }

  void _addAddress() {
    if (_addresses.length < 10) {
      setState(() {
        _addresses.add(Address(
            addressLine1: '',
            addressLine2: '',
            postcode: '',
            state: '',
            city: ''));
      });
    }
  }

  void _removeAddress(int index) {
    setState(() {
      _addresses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(widget.customer == null ? 'Add Entity' : 'Edit Entity')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<CustomerProvider>(builder: (context, provider, w) {
          if (provider.panVerifyModel?.fullName != null) {
            _fullNameController.text =
                provider.panVerifyModel!.fullName.toString();
          }
          return Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text('PAN Number'),
                Textfield(
                  controller: _panController,
                  maxLength: 10,
                  hintText: 'Pan number',
                  validationText: 'Please enter pan number',
                  isPan: true,
                ),
                const Text('Full Name'),
                Textfield(
                  controller: _fullNameController,
                  maxLength: 100,
                  hintText: 'Full name',
                  validationText: 'Please enter full name',
                ),
                const Text('Email Address'),
                Textfield(
                  controller: _emailController,
                  maxLength: 150,
                  hintText: 'Email',
                  validationText: 'Please enter email',
                ),
                const Text('Mobile Number'),
                Textfield(
                  controller: _mobileNumberController,
                  maxLength: 10,
                  hintText: 'Mobile number',
                  validationText: 'Please enter mobile number',
                  isPrefixText: true,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _addresses.length > 1 ? 3 : 2,
                  itemBuilder: (context, index) {
                    if (provider.postCodeModel != null) {
                      cityController.text =
                          provider.postCodeModel!.city![0].name.toString();
                      stateController.text =
                          provider.postCodeModel!.state![0].name.toString();
                      // _addresses[index].state = stateController.text;
                      // _addresses[index].city = cityController.text;
                    }
                    if (index == _addresses.length) {
                      // This is the "Add Address" tile
                      return ListTile(
                        title: const Text('Add Address'),
                        leading: const Icon(Icons.add),
                        onTap: _addAddress,
                      );
                    }
                    return Container(
                      // height: 46,
                      // padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFFDDDDDD).withOpacity(0.7),
                              width: 0.7),
                          borderRadius: BorderRadius.circular(7)),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          childrenPadding: const EdgeInsets.all(10),
                          title: Text('Address ${index + 1}'),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Address Line 1'),
                                const SizedBox(height: 5),
                                Textfield(
                                  controller: adressController,
                                  onChanged: (value) {
                                    _addresses[index].addressLine1 = value;
                                  },
                                  hintText: 'Adress Line 1*',
                                  validationText: 'Please enter adress line 1',
                                ),
                                const SizedBox(height: 15),
                                const Text('Address Line 2'),
                                const SizedBox(height: 5),
                                Textfield(
                                  controller: TextEditingController(),
                                  onChanged: (value) {
                                    _addresses[index].addressLine2 = value;
                                  },
                                  hintText: 'Address Line 2',
                                ),
                                const SizedBox(height: 15),
                                const Text('Pincode'),
                                const SizedBox(height: 5),
                                Textfield(
                                  controller: postCodeController,
                                  isPostCode: true,
                                  maxLength: 6,
                                  validationText: 'Please enter postcode',
                                  onChanged: (value) async {
                                    _addresses[index].postcode = value;
                                    await _fetchPostcodeDetails(index,
                                        int.parse(postCodeController.text));
                                  },
                                ),
                                const Text('State'),
                                const SizedBox(height: 5),
                                Textfield(
                                  controller: stateController,
                                  hintText: 'State',
                                ),
                                const SizedBox(height: 15),
                                const Text('City'),
                                const SizedBox(height: 5),
                                Textfield(
                                  controller: cityController,
                                  hintText: 'City',
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle),
                              onPressed: () => _removeAddress(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Buttons(
                  mediaQuery: mediaQuery,
                  onTap: _saveForm,
                  btnName: 'Save',
                  width: mediaQuery.width,
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}

class Textfield extends StatelessWidget {
  Textfield(
      {super.key,
      required this.controller,
      this.hintText,
      this.maxLength,
      this.validationText,
      this.isPan = false,
      this.isPostCode = false,
      this.onChanged,
      this.isPrefixText = false});

  TextEditingController controller = TextEditingController();
  String? hintText;
  int? maxLength;
  String? validationText;
  bool? isPrefixText;
  bool? isPan;
  bool? isPostCode;
  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: (isPrefixText == true || isPostCode == true)
          ? TextInputType.number
          : TextInputType.multiline,
      onChanged: onChanged,
      decoration: InputDecoration(
          hintText: hintText,
          prefixText: (isPrefixText == true) ? '+91 ' : '',
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                  color: const Color(0xFFDDDDDD).withOpacity(0.7), width: 0.7)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                  color: const Color(0xFFDDDDDD).withOpacity(0.7), width: 0.7)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                  color: const Color(0xFFDDDDDD).withOpacity(0.7), width: 0.7)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                  color: const Color(0xFFDDDDDD).withOpacity(0.7), width: 0.7)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                  color: const Color(0xFFDDDDDD).withOpacity(0.7), width: 0.7)),
          hintStyle:
              const TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                  color: const Color(0xFFDDDDDD).withOpacity(0.4),
                  width: 0.4))),
      maxLength: maxLength,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationText;
        }
        // if (isPan == true) {
        //   if (!Provider.of<CustomerProvider>(context, listen: false)
        //       .isPanValid) {
        //     return 'Invalid PAN';
        //   }
        // }
        return null;
      },
    );
  }
}
