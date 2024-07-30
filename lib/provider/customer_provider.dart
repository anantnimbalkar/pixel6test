import 'package:flutter/foundation.dart';
import 'package:pixel_test/api/api_service.dart';
import 'package:pixel_test/models/customer_model.dart';
import 'package:pixel_test/models/pan_verification_model.dart';
import 'package:pixel_test/models/postcode_model.dart';
import 'package:pixel_test/provider/state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];
  bool _isPanValid = false;
  bool _isLoading = false;
  VerifyPanStatus verifyPanStatus = VerifyPanStatus.initial;
  PostCodeStatus postCodeStatus = PostCodeStatus.initial;
  PostCodeModel? postCodeModel;
  List<Customer> get customers => _customers;
  bool get isPanValid => _isPanValid;
  bool get isLoading => _isLoading;

  PanVerifyModel? panVerifyModel;

  ApiService apiService = ApiService();

  addCustomer(Customer customer) async {
    _customers.add(customer);
    await saveToPrefs();
    notifyListeners();
  }

  editCustomer(int index, Customer customer) async {
    _customers[index] = customer;
    await saveToPrefs();
    notifyListeners();
  }

  Future<void> deleteCustomer(int index) async {
    _customers.removeAt(index);
    await saveToPrefs();
    notifyListeners();
  }

  loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customersString = prefs.getString('customers');
    if (customersString != null) {
      _customers = (json.decode(customersString) as List)
          .map((i) => Customer.fromJson(i))
          .toList();
    }
    notifyListeners();
  }

  saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String customersString =
        json.encode(_customers.map((i) => i.toJson()).toList());
    if (kDebugMode) {
      print(customersString);
      print('customer string is -------->');
    }
    await prefs.setString('customers', customersString);
  }

  Future<void> verifyPan(String pan) async {
    verifyPanStatus = VerifyPanStatus.loading;
    notifyListeners();

    try {
      final response = await apiService.verifyPan(pan);
      if (kDebugMode) {
        print(response);
      }
      if (response['isValid'] == true) {
        panVerifyModel = PanVerifyModel.fromJson(response);
        verifyPanStatus = VerifyPanStatus.success;
        _isPanValid = true;
      } else {
        verifyPanStatus = VerifyPanStatus.failure;
        _isPanValid = false;
      }
    } catch (e) {
      verifyPanStatus = VerifyPanStatus.failure;
      _isPanValid = false;
    }

    notifyListeners();
  }

  getPostcodeDetails(int postcode) async {
    postCodeStatus = PostCodeStatus.loading;

    notifyListeners();

    try {
      final response = await apiService.getPostCodeDetails(postcode);

      if (response['status'] == "Success") {
        postCodeStatus = PostCodeStatus.success;
        if (kDebugMode) {
          print(response);
        print('response of getPostcodeDetails');
        }
        postCodeModel = PostCodeModel.fromJson(response);
      } else {
        postCodeStatus = PostCodeStatus.failure;
        postCodeModel = null;
      }
    } catch (e, trace) {
      postCodeStatus = PostCodeStatus.failure;
      if (kDebugMode) {
        print(e);
        print(trace);
      }
    }

    notifyListeners();
  }
}
