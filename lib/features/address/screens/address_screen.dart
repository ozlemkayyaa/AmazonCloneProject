// ignore_for_file: library_private_types_in_public_api
import 'package:amazon/constants/utils.dart';
import 'package:amazon/features/address/services/address_services.dart';
import 'package:amazon/payment_config.dart';
import 'package:amazon/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:amazon/common/widgets/custom_textfield.dart';
import 'package:amazon/constants/global_variables.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({super.key, required this.totalAmount});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  // Platformu kontrol eder: apple ise Apple Pay butonu, google ise Google Pay butonu gelir
  //String os = Platform.operatingSystem;

  // Form anahtarı
  final _addressFormKey = GlobalKey<FormState>();

  // Text editing controller'lar
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  String addressToBeUsed = "";
  List<PaymentItem> paymentItems = [];
  final AddressServices addressServices = AddressServices();

  @override
  void initState() {
    super.initState();
    // Ödeme öğesini ödeme listesine ekle
    paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount,
        label: 'Total Amount',
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Controller'ları temizle
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  // Apple Pay sonucunu işleyen fonksiyon
  void onApplePayResult(res) {
    // Kullanıcı adresi boşsa kaydet
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
    // Siparişi gerçekleştir
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  // Google Pay sonucunu işleyen fonksiyon
  void onGooglePayResult(res) {
    // Kullanıcı adresi boşsa kaydet
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
    // Siparişi gerçekleştir
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  // Ödeme butonuna basıldığında çalışacak fonksiyon
  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";

    // Formdaki herhangi bir alan dolu mu kontrol et
    bool isForm = flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;

    if (isForm) {
      // Form geçerli mi kontrol et
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${flatBuildingController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}';
      } else {
        throw Exception(
            'Please enter all the values!'); // Tüm değerler girilmemişse hata fırlat
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider; // Sağlayıcıdan adresi al
    } else {
      showSnackBar(context, 'ERROR'); // Adres yoksa hata göster
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: flatBuildingController,
                      hintText: "Flat, House no. Building",
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: areaController,
                      hintText: "Area, Street",
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: pincodeController,
                      hintText: "Pincode",
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: cityController,
                      hintText: 'Town/City',
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              ApplePayButton(
                paymentConfiguration:
                    PaymentConfiguration.fromJsonString(defaultApplePay),
                paymentItems: paymentItems,
                onPaymentResult: onApplePayResult,
                onPressed: () => payPressed(address),
                style: ApplePayButtonStyle.whiteOutline,
                width: double.infinity,
                height: 50,
                type: ApplePayButtonType.buy,
                margin: const EdgeInsets.only(top: 15.0),
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              GooglePayButton(
                paymentConfiguration:
                    PaymentConfiguration.fromJsonString(defaultGooglePay),
                onPaymentResult: onGooglePayResult,
                paymentItems: paymentItems,
                onPressed: () => payPressed(address),
                height: 50,
                theme: GooglePayButtonTheme.light,
                type: GooglePayButtonType.buy,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 15.0),
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
