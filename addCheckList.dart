import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:html' as webFile;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:excel/excel.dart' as excelLib;
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:ir_datetime_picker/ir_datetime_picker.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:pdf/pdf.dart';
import 'package:samane/colors.dart';
import 'package:samane/dimens.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:samane/model/RuleModel.dart';
import 'package:samane/model/bilboardreserve.dart';
import 'package:intl/intl.dart' as intl;
import 'package:samane/model/ghestModel.dart';
import 'package:samane/userdata.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:samane/widgets/brandfilter.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Row, Column, Stack, Border;

class addCheckList extends StatefulWidget {
  const addCheckList({super.key});

  @override
  State<addCheckList> createState() => _addCheckListState();
}

class _addCheckListState extends State<addCheckList> {
  int firstremaining = 0;
  int secondremaining = 0;
  late String recivedBrandID, recivedCustomerID, sellerID;
  bool hagh = false;
  bool Calhagh = false;
  bool payhagh = false;
  bool bandTcheck = false;
  bool payBandT = false;
  bool CalBandT = false;

  late List<String> customerList,
      hagholamalkarList,
      ManageSellerList,
      VATlist,
      hagholamalTo,
      sellerList,
      BillboardCode,
      lightText,
      offrulesTex,
      ContractType,
      InsuranceType,
      mafasaType,
      hagholamalkar,
      Calhagholamalkar,
      Elhaghiy,
      signType,
      type,
      ContractTepmllate,
      printstatus,
      install,
      paymentmethod,
      Brands,
      AllocatioCommission;
  late List<billBoardreserve> itemsData;
  late List customerListJson, BillboardData, ContractTypeData, InsuranceTypeData, mafasaTypecValueData, ElhaghiyeData, BrandJson, ManageSellerJson, sellerJson;
  late List<ghestModel> ghestItems;
  late Jalali selectedDatejalali, startDate;
  int? customerID, ContractTypeID, insuranceID, mafasaID, elhaqieID, cUSTOMERiD;
  String? customerValue,
      ManageSellerValue,
      CommissionValue,
      SellerValue,
      BrandValue,
      codeValue,
      contractValue,
      InsuranceValue,
      mafasaTypeValue,
      elhaghiyeValue,
      signvalue,
      signCompanyvalue,
      typevalue,
      ContractTepmlateValue,
      printValue,
      installValue,
      paymentmethodValue,
      hagholamalkarValue,
      CalhagholamalkarValue,
      CalBandTValue,
      hagholamalToValue,
      hagholamalkarListValue,
      BandT,
      VATvalue,
      BandtTo,
      BrandId;
  late TextEditingController ContractNo, ContractDate, Customers, Brand, firstElhaqie, secondElhaqie, firstElhaqieDate, secondElhaqieDate, radif_peyman;
  final TextEditingController searchCodeController = TextEditingController();
  final TextEditingController searchCustomerController = TextEditingController();
  final TextEditingController taxpercent = TextEditingController(text: "10");
  final TextEditingController BandTController = TextEditingController();
  final TextEditingController sumBandTController = TextEditingController();
  final TextEditingController percentHagholamal = TextEditingController();
  final TextEditingController percentHBandT = TextEditingController();

  final TextEditingController sumHagholamal = TextEditingController();
  final TextEditingController sumBandT = TextEditingController();

  final TextEditingController descHagholamal = TextEditingController();

  late TextEditingController startController, finishController, price_per_monthController, discountController, finalPriceController, sumpriceController;
  late List offrules;
  late List offrules2;
  late Future<Map<String, dynamic>> futureData;
  TextEditingController timedaymonth = TextEditingController();
  TextEditingController timemonthController = TextEditingController();
  TextEditingController timedayController = TextEditingController();
  final TextEditingController sumtaxpercent = TextEditingController();
  final TextEditingController sarresid = TextEditingController();
  final TextEditingController prepayment = TextEditingController(text: "0");
  final TextEditingController countghest = TextEditingController();
  final TextEditingController bafasele = TextEditingController();
  String userID = "";
  userData userdata = userData();

  TextEditingController printPriceController = TextEditingController();
  TextEditingController finalTaxController = TextEditingController(text: "10");

  bool checkedValue = false;
  bool checkedValue2 = false;
  String paymentPrice = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("time: " + now());
    userdata.getUserId().then((value) {
      setState(() {
        userID = value.toString();
      });
    });
    print("userID: $userID");
    BrandId = "";
    ghestItems = [];
    ManageSellerJson = [];
    ManageSellerList = [];
    sellerJson = [];
    sellerList = [];
    offrules = ["انتخاب کنید", "با نور", "بدون نور"];
    offrules2 = ["انتخاب کنید", "بدون جایگزینی", "3 به 1", "2 به 1", "1 به 1"];
    AllocatioCommission = ["کانون", "کارشناس", "مشترک"];
    Calhagholamalkar = ["انتخاب کنید", "درصدی", "مبلغی"];
    hagholamalTo = ["انتخاب کنید", "اجاره", "اجاره و اجرا"];
    VATlist = ["انتخاب کنید", "شمول", "عدم شمول"];
    VATvalue = "انتخاب کنید";
    hagholamalkarValue = "انتخاب کنید";
    itemsData = [];
    BillboardData = [];
    hagholamalToValue = "انتخاب کنید";
    BandtTo = "انتخاب کنید";
    CalBandTValue = "انتخاب کنید";
    BandT = "انتخاب کنید";
    futureData = fetchData();
    selectSeller("3").then((c) {
      for (var seller in sellerJson) {
        sellerList.add(seller["name"]);
      }
    });
    ManageSelectSeller("3", "2").then((v) {
      ManageSellerList.add(ManageSellerJson[0]["name"]);
    });
    fetchDataBillboards().then((value) {
      BillboardCode.add("انتخاب کنید");
      for (int i = 0; i < BillboardData.length; i++) {
        BillboardCode.add(BillboardData[i]["Code"]);
      }
      itemsData[0].Code = BillboardCode[0];
    });
    startController = TextEditingController();
    finishController = TextEditingController();
    price_per_monthController = TextEditingController();
    discountController = TextEditingController();
    finalPriceController = TextEditingController();
    sumpriceController = TextEditingController();
    itemsData.add(billBoardreserve(
        start: startController,
        timemonth: timemonthController,
        timeday: timedayController,
        timedaymonth: timedaymonth,
        finish: finishController,
        price_per_month: price_per_monthController,
        discount: discountController,
        finalPrice: finalPriceController,
        sumPrice: sumpriceController,
        sumTax: sumtaxpercent,
        Code: "",
        light: "",
        off: "",
        startError: "",
        tax: taxpercent,
        finishError: "",
        startDate: Jalali.now(),
        printValue: "انتخاب کنید",
        installValue: "انتخاب کنید"));

    startController = TextEditingController();
    finishController = TextEditingController();
    price_per_monthController = TextEditingController();
    discountController = TextEditingController();
    finalPriceController = TextEditingController();
    sumpriceController = TextEditingController();
    firstElhaqie = TextEditingController();
    secondElhaqie = TextEditingController();
    firstElhaqieDate = TextEditingController();
    secondElhaqieDate = TextEditingController();

    selectedDatejalali = Jalali(1999);
    type = ["انتخاب کنید", "قراردادی", "فاکتوری"];
    ContractTepmllate = ["انتخاب کنید", "اجاره", "اجاره و اجرا"];
    mafasaType = ["انتخاب کنید", "دارد", "ندارد"];
    hagholamalkar = ["انتخاب کنید", "دارد", "ندارد"];
    printstatus = ["انتخاب کنید", "با کانون", "با مشتری"];
    paymentmethod = ["انتخاب کنید", "نقدی", "چک", "سایر"];
    paymentmethodValue = "انتخاب کنید";
    install = ["انتخاب کنید", "با کانون", "با مشتری"];
    printValue = "انتخاب کنید";
    installValue = "انتخاب کنید";
    customerListJson = [];
    customerList = ["انتخاب کنید"];
    BillboardCode = [];
    lightText = [];
    offrulesTex = [];
    ContractType = ["انتخاب کنید", "100", "200"];
    recivedBrandID = "";
    InsuranceType = [];
    Elhaghiy = [];
    signType = [];
    customerID = 0;
    ContractTypeID = 0;
    insuranceID = 0;
    mafasaID = 0;
    elhaqieID = 0;
    typevalue = "انتخاب کنید";
    ContractTepmlateValue = "انتخاب کنید";
    customerValue = "انتخاب کنید";
    codeValue = "";
    contractValue = "انتخاب کنید";
    InsuranceValue = "";
    mafasaTypeValue = "انتخاب کنید";
    elhaghiyeValue = "";
    signvalue = "";
    signCompanyvalue = "";
    ContractNo = TextEditingController();
    ContractDate = TextEditingController();
    Customers = TextEditingController();
    Brand = TextEditingController();
    firstElhaqie = TextEditingController();
    secondElhaqie = TextEditingController();
    firstElhaqieDate = TextEditingController();
    secondElhaqieDate = TextEditingController();
    radif_peyman = TextEditingController();

    ContractNo = TextEditingController();
    ContractDate = TextEditingController();
    Customers = TextEditingController();
    Brand = TextEditingController();
    BrandValue = "انتخاب کنید";
    BrandJson = [];
    Brands = ["انتخاب کنید"];
    fetchCustomersData().then((value) {
      for (int i = 0; i < customerListJson.length; i++) {
        customerList.add("${i + 1}. " +
            (customerListJson[i]["name_haqiqi"].toString().length < 2 && customerListJson[i]["lastname_haqiqi"].toString().length < 2
                ? customerListJson[i]["name_hoqoqi"]
                : customerListJson[i]["name_haqiqi"].toString() + " " + customerListJson[i]["lastname_haqiqi"].toString()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!;
                List<String> offrules = [];
                offrules.add("انتخاب کنید");
                List<Rule> offrules2 = (data['offrules'] as List).map((item) => Rule.fromJson(item)).toList();
                for (int i = 0; i < offrules2.length; i++) {
                  offrules.add(offrules2[i].text);
                }
                List lightrules = ["انتخاب کنید"];

                List<Rule> lightrules2 = (data['lightrules'] as List).map((item) => Rule.fromJson(item)).toList();
                for (int i = 0; i < lightrules2.length; i++) {
                  lightrules.add(lightrules2[i].text);
                }
              }
              return Container(
                  height: MediaQuery.of(context).size.height + 700,
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 17.5, horizontal: 70),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                              margin: EdgeInsets.only(right: 30),
                              width: 150,
                              height: 30,
                              child: Center(
                                  child: Text(
                                "اطلاعات قرارداد",
                                style: TextStyle(color: Colors.white),
                              )),
                              decoration: BoxDecoration(
                                color: colors.Box,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                              )),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: colors.Box,
                                width: 1,
                              ),
                            ),
                            child: Column(children: [
                              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                      child: Text(
                                        'کارشناس فروش',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(dimens.borderRadius),
                                          boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                      width: 130,
                                      height: 35,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            'انتخاب کنید',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                          items: sellerList
                                              .map((item) => DropdownMenuItem(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          value: SellerValue,
                                          onChanged: (value) {
                                            setState(() {
                                              SellerValue = value;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            height: 40,
                                            width: 200,
                                          ),
                                          dropdownStyleData: const DropdownStyleData(
                                            decoration: BoxDecoration(color: Colors.white),
                                            maxHeight: 200,
                                          ),
                                          menuItemStyleData: const MenuItemStyleData(
                                            height: 40,
                                          ),
                                          dropdownSearchData: DropdownSearchData(
                                            searchController: searchCodeController,
                                            searchInnerWidgetHeight: 50,
                                            searchInnerWidget: Container(
                                              height: 50,
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 4,
                                                right: 8,
                                                left: 8,
                                              ),
                                              child: TextFormField(
                                                expands: true,
                                                maxLines: null,
                                                controller: searchCodeController,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                                  hintText: 'جست و جو...',
                                                  hintStyle: const TextStyle(fontSize: 12),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            searchMatchFn: (item, searchValue) {
                                              return item.value.toString().contains(searchValue);
                                            },
                                          ),
                                          //This to clear the search value when you close the menu
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              searchCodeController.clear();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                      child: Text(
                                        'مدیر فروش',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(dimens.borderRadius),
                                          boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                      width: 130,
                                      height: 35,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            'انتخاب کنید',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                          items: ManageSellerList.map((item) => DropdownMenuItem(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              )).toList(),
                                          value: ManageSellerValue,
                                          onChanged: (value) {
                                            setState(() {
                                              ManageSellerValue = value;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            height: 40,
                                            width: 200,
                                          ),
                                          dropdownStyleData: const DropdownStyleData(
                                            decoration: BoxDecoration(color: Colors.white),
                                            maxHeight: 200,
                                          ),
                                          menuItemStyleData: const MenuItemStyleData(
                                            height: 40,
                                          ),
                                          dropdownSearchData: DropdownSearchData(
                                            searchController: searchCodeController,
                                            searchInnerWidgetHeight: 50,
                                            searchInnerWidget: Container(
                                              height: 50,
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 4,
                                                right: 8,
                                                left: 8,
                                              ),
                                              child: TextFormField(
                                                expands: true,
                                                maxLines: null,
                                                controller: searchCodeController,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                                  hintText: 'جست و جو...',
                                                  hintStyle: const TextStyle(fontSize: 12),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            searchMatchFn: (item, searchValue) {
                                              return item.value.toString().contains(searchValue);
                                            },
                                          ),
                                          //This to clear the search value when you close the menu
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              searchCodeController.clear();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                      child: Text(
                                        'تخصیص کمیسیون',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(dimens.borderRadius),
                                          boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                      width: 130,
                                      height: 35,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            'انتخاب کنید',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                          items: AllocatioCommission.map((item) => DropdownMenuItem(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              )).toList(),
                                          value: CommissionValue,
                                          onChanged: (value) {
                                            setState(() {
                                              CommissionValue = value;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            height: 40,
                                            width: 200,
                                          ),
                                          dropdownStyleData: const DropdownStyleData(
                                            decoration: BoxDecoration(color: Colors.white),
                                            maxHeight: 200,
                                          ),
                                          menuItemStyleData: const MenuItemStyleData(
                                            height: 40,
                                          ),
                                          dropdownSearchData: DropdownSearchData(
                                            searchController: searchCodeController,
                                            searchInnerWidgetHeight: 50,
                                            searchInnerWidget: Container(
                                              height: 50,
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 4,
                                                right: 8,
                                                left: 8,
                                              ),
                                              child: TextFormField(
                                                expands: true,
                                                maxLines: null,
                                                controller: searchCodeController,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                                  hintText: 'جست و جو...',
                                                  hintStyle: const TextStyle(fontSize: 12),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            searchMatchFn: (item, searchValue) {
                                              return item.value.toString().contains(searchValue);
                                            },
                                          ),
                                          //This to clear the search value when you close the menu
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              searchCodeController.clear();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                      child: Text(
                                        'نوع قرارداد',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(dimens.borderRadius),
                                          boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                      width: 165,
                                      height: 35,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            'انتخاب کنید',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                          items: ContractType.map((item) => DropdownMenuItem(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              )).toList(),
                                          value: contractValue,
                                          onChanged: (value) {
                                            setState(() {
                                              contractValue = value;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            height: 40,
                                            width: 200,
                                          ),
                                          dropdownStyleData: const DropdownStyleData(
                                            decoration: BoxDecoration(color: Colors.white),
                                            maxHeight: 200,
                                          ),
                                          menuItemStyleData: const MenuItemStyleData(
                                            height: 40,
                                          ),

                                          //This to clear the search value when you close the menu
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              searchCustomerController.clear();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                      child: Text(
                                        'قراردادی/فاکتوری',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(dimens.borderRadius),
                                          boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                      width: 165,
                                      height: 35,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            'انتخاب کنید',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                          items: type
                                              .map((item) => DropdownMenuItem(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          value: typevalue,
                                          onChanged: (value) {
                                            setState(() {
                                              typevalue = value;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            height: 40,
                                            width: 200,
                                          ),
                                          dropdownStyleData: const DropdownStyleData(
                                            decoration: BoxDecoration(color: Colors.white),
                                            maxHeight: 200,
                                          ),
                                          menuItemStyleData: const MenuItemStyleData(
                                            height: 40,
                                          ),
                                          dropdownSearchData: DropdownSearchData(
                                            searchController: searchCustomerController,
                                            searchInnerWidgetHeight: 50,
                                            searchInnerWidget: Container(
                                              height: 50,
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 4,
                                                right: 8,
                                                left: 8,
                                              ),
                                              child: TextFormField(
                                                expands: true,
                                                maxLines: null,
                                                controller: searchCustomerController,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                                  hintText: 'جست و جو...',
                                                  hintStyle: const TextStyle(fontSize: 12),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            searchMatchFn: (item, searchValue) {
                                              return item.value.toString().contains(searchValue);
                                            },
                                          ),
                                          //This to clear the search value when you close the menu
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              searchCustomerController.clear();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                      child: Text(
                                        'قالب قرارداد',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(dimens.borderRadius),
                                          boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                      width: 165,
                                      height: 35,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            'انتخاب کنید',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                          items: ContractTepmllate.map((item) => DropdownMenuItem(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              )).toList(),
                                          value: ContractTepmlateValue,
                                          onChanged: (value) {
                                            setState(() {
                                              ContractTepmlateValue = value;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            height: 40,
                                            width: 200,
                                          ),
                                          dropdownStyleData: const DropdownStyleData(
                                            decoration: BoxDecoration(color: Colors.white),
                                            maxHeight: 200,
                                          ),
                                          menuItemStyleData: const MenuItemStyleData(
                                            height: 40,
                                          ),
                                          dropdownSearchData: DropdownSearchData(
                                            searchController: searchCustomerController,
                                            searchInnerWidgetHeight: 50,
                                            searchInnerWidget: Container(
                                              height: 50,
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 4,
                                                right: 8,
                                                left: 8,
                                              ),
                                              child: TextFormField(
                                                expands: true,
                                                maxLines: null,
                                                controller: searchCustomerController,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                                  hintText: 'جست و جو...',
                                                  hintStyle: const TextStyle(fontSize: 12),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            searchMatchFn: (item, searchValue) {
                                              return item.value.toString().contains(searchValue);
                                            },
                                          ),
                                          //This to clear the search value when you close the menu
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              searchCustomerController.clear();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                      child: Text(
                                        'درخواست مفاصاحساب',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(dimens.borderRadius),
                                          boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                      width: 165,
                                      height: 35,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            'انتخاب کنید',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                          items: mafasaType
                                              .map((item) => DropdownMenuItem(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          value: mafasaTypeValue,
                                          onChanged: (value) {
                                            setState(() {
                                              mafasaTypeValue = value;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            height: 40,
                                            width: 200,
                                          ),
                                          dropdownStyleData: const DropdownStyleData(
                                            decoration: BoxDecoration(color: Colors.white),
                                            maxHeight: 200,
                                          ),
                                          menuItemStyleData: const MenuItemStyleData(
                                            height: 40,
                                          ),

                                          //This to clear the search value when you close the menu
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              searchCustomerController.clear();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                      child: Text(
                                        'مشتری',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(dimens.borderRadius),
                                          boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                      width: 165,
                                      height: 35,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            'انتخاب کنید',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                          items: customerList
                                              .map((item) => DropdownMenuItem(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          value: customerValue,
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == "انتخاب کنید") {
                                                setState(() {
                                                  customerValue = value;
                                                });
                                              } else {
                                                print(customerList.indexOf(value.toString()));
                                                customerValue = value;
                                                Brands.clear();
                                                BrandJson.clear();
                                                if (customerList.indexOf(value.toString()) > -1) {
                                                  int index = customerList.indexOf(value.toString());
                                                  customerID = int.parse(customerListJson[index - 1]["id"]);
                                                  print(customerID);
                                                  Brands.add("انتخاب کنید");
                                                  BrandValue = "انتخاب کنید";
                                                  getBrand(customerID.toString()).then((value) {
                                                    setState(() {
                                                      for (int i = 0; i < value.length; i++) {
                                                        Brands.add("${i + 1}. " + BrandJson[i]["name"]);
                                                      }
                                                    });
                                                  });
                                                }
                                              }
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            height: 40,
                                            width: 200,
                                          ),
                                          dropdownStyleData: const DropdownStyleData(
                                            decoration: BoxDecoration(color: Colors.white),
                                            maxHeight: 200,
                                          ),
                                          menuItemStyleData: const MenuItemStyleData(
                                            height: 40,
                                          ),
                                          dropdownSearchData: DropdownSearchData(
                                            searchController: searchCustomerController,
                                            searchInnerWidgetHeight: 50,
                                            searchInnerWidget: Container(
                                              height: 50,
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 4,
                                                right: 8,
                                                left: 8,
                                              ),
                                              child: TextFormField(
                                                expands: true,
                                                maxLines: null,
                                                controller: searchCustomerController,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                                  hintText: 'جست و جو...',
                                                  hintStyle: const TextStyle(fontSize: 12),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            searchMatchFn: (item, searchValue) {
                                              return item.value.toString().contains(searchValue);
                                            },
                                          ),
                                          //This to clear the search value when you close the menu
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              searchCustomerController.clear();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                      child: Text(
                                        'برند',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(dimens.borderRadius),
                                          boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                      width: 165,
                                      height: 35,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            'انتخاب کنید',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Theme.of(context).hintColor,
                                            ),
                                          ),
                                          items: Brands.map((item) => DropdownMenuItem(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              )).toList(),
                                          value: BrandValue,
                                          onChanged: (value) {
                                            setState(() {
                                              BrandValue = value;
                                              if (Brands.indexOf(value.toString()) > -1) {
                                                print(BrandJson.length);
                                                print(customerID);
                                              }
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            height: 40,
                                            width: 200,
                                          ),
                                          dropdownStyleData: const DropdownStyleData(
                                            decoration: BoxDecoration(color: Colors.white),
                                            maxHeight: 200,
                                          ),
                                          menuItemStyleData: const MenuItemStyleData(
                                            height: 40,
                                          ),
                                          dropdownSearchData: DropdownSearchData(
                                            searchController: searchCustomerController,
                                            searchInnerWidgetHeight: 50,
                                            searchInnerWidget: Container(
                                              height: 50,
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 4,
                                                right: 8,
                                                left: 8,
                                              ),
                                              child: TextFormField(
                                                expands: true,
                                                maxLines: null,
                                                controller: searchCustomerController,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                                  hintText: 'جست و جو...',
                                                  hintStyle: const TextStyle(fontSize: 12),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            searchMatchFn: (item, searchValue) {
                                              return item.value.toString().contains(searchValue);
                                            },
                                          ),
                                          //This to clear the search value when you close the menu
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              searchCustomerController.clear();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 160,
                                      height: 20,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (customerValue != "انتخاب کنید") {
                                                showAlertDialog(context);
                                              }
                                            },
                                            child: Text(
                                              "افزودن برند +",
                                              style: TextStyle(color: Colors.blue, fontSize: 10),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                            ]),
                          )
                        ]),
                      )
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              itemsData.add(billBoardreserve(
                                  start: TextEditingController(),
                                  timemonth: TextEditingController(),
                                  timeday: TextEditingController(),
                                  timedaymonth: TextEditingController(),
                                  finish: TextEditingController(),
                                  price_per_month: TextEditingController(),
                                  discount: TextEditingController(),
                                  finalPrice: TextEditingController(),
                                  sumPrice: TextEditingController(),
                                  tax: TextEditingController(text: "10"),
                                  sumTax: TextEditingController(),
                                  Code: "انتخاب کنید",
                                  light: "انتخاب کنید",
                                  off: "انتخاب کنید",
                                  finishError: "",
                                  startError: "",
                                  startDate: Jalali(1999),
                                  installValue: "انتخاب کنید",
                                  printValue: "انتخاب کنید"));
                            });
                            // print(itemsData.length);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            margin: const EdgeInsets.all(0.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(dimens.borderRadius),
                                boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                            child: Row(
                              children: [
                                Text("افزودن"),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.add,
                                  color: colors.mainColor,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 600,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListView.builder(
                          itemCount: itemsData.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.only(top: 5),
                              height: 190,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(top: 10, right: 40, left: 40),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(dimens.borderRadius),
                                border: Border.all(
                                  color: colors.Box,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                textDirection: TextDirection.rtl,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                            child: Text(
                                              'کد تابلو',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                            width: 130,
                                            height: 35,
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton2<String>(
                                                isExpanded: true,
                                                hint: Text(
                                                  'انتخاب کنید',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Theme.of(context).hintColor,
                                                  ),
                                                ),
                                                items: BillboardCode.map((item) => DropdownMenuItem(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    )).toList(),
                                                value: itemsData[index].Code,
                                                onChanged: (value) {
                                                  setState(() {
                                                    itemsData[index].Code = value;
                                                  });
                                                },
                                                buttonStyleData: ButtonStyleData(
                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                                  height: 40,
                                                  width: 200,
                                                ),
                                                dropdownStyleData: const DropdownStyleData(
                                                  decoration: BoxDecoration(color: Colors.white),
                                                  maxHeight: 200,
                                                ),
                                                menuItemStyleData: const MenuItemStyleData(
                                                  height: 40,
                                                ),
                                                dropdownSearchData: DropdownSearchData(
                                                  searchController: searchCodeController,
                                                  searchInnerWidgetHeight: 50,
                                                  searchInnerWidget: Container(
                                                    height: 50,
                                                    padding: const EdgeInsets.only(
                                                      top: 8,
                                                      bottom: 4,
                                                      right: 8,
                                                      left: 8,
                                                    ),
                                                    child: TextFormField(
                                                      expands: true,
                                                      maxLines: null,
                                                      controller: searchCodeController,
                                                      decoration: InputDecoration(
                                                        isDense: true,
                                                        contentPadding: const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 8,
                                                        ),
                                                        hintText: 'جست و جو...',
                                                        hintStyle: const TextStyle(fontSize: 12),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  searchMatchFn: (item, searchValue) {
                                                    return item.value.toString().contains(searchValue);
                                                  },
                                                ),
                                                //This to clear the search value when you close the menu
                                                onMenuStateChange: (isOpen) {
                                                  if (!isOpen) {
                                                    searchCodeController.clear();
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                            child: InkWell(
                                              onTap: () {
                                                showIRJalaliDatePickerDialog(
                                                  context: context,
                                                  title: "انتخاب تاریخ",
                                                  visibleTodayButton: true,
                                                  todayButtonText: "انتخاب امروز",
                                                  confirmButtonText: "تایید",
                                                  initialDate: Jalali(1400, 4, 2),
                                                );
                                              },
                                              child: Text(
                                                'آغاز اکران قراردادی',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                  boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                              width: 110,
                                              height: 35,
                                              child: TextFormField(
                                                readOnly: true,
                                                controller: itemsData[index].start,
                                                style: TextStyle(fontSize: 13),
                                                decoration: InputDecoration(
                                                  suffixIcon: InkWell(
                                                    onTap: () async {
                                                      Jalali? selectedDate = await showIRJalaliDatePickerDialog(
                                                        context: context,
                                                        title: "انتخاب تاریخ",
                                                        visibleTodayButton: true,
                                                        todayButtonText: "انتخاب امروز",
                                                        confirmButtonText: "تایید",
                                                        initialDate: Jalali.now(),
                                                      ).then((value) {
                                                        // checkStatusBuillboard("${value}", "822");
                                                        if (value != null) {
                                                          calculateDate(int.parse(itemsData[index].timemonth.text.length == 0 ? "0" : itemsData[index].timemonth.text.toString()),
                                                              int.parse(itemsData[index].timeday.text.length == 0 ? "0" : itemsData[index].timeday.text.toString()), itemsData[index].startDate, index);
                                                          startDate = value;
                                                          itemsData[index].start.text = value.year.toString() +
                                                              (value.month.toString().length == 1 ? "0" + value.month.toString() : value.month.toString()) +
                                                              (value.day.toString().length == 1 ? "0" + value.day.toString() : value.day.toString());
                                                          print("Hi:::" + value.year.toString());
                                                          itemsData[index].startDate = value;
                                                        }
                                                      });

                                                      if (selectedDate != null) {
                                                        calculateDate(int.parse(itemsData[index].timemonth.text.toString()), int.parse(itemsData[index].timeday.text.toString()),
                                                            itemsData[index].startDate, index);
                                                        itemsData[index].start.text = selectedDate.year.toString() +
                                                            (selectedDate.month.toString().length == 1 ? "0" + selectedDate.month.toString() : selectedDate.month.toString()) +
                                                            (selectedDate.day.toString().length == 1 ? "0" + selectedDate.day.toString() : selectedDate.day.toString());
                                                        print("Hi:::" + selectedDate.year.toString());
                                                        itemsData[index].startDate = selectedDate;
                                                      }
                                                    },
                                                    child: Icon(
                                                      Icons.calendar_month,
                                                      color: colors.mainColor,
                                                    ),
                                                  ),
                                                  contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                                  hoverColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                    borderSide: BorderSide(
                                                      width: 0,
                                                      style: BorderStyle.none,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                              )),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                            child: Text(
                                              'مدت اکران',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                      boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                                  width: 30,
                                                  height: 35,
                                                  child: Focus(
                                                    onFocusChange: (value) {},
                                                    child: TextFormField(
                                                      onChanged: (value) {
                                                        setState(() {
                                                          calculateDate(int.parse(itemsData[index].timemonth.text.length == 0 ? "0" : itemsData[index].timemonth.text.toString()),
                                                              int.parse(itemsData[index].timeday.text.length == 0 ? "0" : itemsData[index].timeday.text.toString()), itemsData[index].startDate, index);
                                                          itemsData[index].timedaymonth.text =
                                                              roundNumber((int.parse(itemsData[index].timemonth.text) + (int.parse(itemsData[index].timeday.text) / 30)).toDouble(), 3).toString();
                                                          setSumprice(index);
                                                          taxset(index);
                                                          sumwithTax();
                                                          calfirstremaining();
                                                          calSecondRaminig();
                                                        });
                                                      },
                                                      keyboardType: TextInputType.number,
                                                      controller: itemsData[index].timemonth,
                                                      style: TextStyle(fontSize: 13),
                                                      decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                                        hoverColor: Colors.white,
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                          borderSide: BorderSide(
                                                            width: 0,
                                                            style: BorderStyle.none,
                                                          ),
                                                        ),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                      ),
                                                    ),
                                                  )),
                                              Text("ماه و"),
                                              Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                      boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                                  width: 30,
                                                  height: 35,
                                                  child: TextFormField(
                                                    onChanged: (value) {
                                                      setState(() {
                                                        calculateDate(int.parse(itemsData[index].timemonth.text.length == 0 ? "0" : itemsData[index].timemonth.text.toString()),
                                                            int.parse(itemsData[index].timeday.text.length == 0 ? "0" : itemsData[index].timeday.text.toString()), itemsData[index].startDate, index);
                                                        itemsData[index].timedaymonth.text =
                                                            roundNumber((int.parse(itemsData[index].timemonth.text) + (int.parse(itemsData[index].timeday.text) / 30)).toDouble(), 3).toString();
                                                        setSumprice(index);
                                                      });

                                                      taxset(index);
                                                      sumwithTax();
                                                      calfirstremaining();
                                                      calSecondRaminig();
                                                    },
                                                    controller: itemsData[index].timeday,
                                                    style: TextStyle(fontSize: 13),
                                                    decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                                      hoverColor: Colors.white,
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                        borderSide: BorderSide(
                                                          width: 0,
                                                          style: BorderStyle.none,
                                                        ),
                                                      ),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                    ),
                                                  )),
                                              SizedBox(
                                                height: 9,
                                              ),
                                              Text("روز = "),
                                              Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                      boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                                  width: 60,
                                                  height: 35,
                                                  child: TextFormField(
                                                    onChanged: (value) {
                                                      setSumprice(index);
                                                      taxset(index);
                                                      calSecondRaminig();
                                                      sumwithTax();
                                                      calfirstremaining();
                                                      calSecondRaminig();
                                                    },
                                                    controller: itemsData[index].timedaymonth,
                                                    style: TextStyle(fontSize: 13),
                                                    decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                                      hoverColor: Colors.white,
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                        borderSide: BorderSide(
                                                          width: 0,
                                                          style: BorderStyle.none,
                                                        ),
                                                      ),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                    ),
                                                  )),
                                              Text("ماه"),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                            child: Text(
                                              'خاتمه اکران قراردادی',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                  boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                              width: 110,
                                              height: 35,
                                              child: TextFormField(
                                                readOnly: true,
                                                controller: itemsData[index].finish,
                                                style: TextStyle(fontSize: 13),
                                                decoration: InputDecoration(
                                                  suffixIcon: InkWell(
                                                    onTap: () async {
                                                      Jalali? selectedDate = await showIRJalaliDatePickerDialog(
                                                        context: context,
                                                        title: "انتخاب تاریخ",
                                                        visibleTodayButton: true,
                                                        todayButtonText: "انتخاب امروز",
                                                        confirmButtonText: "تایید",
                                                        initialDate: Jalali.now(),
                                                      );
                                                      print("hi" + itemsData[index].start.text.length.toString());

                                                      if (itemsData[index].start.text.length == 0) {
                                                        setState(() {
                                                          itemsData[index].finishError = "تاریخ آغاز اکران نباید خال باشد";
                                                        });
                                                      } else if (selectedDate != null &&
                                                          int.parse(selectedDate.year.toString() +
                                                                  (selectedDate.month.toString().length == 1 ? "0" + selectedDate.month.toString() : selectedDate.month.toString()) +
                                                                  (selectedDate.day.toString().length == 1 ? "0" + selectedDate.day.toString() : selectedDate.day.toString())) >
                                                              int.parse(itemsData[index].start.text.length == 0 ? "0" : itemsData[index].start.text)) {
                                                        setState(() {
                                                          itemsData[index].finishError = "";
                                                        });
                                                        itemsData[index].finish.text = selectedDate.year.toString() +
                                                            (selectedDate.month.toString().length == 1 ? "0" + selectedDate.month.toString() : selectedDate.month.toString()) +
                                                            (selectedDate.day.toString().length == 1 ? "0" + selectedDate.day.toString() : selectedDate.day.toString());
                                                      } else {
                                                        setState(() {
                                                          itemsData[index].finishError = "تاریخ خاتمه اکران نباید قبل آغاز باشد";
                                                        });
                                                      }
                                                    },
                                                    child: Icon(
                                                      Icons.calendar_month,
                                                      color: colors.mainColor,
                                                    ),
                                                  ),
                                                  contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                                  hoverColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                    borderSide: BorderSide(
                                                      width: 0,
                                                      style: BorderStyle.none,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                              )),
                                          Text(
                                            itemsData[index].finishError.toString(),
                                            style: TextStyle(color: Colors.red, fontSize: itemsData[index].finishError.toString().length == 0 ? 0 : 10),
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                            child: Text(
                                              'اجاره ماهیانه',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                  boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                              width: 140,
                                              height: 35,
                                              child: TextFormField(
                                                keyboardType: TextInputType.number,
                                                onChanged: (string) {
                                                  setState(() {
                                                    double s = (int.parse(itemsData[index].price_per_month.text.toString().replaceAll(",", "")) -
                                                            int.parse(itemsData[index].discount.text.toString().replaceAll(",", "").length == 0
                                                                ? "0"
                                                                : itemsData[index].discount.text.toString().replaceAll(",", "")))
                                                        .toDouble();
                                                    MoneyFormatterOutput fo = MoneyFormatter(amount: s).output;
                                                    itemsData[index].finalPrice.text = fo.withoutFractionDigits;
                                                    string = '${formNum(
                                                      string.replaceAll(',', ''),
                                                    )}';

                                                    itemsData[index].price_per_month.value = TextEditingValue(
                                                      text: string,
                                                      selection: TextSelection.collapsed(
                                                        offset: string.length,
                                                      ),
                                                    );
                                                  });
                                                  setSumprice(index);
                                                  itemsData[index].sumTax.text = formNum((int.parse(itemsData[index].sumPrice.text.isEmpty ? "0" : itemsData[index].sumPrice.text.replaceAll(",", '')) +
                                                          int.parse(itemsData[index].sumTax.text.isEmpty ? "0" : itemsData[index].sumTax.text.replaceAll(",", '')))
                                                      .toString());
                                                  taxset(index);
                                                  sumwithTax();
                                                  calfirstremaining();
                                                  calSecondRaminig();
                                                },
                                                controller: itemsData[index].price_per_month,
                                                style: TextStyle(fontSize: 13),
                                                decoration: InputDecoration(
                                                  suffixIcon: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("ريال", style: TextStyle(fontFamily: "iranyekan", fontSize: 10)),
                                                    ],
                                                  ),
                                                  contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                                  hoverColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                    borderSide: BorderSide(
                                                      width: 0,
                                                      style: BorderStyle.none,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                              )),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                            child: Text(
                                              'تخفیف(ماهانه)',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                  boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                              width: 140,
                                              height: 35,
                                              child: Focus(
                                                onFocusChange: (value) {
                                                  setState(() {
                                                    double s = (int.parse(itemsData[index].price_per_month.text.toString().replaceAll(",", "")) -
                                                            int.parse(itemsData[index].discount.text.toString().replaceAll(",", "")))
                                                        .toDouble();
                                                    MoneyFormatterOutput fo = MoneyFormatter(amount: s).output;
                                                    itemsData[index].finalPrice.text = fo.withoutFractionDigits;
                                                  });
                                                  MoneyFormatterOutput fo = MoneyFormatter(amount: double.parse(itemsData[index].discount.text.toString())).output;

                                                  setState(() {
                                                    itemsData[index].discount.text = fo.withoutFractionDigits;
                                                    taxset(index);
                                                    sumwithTax();
                                                  });
                                                },
                                                child: TextFormField(
                                                  keyboardType: TextInputType.number,
                                                  onChanged: (string) {
                                                    string = '${formNum(
                                                      string.replaceAll(',', ''),
                                                    )}';
                                                    itemsData[index].discount.value = TextEditingValue(
                                                      text: string,
                                                      selection: TextSelection.collapsed(
                                                        offset: string.length,
                                                      ),
                                                    );
                                                    setState(() {
                                                      if (itemsData[index].price_per_month.text.isNotEmpty) {
                                                        double s = (int.parse(itemsData[index].price_per_month.text.toString().replaceAll(",", "")) -
                                                                int.parse(itemsData[index].discount.text.toString().replaceAll(",", "")))
                                                            .toDouble();
                                                        MoneyFormatterOutput fo = MoneyFormatter(amount: s).output;
                                                        itemsData[index].finalPrice.text = fo.withoutFractionDigits;
                                                      }
                                                    });
                                                    setSumprice(index);
                                                    taxset(index);
                                                    sumwithTax();
                                                    calfirstremaining();
                                                    calSecondRaminig();
                                                  },
                                                  controller: itemsData[index].discount,
                                                  style: TextStyle(fontSize: 13),
                                                  decoration: InputDecoration(
                                                    suffixIcon: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text("ريال", style: TextStyle(fontFamily: "iranyekan", fontSize: 10)),
                                                      ],
                                                    ),
                                                    contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                                    hoverColor: Colors.white,
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                      borderSide: BorderSide(
                                                        width: 0,
                                                        style: BorderStyle.none,
                                                      ),
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                            child: Text(
                                              'اجاره نهایی ماهانه',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                  boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                              width: 140,
                                              height: 35,
                                              child: TextFormField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    setSumprice(index);
                                                    taxset(index);
                                                    sumwithTax();
                                                    taxset(index);
                                                    calfirstremaining();
                                                    calSecondRaminig();
                                                  });
                                                },
                                                keyboardType: TextInputType.number,
                                                controller: itemsData[index].finalPrice,
                                                style: TextStyle(fontSize: 13),
                                                decoration: InputDecoration(
                                                  suffixIcon: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("ريال", style: TextStyle(fontFamily: "iranyekan", fontSize: 10)),
                                                    ],
                                                  ),
                                                  contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                                  hoverColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                    borderSide: BorderSide(
                                                      width: 0,
                                                      style: BorderStyle.none,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                              )),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                            child: Text(
                                              'جمع اجاره مدت اکران',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                  boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                              width: 140,
                                              height: 35,
                                              child: TextFormField(
                                                keyboardType: TextInputType.number,
                                                onChanged: (value) {
                                                  MoneyFormatterOutput fo = MoneyFormatter(amount: double.parse(itemsData[index].sumPrice.text.toString())).output;
                                                  setState(() {
                                                    itemsData[index].sumPrice.text = fo.withoutFractionDigits;
                                                    calSecondRaminig();
                                                  });
                                                },
                                                controller: itemsData[index].sumPrice,
                                                style: TextStyle(fontSize: 13),
                                                decoration: InputDecoration(
                                                  suffixIcon: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("ريال", style: TextStyle(fontFamily: "iranyekan", fontSize: 10)),
                                                    ],
                                                  ),
                                                  contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                                  hoverColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                    borderSide: BorderSide(
                                                      width: 0,
                                                      style: BorderStyle.none,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                              )),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                            child: Text(
                                              "مالیات",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.symmetric(horizontal: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                  boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                              width: 60,
                                              height: 35,
                                              child: TextFormField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    print(((double.parse(taxpercent.text.isEmpty ? "0" : taxpercent.text) *
                                                                double.parse(sumpriceController.text.replaceAll(',', '').length <= 3 ? "0" : sumpriceController.text.replaceAll(',', ''))) /
                                                            100)
                                                        .toString());
                                                    itemsData[index].timedaymonth.text =
                                                        roundNumber((int.parse(itemsData[index].timemonth.text) + (int.parse(itemsData[index].timeday.text) / 30)).toDouble(), 3).toString();
                                                    setSumprice(index);
                                                    calfirstremaining();
                                                    calSecondRaminig();
                                                    sumwithTax();
                                                    taxset(index);
                                                  });
                                                },
                                                keyboardType: TextInputType.number,
                                                controller: itemsData[index].tax,
                                                style: TextStyle(fontSize: 13),
                                                decoration: InputDecoration(
                                                  suffixIcon: Icon(
                                                    Icons.percent,
                                                    size: 15,
                                                  ),
                                                  contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                                  hoverColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                    borderSide: BorderSide(
                                                      width: 0,
                                                      style: BorderStyle.none,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                              )),
                                          Text(
                                            formNumTax(((int.parse(itemsData[index].tax.text.isEmpty ? "0" : itemsData[index].tax.text) *
                                                                int.parse(itemsData[index].sumPrice.text.replaceAll(',', '').length <= 3 ? "0" : itemsData[index].sumPrice.text.replaceAll(',', ''))) /
                                                            100)
                                                        .toString())
                                                    .toString() +
                                                " ريال",
                                            style: TextStyle(fontSize: 10),
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 9.0, right: 0),
                                            child: Text(
                                              'جمع اجاره با مالیات',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                  boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                              width: 130,
                                              height: 35,
                                              child: TextFormField(
                                                keyboardType: TextInputType.number,
                                                onChanged: (value) {
                                                  setState(() {
                                                    itemsData[index].sumTax.text = formNum(itemsData[index].sumTax.text);
                                                  });
                                                  calfirstremaining();
                                                  calSecondRaminig();
                                                },
                                                controller: itemsData[index].sumTax,
                                                style: TextStyle(fontSize: 13),
                                                decoration: InputDecoration(
                                                  suffixIcon: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("ريال", style: TextStyle(fontFamily: "iranyekan", fontSize: 10)),
                                                    ],
                                                  ),
                                                  contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                                  hoverColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                    borderSide: BorderSide(
                                                      width: 0,
                                                      style: BorderStyle.none,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                ),
                                              )),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                            child: Text(
                                              "توافق نور",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                  boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                              width: 110,
                                              height: 35,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  dropdownStyleData: DropdownStyleData(decoration: BoxDecoration(borderRadius: BorderRadius.circular(dimens.borderRadius), color: Colors.white)),
                                                  hint: Text(
                                                    'انتخاب کنید',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Theme.of(context).hintColor,
                                                    ),
                                                  ),
                                                  items: offrules
                                                      .map((var item) => DropdownMenuItem<String>(
                                                            value: item,
                                                            child: Text(
                                                              item,
                                                              style: const TextStyle(
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                  value: itemsData[index].light.toString().isNotEmpty ? itemsData[index].light.toString() : null,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      itemsData[index].light = value!;
                                                    });
                                                  },
                                                  buttonStyleData: ButtonStyleData(
                                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                                      height: 40,
                                                      width: 130,
                                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius))),
                                                  menuItemStyleData: const MenuItemStyleData(
                                                    height: 40,
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                            child: Text(
                                              "قانون خاموشی",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                  boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                              width: 117,
                                              height: 35,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton2<String>(
                                                  dropdownStyleData: DropdownStyleData(decoration: BoxDecoration(borderRadius: BorderRadius.circular(dimens.borderRadius), color: Colors.white)),
                                                  hint: Text(
                                                    'انتخاب کنید',
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      color: Theme.of(context).hintColor,
                                                    ),
                                                  ),
                                                  items: offrules2
                                                      .map((var item) => DropdownMenuItem<String>(
                                                            value: item,
                                                            child: Text(
                                                              item,
                                                              style: const TextStyle(
                                                                fontSize: 9,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                  value: itemsData[index].off.toString().isNotEmpty ? itemsData[index].off.toString() : null,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      itemsData[index].off = value!;
                                                    });
                                                  },
                                                  buttonStyleData: ButtonStyleData(
                                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                                      height: 40,
                                                      width: 130,
                                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius))),
                                                  menuItemStyleData: const MenuItemStyleData(
                                                    height: 40,
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                      index == 0
                                          ? Container()
                                          : Padding(
                                              padding: const EdgeInsets.only(top: 20.0),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    itemsData.removeAt(index);
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        BillboardCode.indexOf(itemsData[index].Code.toString()) == 0
                                            ? ""
                                            : "استان: ${BillboardData[BillboardCode.indexOf(itemsData[index].Code.toString()) - 1]["State"] + " شهر: " + BillboardData[BillboardCode.indexOf(itemsData[index].Code.toString()) - 1]["City"]} آدرس: ${BillboardData[BillboardCode.indexOf(itemsData[index].Code.toString()) - 1]["Location"]} دید: ${BillboardData[BillboardCode.indexOf(itemsData[index].Code.toString()) - 1]["view"]} طول تابلو: ${BillboardData[BillboardCode.indexOf(itemsData[index].Code.toString()) - 1]["Page_lenght"]} عرض تابلو: ${BillboardData[BillboardCode.indexOf(itemsData[index].Code.toString()) - 1]["Page_height"]}",
                                        style: TextStyle(fontSize: 10),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                            child: Text(
                                              'اجرای چاپ',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                  boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                              width: 110,
                                              height: 35,
                                              child: DropdownButtonHideUnderline(
                                                  child: DropdownButton2<String>(
                                                isExpanded: true,
                                                hint: Text(
                                                  'انتخاب کنید',
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    color: Theme.of(context).hintColor,
                                                  ),
                                                ),
                                                items: printstatus
                                                    .map((item) => DropdownMenuItem(
                                                          value: item,
                                                          child: Text(
                                                            item,
                                                            style: const TextStyle(
                                                              fontSize: 9,
                                                            ),
                                                          ),
                                                        ))
                                                    .toList(),
                                                value: itemsData[index].printValue.toString().isNotEmpty ? itemsData[index].printValue.toString() : null,
                                                onChanged: (value) {
                                                  setState(() {
                                                    itemsData[index].printValue = value!;
                                                  });
                                                },
                                                buttonStyleData: ButtonStyleData(
                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                                  height: 40,
                                                  width: 200,
                                                ),
                                                dropdownStyleData: const DropdownStyleData(
                                                  decoration: BoxDecoration(color: Colors.white),
                                                  maxHeight: 200,
                                                ),
                                                menuItemStyleData: const MenuItemStyleData(
                                                  height: 40,
                                                ),
                                              )))
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                            child: Text(
                                              'اجرای نصب',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                  boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                              width: 110,
                                              height: 35,
                                              child: DropdownButtonHideUnderline(
                                                  child: DropdownButton2<String>(
                                                isExpanded: true,
                                                hint: Text(
                                                  'انتخاب کنید',
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    color: Theme.of(context).hintColor,
                                                  ),
                                                ),
                                                items: install
                                                    .map((item) => DropdownMenuItem(
                                                          value: item,
                                                          child: Text(
                                                            item,
                                                            style: const TextStyle(
                                                              fontSize: 9,
                                                            ),
                                                          ),
                                                        ))
                                                    .toList(),
                                                value: itemsData[index].installValue.toString().isNotEmpty ? itemsData[index].installValue.toString() : null,
                                                onChanged: (value) {
                                                  setState(() {
                                                    itemsData[index].installValue = value!;
                                                  });
                                                },
                                                buttonStyleData: ButtonStyleData(
                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                                  height: 40,
                                                  width: 200,
                                                ),
                                                dropdownStyleData: const DropdownStyleData(
                                                  decoration: BoxDecoration(color: Colors.white),
                                                  maxHeight: 200,
                                                ),
                                                menuItemStyleData: const MenuItemStyleData(
                                                  height: 40,
                                                ),
                                              )))
                                        ],
                                      ),
                                      Container(
                                        width: 165,
                                        height: 35,
                                      ),
                                      Container(
                                        width: 165,
                                        height: 35,
                                      ),
                                      Container(
                                        width: 165,
                                        height: 35,
                                      ),
                                      Container(
                                        width: 165,
                                        height: 35,
                                      ),
                                      Container(
                                        width: 165,
                                        height: 35,
                                      ),
                                      Container(
                                        width: 165,
                                        height: 35,
                                      ),
                                      Container(
                                        width: 165,
                                        height: 35,
                                      ),
                                      Container(
                                        width: 165,
                                        height: 35,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("جمع اجاره کل ردیف ها: ${sumwithoutTax()} ريال"),
                              SizedBox(
                                width: 25,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                    child: Text(
                                      'هزینه چاپ و نصب',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(dimens.borderRadius),
                                          boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                      width: 165,
                                      height: 35,
                                      child: TextFormField(
                                        controller: printPriceController,
                                        onChanged: (string) {
                                          setState(() {
                                            sumTax();
                                            sumwithTax();

                                            calfirstremaining();
                                          });
                                          string = '${formNum(
                                            string.replaceAll(',', ''),
                                          )}';

                                          printPriceController.value = TextEditingValue(
                                            text: string,
                                            selection: TextSelection.collapsed(
                                              offset: string.length,
                                            ),
                                          );
                                        },
                                        style: TextStyle(fontSize: 13),
                                        decoration: InputDecoration(
                                          suffixIcon: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("ريال", style: TextStyle(fontFamily: "iranyekan", fontSize: 10)),
                                            ],
                                          ),
                                          contentPadding: EdgeInsets.only(bottom: 5, right: 5, left: 5),
                                          hoverColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(dimens.borderRadius),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      )),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                    child: Text(
                                      "مالیات",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(dimens.borderRadius),
                                          boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                      width: 60,
                                      height: 35,
                                      child: Focus(
                                        onFocusChange: (value) {},
                                        child: TextFormField(
                                          onChanged: (value) {
                                            setState(() {
                                              sumTax();
                                              sumwithTax();

                                              calfirstremaining();
                                            });
                                          },
                                          keyboardType: TextInputType.number,
                                          controller: finalTaxController,
                                          style: TextStyle(fontSize: 13),
                                          decoration: InputDecoration(
                                            suffixIcon: Icon(
                                              Icons.percent,
                                              size: 15,
                                            ),
                                            contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                            hoverColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(dimens.borderRadius),
                                              borderSide: BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                        ),
                                      )),
                                  Text(
                                    finalTaxController.text != "0"
                                        ? formNumTax((int.parse(printPriceController.text.replaceAll(',', '').length == 0 ? "0" : printPriceController.text.replaceAll(',', '')) /
                                                    int.parse(finalTaxController.text.isEmpty ? "10" : finalTaxController.text))
                                                .toString()) +
                                            "ريال"
                                        : formNumTax(
                                              (int.parse(printPriceController.text.replaceAll(',', '').length == 0 ? "0" : printPriceController.text.replaceAll(',', '')).toString()),
                                            ) +
                                            "ريال",
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Text("جمع مالیات ارزش افزوده: ${sumTax()} ريال"),
                              SizedBox(
                                width: 25,
                              ),
                              Text("جمع کل مبلغ: ${sumwithTax()} ريال"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, right: 20, left: 20, top: 20),
                      child: Row(children: [
                        Text("حق العمل کاری:  "),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(dimens.borderRadius),
                              boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                          width: 130,
                          height: 35,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'انتخاب کنید',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: hagholamalkar
                                  .map((item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: hagholamalkarValue,
                              onChanged: (value) {
                                setState(() {
                                  hagholamalkarValue = value;
                                  if (value == "دارد") {
                                    setState(() {
                                      hagh = true;
                                    });
                                  } else {
                                    setState(() {
                                      hagh = false;
                                    });
                                  }
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 40,
                                width: 200,
                              ),
                              dropdownStyleData: const DropdownStyleData(
                                decoration: BoxDecoration(color: Colors.white),
                                maxHeight: 200,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),

                              //This to clear the search value when you close the menu
                              onMenuStateChange: (isOpen) {
                                if (!isOpen) {
                                  searchCustomerController.clear();
                                }
                              },
                            ),
                          ),
                        ),
                        hagh
                            ? Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("حق العمل کار:  "),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(dimens.borderRadius),
                                        boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                    width: 165,
                                    height: 35,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        hint: Text(
                                          'انتخاب کنید',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        items: customerList
                                            .map((item) => DropdownMenuItem(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        value: hagholamalkarListValue,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == "انتخاب کنید") {
                                              setState(() {
                                                hagholamalkarListValue = value;
                                              });
                                            } else {
                                              print(customerList.indexOf(value.toString()));
                                              hagholamalkarListValue = value;
                                            }
                                          });
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          height: 40,
                                          width: 200,
                                        ),
                                        dropdownStyleData: const DropdownStyleData(
                                          decoration: BoxDecoration(color: Colors.white),
                                          maxHeight: 200,
                                        ),
                                        menuItemStyleData: const MenuItemStyleData(
                                          height: 40,
                                        ),
                                        dropdownSearchData: DropdownSearchData(
                                          searchController: searchCustomerController,
                                          searchInnerWidgetHeight: 50,
                                          searchInnerWidget: Container(
                                            height: 50,
                                            padding: const EdgeInsets.only(
                                              top: 8,
                                              bottom: 4,
                                              right: 8,
                                              left: 8,
                                            ),
                                            child: TextFormField(
                                              expands: true,
                                              maxLines: null,
                                              controller: searchCustomerController,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 8,
                                                ),
                                                hintText: 'جست و جو...',
                                                hintStyle: const TextStyle(fontSize: 12),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                          searchMatchFn: (item, searchValue) {
                                            return item.value.toString().contains(searchValue);
                                          },
                                        ),
                                        //This to clear the search value when you close the menu
                                        onMenuStateChange: (isOpen) {
                                          if (!isOpen) {
                                            searchCustomerController.clear();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("محاسبه حق العمل :  "),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(dimens.borderRadius),
                                        boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                    width: 130,
                                    height: 35,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        hint: Text(
                                          'انتخاب کنید',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        items: Calhagholamalkar.map((item) => DropdownMenuItem(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            )).toList(),
                                        value: CalhagholamalkarValue,
                                        onChanged: (value) {
                                          setState(() {
                                            CalhagholamalkarValue = value;
                                            if (value != "انتخاب کنید") {
                                              setState(() {
                                                payhagh = true;
                                              });
                                              if (value == "مبلغی") {
                                                setState(() {
                                                  Calhagh = true;
                                                  payhagh = false;
                                                });
                                              } else {
                                                setState(() {
                                                  Calhagh = false;
                                                });
                                              }
                                            } else {
                                              setState(() {
                                                payhagh = false;
                                              });
                                            }
                                          });
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          height: 40,
                                          width: 200,
                                        ),
                                        dropdownStyleData: const DropdownStyleData(
                                          decoration: BoxDecoration(color: Colors.white),
                                          maxHeight: 200,
                                        ),
                                        menuItemStyleData: const MenuItemStyleData(
                                          height: 40,
                                        ),

                                        //This to clear the search value when you close the menu
                                        onMenuStateChange: (isOpen) {
                                          if (!isOpen) {
                                            searchCustomerController.clear();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  !payhagh ? SizedBox() : Text("درصد حق العمل :  "),
                                  !payhagh
                                      ? SizedBox()
                                      : Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(dimens.borderRadius),
                                              boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                          width: 70,
                                          height: 35,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            onChanged: (string) {
                                              string = string.replaceAll(',', ''); // Remove existing commas
                                              int value = int.parse(string);
                                              String formattedString = intl.NumberFormat('#,###').format(value); // Format with commas
                                              prepayment.text = formattedString; // Set the formatted text back to the controller
                                              prepayment.selection = TextSelection.fromPosition(TextPosition(offset: prepayment.text.length)); // Move cursor to end

                                              print(formattedString);
                                              setState(() {
                                                calfirstremaining();

                                                print("firstreamining: $firstremaining");
                                              });
                                              calSecondRaminig();
                                            },
                                            controller: percentHagholamal,
                                            style: TextStyle(fontSize: 13),
                                            decoration: InputDecoration(
                                              suffixIcon: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(Calhagh ? "ريال" : "%", style: TextStyle(fontFamily: "iranyekan", fontSize: 10)),
                                                ],
                                              ),
                                              contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                              hoverColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                borderSide: BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                            ),
                                          )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("تعلق حق العمل به:  "),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(dimens.borderRadius),
                                        boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                    width: 165,
                                    height: 35,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        hint: Text(
                                          'انتخاب کنید',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        items: hagholamalTo
                                            .map((item) => DropdownMenuItem(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        value: hagholamalToValue,
                                        onChanged: (value) {
                                          setState(() {
                                            hagholamalToValue = value;
                                            if (value == "دارد") {
                                              setState(() {
                                                Calhagh = true;
                                              });
                                            } else {
                                              setState(() {
                                                Calhagh = false;
                                              });
                                            }
                                          });
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          height: 40,
                                          width: 200,
                                        ),
                                        dropdownStyleData: const DropdownStyleData(
                                          decoration: BoxDecoration(color: Colors.white),
                                          maxHeight: 200,
                                        ),
                                        menuItemStyleData: const MenuItemStyleData(
                                          height: 40,
                                        ),

                                        //This to clear the search value when you close the menu
                                        onMenuStateChange: (isOpen) {
                                          if (!isOpen) {
                                            searchCustomerController.clear();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("جمع مبلغ حق العمل:  "),
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(dimens.borderRadius),
                                          boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                      width: 140,
                                      height: 35,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (string) {
                                          string = string.replaceAll(',', ''); // Remove existing commas
                                          int value = int.parse(string);
                                          String formattedString = intl.NumberFormat('#,###').format(value); // Format with commas
                                          prepayment.text = formattedString; // Set the formatted text back to the controller
                                          sumHagholamal.selection = TextSelection.fromPosition(TextPosition(offset: prepayment.text.length)); // Move cursor to end
                                        },
                                        controller: sumHagholamal,
                                        style: TextStyle(fontSize: 13),
                                        decoration: InputDecoration(
                                          suffixIcon: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("ريال", style: TextStyle(fontFamily: "iranyekan", fontSize: 10)),
                                            ],
                                          ),
                                          contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                          hoverColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(dimens.borderRadius),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      )),
                                  Text("نحوه پرداخت حق العمل:  "),
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(dimens.borderRadius),
                                          boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                      width: 140,
                                      height: 35,
                                      child: TextFormField(
                                        controller: descHagholamal,
                                        style: TextStyle(fontSize: 13),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                          hoverColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(dimens.borderRadius),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      )),
                                ],
                              )
                            : SizedBox()
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, right: 20, left: 20, top: 20),
                      child: Row(children: [
                        Text("بند ت:  "),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(dimens.borderRadius),
                              boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                          width: 165,
                          height: 35,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'انتخاب کنید',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: hagholamalkar
                                  .map((item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: BandT,
                              onChanged: (value) {
                                setState(() {
                                  BandT = value;
                                  if (value == "دارد") {
                                    setState(() {
                                      bandTcheck = true;
                                    });
                                  } else {
                                    setState(() {
                                      bandTcheck = false;
                                    });
                                  }
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 40,
                                width: 200,
                              ),
                              dropdownStyleData: const DropdownStyleData(
                                decoration: BoxDecoration(color: Colors.white),
                                maxHeight: 200,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),

                              //This to clear the search value when you close the menu
                              onMenuStateChange: (isOpen) {
                                if (!isOpen) {
                                  searchCustomerController.clear();
                                }
                              },
                            ),
                          ),
                        ),
                        bandTcheck
                            ? Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("محاسبه بند ت:  "),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(dimens.borderRadius),
                                        boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                    width: 130,
                                    height: 35,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        hint: Text(
                                          'انتخاب کنید',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        items: Calhagholamalkar.map((item) => DropdownMenuItem(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )).toList(),
                                        value: CalBandTValue,
                                        onChanged: (value) {
                                          setState(() {
                                            CalBandTValue = value;
                                            if (value != "انتخاب کنید") {
                                              setState(() {
                                                payBandT = true;
                                              });
                                              if (value == "مبلغی") {
                                                setState(() {
                                                  CalBandT = true;
                                                  payBandT = false;
                                                });
                                              } else {
                                                setState(() {
                                                  CalBandT = false;
                                                });
                                              }
                                            } else {
                                              setState(() {
                                                payBandT = false;
                                              });
                                            }
                                          });
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          height: 40,
                                          width: 200,
                                        ),
                                        dropdownStyleData: const DropdownStyleData(
                                          decoration: BoxDecoration(color: Colors.white),
                                          maxHeight: 200,
                                        ),
                                        menuItemStyleData: const MenuItemStyleData(
                                          height: 40,
                                        ),

                                        //This to clear the search value when you close the menu
                                        onMenuStateChange: (isOpen) {
                                          if (!isOpen) {
                                            searchCustomerController.clear();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  !payBandT ? SizedBox() : Text("درصد بند ت:  "),
                                  !payBandT
                                      ? SizedBox()
                                      : Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(dimens.borderRadius),
                                              boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                          width: 70,
                                          height: 35,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            onChanged: (string) {
                                              string = string.replaceAll(',', ''); // Remove existing commas
                                              int value = int.parse(string);
                                              String formattedString = intl.NumberFormat('#,###').format(value); // Format with commas
                                              prepayment.text = formattedString; // Set the formatted text back to the controller
                                              prepayment.selection = TextSelection.fromPosition(TextPosition(offset: prepayment.text.length)); // Move cursor to end

                                              print(formattedString);
                                              setState(() {
                                                calfirstremaining();

                                                print("firstreamining: $firstremaining");
                                              });
                                              calSecondRaminig();
                                            },
                                            controller: percentHBandT,
                                            style: TextStyle(fontSize: 13),
                                            decoration: InputDecoration(
                                              suffixIcon: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(Calhagh ? "ريال" : "%", style: TextStyle(fontFamily: "iranyekan", fontSize: 10)),
                                                ],
                                              ),
                                              contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                              hoverColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                borderSide: BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                            ),
                                          )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("تعلق بند ت به:  "),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(dimens.borderRadius),
                                        boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                    width: 165,
                                    height: 35,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        hint: Text(
                                          'انتخاب کنید',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        items: hagholamalTo
                                            .map((item) => DropdownMenuItem(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        value: BandtTo,
                                        onChanged: (value) {
                                          setState(() {
                                            BandtTo = value;
                                            if (value == "دارد") {
                                              setState(() {
                                                Calhagh = true;
                                              });
                                            } else {
                                              setState(() {
                                                Calhagh = false;
                                              });
                                            }
                                          });
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          height: 40,
                                          width: 200,
                                        ),
                                        dropdownStyleData: const DropdownStyleData(
                                          decoration: BoxDecoration(color: Colors.white),
                                          maxHeight: 200,
                                        ),
                                        menuItemStyleData: const MenuItemStyleData(
                                          height: 40,
                                        ),

                                        //This to clear the search value when you close the menu
                                        onMenuStateChange: (isOpen) {
                                          if (!isOpen) {
                                            searchCustomerController.clear();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("شمول VAT در بند ت:  "),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(dimens.borderRadius),
                                        boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                    width: 165,
                                    height: 35,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        isExpanded: true,
                                        hint: Text(
                                          'انتخاب کنید',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                        items: VATlist.map((item) => DropdownMenuItem(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            )).toList(),
                                        value: VATvalue,
                                        onChanged: (value) {
                                          setState(() {
                                            VATvalue = value;
                                          });
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                          height: 40,
                                          width: 200,
                                        ),
                                        dropdownStyleData: const DropdownStyleData(
                                          decoration: BoxDecoration(color: Colors.white),
                                          maxHeight: 200,
                                        ),
                                        menuItemStyleData: const MenuItemStyleData(
                                          height: 40,
                                        ),

                                        //This to clear the search value when you close the menu
                                        onMenuStateChange: (isOpen) {
                                          if (!isOpen) {
                                            searchCustomerController.clear();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("جمع مبلغ بند ت:  "),
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(dimens.borderRadius),
                                          boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                      width: 140,
                                      height: 35,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (string) {
                                          string = string.replaceAll(',', ''); // Remove existing commas
                                          int value = int.parse(string);
                                          String formattedString = intl.NumberFormat('#,###').format(value); // Format with commas
                                          sumBandT.text = formattedString; // Set the formatted text back to the controller
                                          sumBandT.selection = TextSelection.fromPosition(TextPosition(offset: prepayment.text.length)); // Move cursor to end

                                          print(formattedString);
                                        },
                                        controller: sumBandT,
                                        style: TextStyle(fontSize: 13),
                                        decoration: InputDecoration(
                                          suffixIcon: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("ريال", style: TextStyle(fontFamily: "iranyekan", fontSize: 10)),
                                            ],
                                          ),
                                          contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                          hoverColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(dimens.borderRadius),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      )),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text("توضیحات بند ت: "),
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(dimens.borderRadius),
                                          boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                      width: 140,
                                      height: 35,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: BandTController,
                                        style: TextStyle(fontSize: 13),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                          hoverColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(dimens.borderRadius),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      )),
                                ],
                              )
                            : SizedBox()
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, right: 20, left: 20, top: 20),
                      child: Row(children: [
                        Text("پیش پرداخت:  "),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(dimens.borderRadius),
                                boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                            width: 140,
                            height: 35,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (string) {
                                string = string.replaceAll(',', ''); // Remove existing commas
                                int value = int.parse(string);
                                String formattedString = intl.NumberFormat('#,###').format(value); // Format with commas
                                prepayment.text = formattedString; // Set the formatted text back to the controller
                                prepayment.selection = TextSelection.fromPosition(TextPosition(offset: prepayment.text.length)); // Move cursor to end

                                print(formattedString);
                                setState(() {
                                  calfirstremaining();

                                  print("firstreamining: $firstremaining");
                                });
                                calSecondRaminig();
                              },
                              controller: prepayment,
                              style: TextStyle(fontSize: 13),
                              decoration: InputDecoration(
                                suffixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("ريال", style: TextStyle(fontFamily: "iranyekan", fontSize: 10)),
                                  ],
                                ),
                                contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                hoverColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(dimens.borderRadius),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            )),
                        SizedBox(
                          width: 30,
                        ),
                        Text("سررسید:  "),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(dimens.borderRadius),
                                boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                            width: 110,
                            height: 35,
                            child: TextFormField(
                              controller: sarresid,
                              style: TextStyle(fontSize: 13),
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () async {
                                    Jalali? selectedDate = await showIRJalaliDatePickerDialog(
                                      context: context,
                                      title: "انتخاب تاریخ",
                                      visibleTodayButton: true,
                                      todayButtonText: "انتخاب امروز",
                                      confirmButtonText: "تایید",
                                      initialDate: Jalali.now(),
                                    );
                                    sarresid.text = selectedDate!.year.toString() +
                                        (selectedDate.month.toString().length == 1 ? "0" + selectedDate.month.toString() : selectedDate.month.toString()) +
                                        (selectedDate.day.toString().length == 1 ? "0" + selectedDate.day.toString() : selectedDate.day.toString());
                                    selectedDatejalali = selectedDate;
                                  },
                                  child: Icon(
                                    Icons.calendar_month,
                                    color: colors.mainColor,
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                hoverColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(dimens.borderRadius),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            )),
                        SizedBox(
                          width: 30,
                        ),
                        Text("بصورت:  "),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(dimens.borderRadius),
                              boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                          width: 165,
                          height: 35,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'انتخاب کنید',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: paymentmethod
                                  .map((item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: paymentmethodValue,
                              onChanged: (value) {
                                setState(() {
                                  paymentmethodValue = value;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 40,
                                width: 200,
                              ),
                              dropdownStyleData: const DropdownStyleData(
                                decoration: BoxDecoration(color: Colors.white),
                                maxHeight: 200,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),

                              //This to clear the search value when you close the menu
                              onMenuStateChange: (isOpen) {
                                if (!isOpen) {
                                  searchCustomerController.clear();
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "مبلغ باقی مانده پس از پیش پرداخت: ${formNum(firstremaining.toString())} ریال",
                          style: TextStyle(color: Colors.red),
                        )
                      ]),
                    ),
                    Row(
                      children: [
                        Text("پرداخت چاپ و نصب:    "),
                        Text("مجزا"),
                        Checkbox(
                          value: checkedValue,
                          checkColor: colors.mainColor,
                          activeColor: Colors.white,
                          onChanged: (value) {
                            setState(
                              () {
                                print(value);
                                checkedValue = value!;
                                checkedValue2 = !value;
                                // int.parpaymentPrice.replaceAll(",", "") - ;
                              },
                            );
                          },
                        ),
                        Text("با اجاره"),
                        Checkbox(
                          value: checkedValue2,
                          checkColor: colors.mainColor,
                          activeColor: Colors.white,
                          onChanged: (value) {
                            setState(
                              () {
                                print(value);
                                checkedValue = !value!;

                                checkedValue2 = value;
                              },
                            );
                          },
                        ),
                        Text("     تعداد اقساط:  "),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(dimens.borderRadius),
                                boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                            width: 50,
                            height: 35,
                            child: TextFormField(
                              controller: countghest,
                              onChanged: (value) {
                                setAghsat(value);

                                calSecondRaminig();
                              },
                              style: TextStyle(fontSize: 13),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                hoverColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(dimens.borderRadius),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            )),
                        SizedBox(
                          width: 30,
                        ),
                        Text("با فاصله:  "),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(dimens.borderRadius),
                                boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                            width: 50,
                            height: 35,
                            child: TextFormField(
                              onChanged: (value) {
                                int len = int.parse(countghest.text.length == 0 ? "0" : countghest.text);
                                setState(() {
                                  ghestItems.clear();
                                });
                                for (int i = 0; i < len; i++) {
                                  setState(() {
                                    int price = int.parse(sumwithTax().replaceAll(",", "")) - int.parse(prepayment.text.replaceAll(",", ""));
                                    price = (price / int.parse(countghest.text)).ceil();

                                    ghestItems.add(ghestModel(
                                        date: TextEditingController(),
                                        price: TextEditingController(text: formNumTax(price.toString())),
                                        paymentmethod: TextEditingController(),
                                        paymentmethodValue: "انتخاب کنید",
                                        selecteddate: Jalali.now(),
                                        paymentdesc: TextEditingController()));
                                  });
                                }
                              },
                              controller: bafasele,
                              style: TextStyle(fontSize: 13),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                hoverColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(dimens.borderRadius),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            )),
                        Text("  ماه      "),
                        Text(
                          "مبلغ باقی مانده پس از اقساط: ${formNum(secondremaining.toString())} ریال",
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                    ghestItems.length == 0
                        ? SizedBox()
                        : Container(
                            height: 400,
                            width: MediaQuery.of(context).size.width,
                            child: GridView.builder(
                              itemCount: ghestItems[0].date.text.isEmpty ? 1 : ghestItems.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(right: 10), // کاهش margin
                                        width: 150,
                                        height: 30,
                                        child: Center(
                                            child: Text(
                                          "قسط ${index + 1}",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                        decoration: BoxDecoration(
                                          color: colors.Box,
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                        )),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 2), // کاهش margin
                                      padding: EdgeInsets.only(top: 5), // کاهش padding
                                      width: MediaQuery.of(context).size.width / 5, // کاهش عرض ستون‌ها
                                      height: 130,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10), // کاهش borderRadius
                                        border: Border.all(
                                          color: colors.Box,
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              index != 0
                                                  ? Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 2.0, right: 5),
                                                          child: Text(
                                                            'سررسید',
                                                            style: TextStyle(fontSize: 12),
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10),
                                                            boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))],
                                                          ),
                                                          width: 130,
                                                          height: 35,
                                                          child: TextFormField(
                                                            controller: ghestItems[index].date,
                                                            style: TextStyle(fontSize: 13),
                                                            decoration: InputDecoration(
                                                              contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                                              hoverColor: Colors.white,
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10),
                                                                borderSide: BorderSide(
                                                                  width: 0,
                                                                  style: BorderStyle.none,
                                                                ),
                                                              ),
                                                              filled: true,
                                                              fillColor: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 9.0, right: 5),
                                                          child: InkWell(
                                                            onTap: () {
                                                              showIRJalaliDatePickerDialog(
                                                                context: context,
                                                                title: "انتخاب تاریخ",
                                                                visibleTodayButton: true,
                                                                todayButtonText: "انتخاب امروز",
                                                                confirmButtonText: "تایید",
                                                                initialDate: Jalali(1400, 4, 2),
                                                              );
                                                            },
                                                            child: Text(
                                                              'آغاز اکران قراردادی',
                                                              style: TextStyle(fontSize: 12),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                                boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                                            width: 110,
                                                            height: 35,
                                                            child: TextFormField(
                                                              readOnly: true,
                                                              controller: ghestItems[index].date,
                                                              style: TextStyle(fontSize: 13),
                                                              decoration: InputDecoration(
                                                                suffixIcon: InkWell(
                                                                  onTap: () async {
                                                                    Jalali? selectedDate = await showIRJalaliDatePickerDialog(
                                                                      context: context,
                                                                      title: "انتخاب تاریخ",
                                                                      visibleTodayButton: true,
                                                                      todayButtonText: "انتخاب امروز",
                                                                      confirmButtonText: "تایید",
                                                                      initialDate: Jalali.now(),
                                                                    ).then((value) {
                                                                      if (value != null) {
                                                                        setallaghsat(index, value).then((value) {
                                                                          // calSecondRaminig();
                                                                        });
                                                                      }
                                                                      return null;
                                                                    });
                                                                    if (selectedDate != null) {
                                                                      setState(() {
                                                                        // setDateGehst(selectedDate);
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Icon(
                                                                    Icons.calendar_month,
                                                                    color: colors.mainColor,
                                                                  ),
                                                                ),
                                                                contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                                                hoverColor: Colors.white,
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                                  borderSide: BorderSide(
                                                                    width: 0,
                                                                    style: BorderStyle.none,
                                                                  ),
                                                                ),
                                                                filled: true,
                                                                fillColor: Colors.white,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 2.0, right: 5),
                                                    child: Text(
                                                      'مبلغ',
                                                      style: TextStyle(fontSize: 12),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))],
                                                    ),
                                                    width: 130,
                                                    height: 35,
                                                    child: TextFormField(
                                                      controller: ghestItems[index].price,
                                                      style: TextStyle(fontSize: 13),
                                                      onChanged: (value) {
                                                        calSecondRaminig();
                                                      },
                                                      decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                                        hoverColor: Colors.white,
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          borderSide: BorderSide(
                                                            width: 0,
                                                            style: BorderStyle.none,
                                                          ),
                                                        ),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 2.0, right: 5),
                                                    child: Text(
                                                      'بصورت',
                                                      style: TextStyle(fontSize: 12),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(dimens.borderRadius),
                                                        boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))]),
                                                    width: 165,
                                                    height: 35,
                                                    child: DropdownButtonHideUnderline(
                                                      child: DropdownButton2<String>(
                                                        isExpanded: true,
                                                        hint: Text(
                                                          'انتخاب کنید',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Theme.of(context).hintColor,
                                                          ),
                                                        ),
                                                        items: paymentmethod
                                                            .map((item) => DropdownMenuItem(
                                                                  value: item,
                                                                  child: Text(
                                                                    item,
                                                                    style: const TextStyle(
                                                                      fontSize: 14,
                                                                    ),
                                                                  ),
                                                                ))
                                                            .toList(),
                                                        value: ghestItems[index].paymentmethodValue,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            ghestItems[index].paymentmethodValue = value!;
                                                          });
                                                        },
                                                        buttonStyleData: ButtonStyleData(
                                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(dimens.borderRadius)),
                                                          padding: EdgeInsets.symmetric(horizontal: 16),
                                                          height: 40,
                                                          width: 200,
                                                        ),
                                                        dropdownStyleData: const DropdownStyleData(
                                                          decoration: BoxDecoration(color: Colors.white),
                                                          maxHeight: 200,
                                                        ),
                                                        menuItemStyleData: const MenuItemStyleData(
                                                          height: 40,
                                                        ),

                                                        //This to clear the search value when you close the menu
                                                        onMenuStateChange: (isOpen) {
                                                          if (!isOpen) {
                                                            searchCustomerController.clear();
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 2.0, right: 5),
                                                    child: Text(
                                                      'توضیح',
                                                      style: TextStyle(fontSize: 12),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      boxShadow: [BoxShadow(blurRadius: 15, spreadRadius: 0, offset: Offset(0, 4), color: Colors.black.withOpacity(0.03))],
                                                    ),
                                                    width: 130,
                                                    height: 35,
                                                    child: TextFormField(
                                                      controller: ghestItems[index].paymentdesc,
                                                      style: TextStyle(fontSize: 13),
                                                      decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.only(bottom: 5, right: 5),
                                                        hoverColor: Colors.white,
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          borderSide: BorderSide(
                                                            width: 0,
                                                            style: BorderStyle.none,
                                                          ),
                                                        ),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              },
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, childAspectRatio: 2),
                              padding: EdgeInsets.zero,
                            )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              hoverColor: Colors.transparent,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 20, bottom: 50, top: 0),
                                width: 85,
                                height: 40,
                                child: Center(
                                  child: Text(
                                    "بازگشت",
                                    style: TextStyle(color: Colors.black, fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                sendCheckListInfoToAPI().then((value) {
                                  generatePDF().whenComplete(() {
                                    setState(() {
                                      length = itemsData.length;
                                      ghestCount = int.parse(countghest.text);
                                    });
                                    sendDataToAPI().then((value) {
                                      sendGhest().then((value) {});
                                    });
                                  });
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 50, bottom: 50, top: 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [colors.firstColorGradient, colors.secondColorGradient],
                                  ),
                                ),
                                width: 85,
                                height: 40,
                                child: Center(
                                    child: Text(
                                  "ثبت",
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ]));
            }),
      ),
    )));
  }

  void calfirstremaining() {
    firstremaining = int.parse(sumwithTax().replaceAll(",", "")) - int.parse(prepayment.text.length == 0 ? "0" : prepayment.text.replaceAll(",", ""));
  }

  Future<void> setallaghsat(int index, Jalali value) async {
    setState(() {
      ghestItems[index].date.text = value.year.toString() +
          (value.month.toString().length == 1 ? "0" + value.month.toString() : value.month.toString()) +
          (value.day.toString().length == 1 ? "0" + value.day.toString() : value.day.toString());
      print("ghest count:" + ghestCount.toString());

      print("remove ghest ${ghestItems.length}");

      int bafaseleNum = int.parse(bafasele.text);
      int price = int.parse(sumwithTax().replaceAll(",", "")) - int.parse(prepayment.text.replaceAll(",", ""));
      price = (price / int.parse(countghest.text)).ceil();
      removeGhest().then((_) {
        for (int i = 1; i < ghestCount; i++) {
          print("first for1");
          if (value.month >= 1 && value.month <= 6) {
            for (int i = 0; i < bafaseleNum; i++) {
              print("second for1");

              if (value.month >= 6 && (value.day == 31 || value.day == 30)) {
                setState(() {
                  value = value.addDays(30);
                  value = Jalali(value.year, value.month, 30);
                  print("000011: ${value.year}${value.month}${value.day}");
                });
              } else {
                setState(() {
                  value = value.addDays(31);
                  print("000012: ${value.year}${value.month}${value.day}");
                });
              }
            }
          } else if (value.month >= 7 && value.month <= 11) {
            for (int i = 0; i < bafaseleNum; i++) {
              if (value.month == 11 && value.day == 30 && !value.isLeapYear()) {
                value = value.addDays(28);
                // value = Jalali(value.year, value.month, 30);
                print("000011a: ${value.year}${value.month}${value.day}");
              } else {
                value = value.addDays(30);
                print("000012a: ${value.year}${value.month}${value.day}");
              }
            }
          }
          print("0000: month: " + value.month.toString() + " day: " + value.day.toString());

          // Jalali newDate = value.addMonths(bafaseleNum * i);

          // // Check for month validity and adjust day if necessary
          // int dd = newDate.day;
          // int mm = newDate.month;

          // // Adjust day for months with less than 31 days
          // if (mm > 6 && dd > 30) {
          //   dd = 30;
          // } else if (mm == 12 && dd > 29) {
          //   dd = 29;
          // }

          // // Create a new valid Jalali date
          // Jalali jDate;
          // try {
          //   jDate = Jalali(newDate.year, mm, dd);
          // } catch (e) {
          //   print('Invalid date: ${newDate.year}-$mm-$dd');
          //   continue;
          // }

          // print("0000: ${mm.toString()} ${dd.toString()}");

          setState(() {
            String formattedDate = '${value.year.toString()}${value.month.toString().padLeft(2, '0')}${value.day.toString().padLeft(2, '0')}';
            ghestItems.add(ghestModel(
                date: TextEditingController(text: formattedDate),
                price: TextEditingController(text: formNumTax(price.toString())),
                paymentmethod: TextEditingController(text: "Hi"),
                paymentmethodValue: "انتخاب کنید",
                selecteddate: value,
                paymentdesc: TextEditingController()));

            String formattedString = intl.NumberFormat('#,###').format(price); // Format with commas
            ghestItems[i].price.text = formattedString; // Set the formatted text back to the controller
            ghestItems[i].price.selection = TextSelection.fromPosition(TextPosition(offset: ghestItems[i].price.text.length)); // Move cursor to end
          });
        }
      });

      print("Hi:::" + value.year.toString());
    });
  }

  void setAghsat(String value) {
    int len = int.parse(value);
    setState(() {
      ghestCount = int.parse(value);
    });
    setState(() {
      ghestItems.clear();
    });
    for (int i = 0; i < 1; i++) {
      setState(() {
        ghestItems.add(ghestModel(
            date: TextEditingController(),
            price: TextEditingController(),
            paymentmethod: TextEditingController(),
            paymentmethodValue: "انتخاب کنید",
            selecteddate: Jalali.now(),
            paymentdesc: TextEditingController()));
      });
    }
  }

  Future<void> fetchCustomersData() async {
    final response = await http.get(Uri.parse('https://tco.ir/api/getCustomers.php'), headers: {"Accept": "application/json", "Access-Control_Allow_Origin": "*"});
    if (response.statusCode == 200) {
      setState(() {
        customerListJson = json.decode(response.body);
        print("Customers value length: " + customerListJson.length.toString());
      });
    } else {
      throw Exception('Failed to load Customers');
    }
  }

  double roundNumber(double value, int places) {
    num val = pow(10.0, places);
    return ((value * val).round().toDouble() / val);
  }

  void setSumprice(int index) {
    setState(() {
      String a = itemsData[index].finalPrice.text.replaceAll(",", "");

      MoneyFormatterOutput fo = MoneyFormatter(amount: (double.parse(a) * double.parse(itemsData[index].timedaymonth.text.toString()))).output;

      itemsData[index].sumPrice.text = fo.withoutFractionDigits;
    });
  }

  void payment() {
    setState(() {
      String a = prepayment.text.replaceAll(",", "");

      MoneyFormatterOutput fo = MoneyFormatter(amount: double.parse(prepayment.text)).output;

      prepayment.text = fo.withoutFractionDigits;
    });
  }

  void taxset(int index) {
    print("Tax " +
        ((int.parse(taxpercent.text.isEmpty ? "0" : taxpercent.text) * int.parse(sumpriceController.text.replaceAll(',', '').length <= 3 ? "0" : sumpriceController.text.replaceAll(',', ''))) / 100)
            .toString()
            .replaceAll(",", ""));
    double a =
        int.parse(taxpercent.text.isEmpty ? "0" : taxpercent.text) * int.parse(sumpriceController.text.replaceAll(',', '').length <= 3 ? "0" : sumpriceController.text.replaceAll(',', '')) / 100;
    print("Taxx " + a.toDouble().toString());
    print("Sum " + int.parse(itemsData[index].sumPrice.text.isEmpty ? "0" : itemsData[index].sumPrice.text.replaceAll(",", '')).toString());
    setState(() {
      itemsData[index].sumTax.text = formNum((int.parse(itemsData[index].sumPrice.text.isEmpty ? "0" : itemsData[index].sumPrice.text.replaceAll(",", '')) +
                  (((int.parse(itemsData[index].tax.text.isEmpty ? "0" : itemsData[index].tax.text) / 100) *
                      int.parse(itemsData[index].sumPrice.text.replaceAll(',', '').length <= 0 ? "0" : itemsData[index].sumPrice.text.replaceAll(',', '')))))
              .toString())
          .toString();
    });
  }

  String formNum(String s) {
    return intl.NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }

  String sumwithTax() {
    int sum = 0;
    for (int i = 0; i < itemsData.length; i++) {
      if (itemsData[i].sumPrice.text.isNotEmpty) {
        sum = sum + int.parse(itemsData[i].sumPrice.text.toString().replaceAll(",", ""));
      }
    }
    sum = sum + int.parse(sumTax().replaceAll(",", ""));
    sum = sum + int.parse(printPriceController.text.length == 0 ? "0" : printPriceController.text.replaceAll(",", ""));
    return formNum(sum.toString());
  }

  String formNumTax(String s) {
    return intl.NumberFormat.decimalPattern().format(
      customRound(double.parse(s), 0),
    );
  }

  dynamic customRound(number, place) {
    var valueForPlace = pow(10, place);
    return (number * valueForPlace).round() / valueForPlace;
  }

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse("https://tco.ir/api/ekranItems.php"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchDataBillboards() async {
    try {
      final response = await http.get(Uri.parse('https://tco.ir/api/home.php'), headers: {"Accept": "application/json", "Access-Control_Allow_Origin": "*"});
      if (response.statusCode == 200) {
        setState(() {
          BillboardData = json.decode(response.body);
          print("table value length: " + BillboardData.length.toString());
        });
      } else {
        throw Exception('Failed to load products');
      }
    } on Exception catch (_) {
      print("throwing new error");
      throw Exception("Error on server");
    }
  }

  String sumwithoutTax() {
    int sum = 0;
    for (int i = 0; i < itemsData.length; i++) {
      if (itemsData[i].sumPrice.text.isNotEmpty) {
        sum = sum + int.parse(itemsData[i].sumPrice.text.toString().replaceAll(",", ""));
      }
    }
    print(formNum(sum.toString()));
    return formNum(sum.toString());
  }

  String recivedId = "";
  bool _loading = false;
  String formNumber = "دریافت نشد";
  Future<String> sendCheckListInfoToAPI() async {
    print("userId" + userID);
    int index = Brands.indexOf(BrandValue.toString()) - 1;
    recivedBrandID = (BrandJson[index]["id"]).toString();
    int indexCustomer = customerList.indexOf(customerValue.toString()) - 1;
    recivedCustomerID = (customerListJson[indexCustomer]["id"]).toString();
    print("brandID: $recivedCustomerID");
    final response = await http.get(
        Uri.parse(
            "https://tco.ir/api/addCheckList.php?Contract_Type=${typevalue}&Cotract_template=${ContractTepmlateValue}&Mafasa=${mafasaTypeValue}&Brand_Id=${recivedBrandID}&Contract=${contractValue}&Cutomer_id=${recivedCustomerID}&print=&install=&prepayment=${prepayment.text}&duedate=${sarresid.text}&Paymentincash=${paymentmethodValue}&count=${countghest.text}&length=${bafasele.text}&userID=$userID&SalesManager=$ManageSellerValue&Selller=$SellerValue&Commissionallocation=$CommissionValue&installPrice=${printPriceController.text}&PriceTax=${finalTaxController.text}&hagholmalkari=${hagholamalkarValue}&hagholmalkariID=${"10"}&CalhagholAmal=${CalhagholamalkarValue}&hagholamalTo=${hagholamalToValue}&sumhagholamal=${sumHagholamal.text}&descHagholAmal=${descHagholamal.text}&BandT=${BandT}&CalBandT=${CalBandTValue}&BandTto=${BandtTo}&vat=${VATvalue}&sumBandT=${sumBandT.text}&descBandT=${BandTController.text}&percentHagholAmal=${percentHagholamal.text}&percentBandT=${percentHBandT.text}"),
        headers: {"Accept": "application/json", "Access-Control_Allow_Origin": "*"});
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        Map<String, dynamic> data = jsonDecode(response.body);
        String id = data['id'];
        String formNumberNew = data['formNumber'];

        print('Received ID: $id');
        setState(() {
          recivedId = id;
          formNumber = formNumberNew;
        });
      });
    } else {
      throw Exception('Failed to load products');
    }

    return "id";
  }

  int ghestCount = 0;

  Future<void> sendGhest() async {
    if (ghestCount != 0) {
      setState(() {
        ghestCount--;
        _loading = true;
      });

      final response = await http.get(
          Uri.parse(
              "https://tco.ir/api/addGhest.php?ContractId=${recivedId}&no=${ghestCount}&date=${ghestItems[ghestCount].date.text}&price=${ghestItems[ghestCount].price.text}&type=${ghestItems[ghestCount].paymentmethodValue.toString()}&userId=${userID}"),
          headers: {"Accept": "application/json", "Access-Control_Allow_Origin": "*"});
      if (response.statusCode == 200) {
        setState(() {
          print(response.body);
          sendGhest();
        });
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      setState(() {
        length = 0;
        _loading = false;
        Navigator.of(context).pop();
      });
    }
  }

  int length = 0;

  Future<void> sendDataToAPI() async {
    if (length != 0) {
      setState(() {
        length--;
        _loading = true;
      });
      print(jsonEncode({
        'Contract_Id': recivedId,
        'Billboard_Id': BillboardData[BillboardCode.indexOf(itemsData[length].Code.toString())]["ID"],
        'start_show': itemsData[length].start.text,
        'day_show': itemsData[length].timeday.text,
        'month_show': itemsData[length].timemonth.text,
        'finish_show': itemsData[length].finish.text,
        'price_per_month': itemsData[length].price_per_month.text,
        'discount': itemsData[length].discount.text,
        'final_price': itemsData[length].finalPrice.text,
        'sum_price': itemsData[length].sumPrice.text,
        'light': itemsData[length].light,
        'off_rule': itemsData[length].off,
        'print': itemsData[length].printValue,
        'off_rule': itemsData[length].off
      }));

      final response = await http.get(
          Uri.parse(
              "https://tco.ir/api/addCheckListItem.php?Contract_Id=$recivedId&Billboard_Id=${BillboardData[BillboardCode.indexOf(itemsData[length].Code.toString()) - 1]["ID"].toString()}&start_show=${itemsData[length].start.text}&day_show=${itemsData[length].timeday.text}&month_show=${itemsData[length].timemonth.text}&finish_show=${itemsData[length].finish.text}&price_per_month=${itemsData[length].price_per_month.text}&discount=${itemsData[length].discount.text}&final_price=${itemsData[length].finalPrice.text}&sum_price=${itemsData[length].sumPrice.text}&light=${itemsData[length].light}&off_rule=${itemsData[length].off}&totalmonth=${itemsData[length].timedaymonth.text}&tax=${itemsData[length].tax.text}&sumtax=${itemsData[length].sumTax.text}&userID=$userID&install=${itemsData[length].installValue}&print=${itemsData[length].printValue}"),
          headers: {"Accept": "application/json", "Access-Control_Allow_Origin": "*"});
      if (response.statusCode == 200) {
        setState(() {
          print(response.body);
          sendDataToAPI();
        });
      } else {
        throw Exception('Failed to inset itme');
      }

      // print("[${jsonEncode(jsondata[0])}]");
      // print({'jsonInput': jsondata[0]});
    } else {
      setState(() {
        length = 0;
        _loading = false;
      });
    }
  }

  Future<List> getBrand(String BrandId) async {
    print("Brand value length: " + BrandId);
    final response = await http.get(Uri.parse('https://tco.ir/api/getBrands.php?CustomerId=$BrandId'), headers: {"Accept": "application/json", "Access-Control_Allow_Origin": "*"});
    if (response.statusCode == 200) {
      setState(() {
        BrandJson = json.decode(response.body);
        print("Brand value length: " + BrandJson.length.toString());
      });
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Brand');
    }
  }

  TextEditingController BrandName = TextEditingController();

  showAlertDialog(BuildContext context) async {
    int i = customerList.indexOf(customerValue!) - 1;
    String Name = (customerListJson[i]["name_haqiqi"].toString().length == 0 && customerListJson[i]["lastname_haqiqi"].toString().length == 0
        ? customerListJson[i]["name_hoqoqi"]
        : customerListJson[i]["name_haqiqi"].toString() + " " + customerListJson[i]["lastname_haqiqi"].toString());
    String id = customerListJson[i]["id"].toString();
    Widget continueButton = InkWell(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() {
          Brands.clear();
          BrandJson.clear();
        });
        setState(() {
          addBrand(BrandName.text, id).then((value) {
            _loading = false;
            Navigator.pop(context);
          });
          Brands.add("انتخاب کنید");
          BrandValue = "انتخاب کنید";
          getBrand(customerID.toString()).then((value) {
            setState(() {
              for (int i = 0; i < value.length; i++) {
                Brands.add("${i + 1}. " + BrandJson[i]["name"]);
              }
            });
          });
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [colors.firstColorGradient, colors.secondColorGradient],
          ),
        ),
        width: 85,
        height: 40,
        child: Center(
            child: Text(
          "ثبت",
          style: TextStyle(color: Colors.white),
        )),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
          width: 300,
          height: MediaQuery.of(context).size.height * .25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Positioned(
                      left: 5,
                      top: 5,
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.close))),
                  Positioned(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(),
                          Text(
                            "افزودن برند",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0, bottom: 5, top: 20),
                        child: Text("نام برند"),
                      ),
                      TextField(
                        controller: BrandName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(dimens.borderRadius),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text("برند وارده به مشتری $Name اضافه میگردد")
                    ],
                  ))
                ],
              ),
            ],
          )),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> addBrand(String BrandName2, String Id2) async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    try {
      final response = await http.get(
        Uri.parse("https://tco.ir/api/addBrand.php?BrandName=$BrandName2&CustomerId=$Id2"),
        headers: {"Accept": "application/json"},
      );
      if (response.statusCode == 200) {
        print("Request successful");
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> ManageSelectSeller(String unit, String degree) async {
    final response = await http.get(Uri.parse('https://tco.ir/api/selectUser.php?unit=$unit&degree=$degree'), headers: {"Accept": "application/json", "Access-Control_Allow_Origin": "*"});
    if (response.statusCode == 200) {
      setState(() {
        ManageSellerJson = json.decode(response.body);
        print("ManageSellerJson value length: " + ManageSellerJson.length.toString());
      });
    } else {
      throw Exception('Failed to load Customers');
    }
  }

  Future<void> selectSeller(String unit) async {
    final response = await http.get(Uri.parse('https://tco.ir/api/selectUser.php?unit=$unit'), headers: {"Accept": "application/json", "Access-Control_Allow_Origin": "*"});
    if (response.statusCode == 200) {
      setState(() {
        sellerJson = json.decode(response.body);
        print("Seller value length: " + sellerJson.length.toString());
      });
    } else {
      throw Exception('Failed to load Customers');
    }
  }

  void calculateDate(int month, int day, Jalali date, int index) {
    try {
      setState(() {
        print("Hey");
        print("add date: " + date.addMonths(month).addDays(day).toString());
        Jalali a = date.addMonths(month).addDays(day - 1);
        itemsData[index].finish.text =
            a.year.toString() + (a.month.toString().length == 1 ? "0" + a.month.toString() : a.month.toString()) + (a.day.toString().length == 1 ? "0" + a.day.toString() : a.day.toString());
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> removeGhest() async {
    for (int index = ghestCount - 1; index > 0; index--) {
      print("remove ghest: $index");
      setState(() {
        ghestItems.removeAt(index);
      });
    }
  }

  String sumTax() {
    int sum = 0;
    for (int i = 0; i < itemsData.length; i++) {
      sum = sum +
          (int.parse(itemsData[i].sumPrice.text.isEmpty ? "0" : itemsData[i].sumPrice.text.replaceAll(",", "")) * (int.parse(itemsData[i].tax.text.isEmpty ? "0" : itemsData[i].tax.text) / 100))
              .ceil();
    }
    if (finalTaxController.text != "0") {
      sum = sum +
          (int.parse(printPriceController.text.isEmpty ? "0" : printPriceController.text.replaceAll(",", "")) * (int.parse(finalTaxController.text.isEmpty ? "0" : finalTaxController.text) / 100))
              .ceil();
    } else {
      sum = sum + (int.parse(printPriceController.text.isEmpty ? "0" : printPriceController.text.replaceAll(",", ""))).ceil();
    }
    // sum =
    //     (int.parse(printPriceController.text.isEmpty ? "0" : printPriceController.text.replaceAll(",", "").toString()) * (int.parse(finalTaxController.text.isEmpty ? "0" : finalTaxController.text))) +
    //         int.parse(sumwithoutTax().replaceAll(",", ""));
    double a = double.parse((sum).toString());
    String b = a.toStringAsFixed(0);

    return formNum(sum.toString().length > 5 ? b.toString() : "0");
  }

  void setDateGehst(Jalali date) {
    // try {
    //   print("fuck");
    //   Jalali secondDate = date;
    //   ghestItems.clear();

    //   for (int index = 0; index < ghestCount; index++) {
    //     // if (index == 0) {
    //     //   Jalali newDate = selectedDatejalali.addMonths(1);
    //     //   ghestItems[index].date.text = newDate.year.toString() +
    //     //       (newDate.month.toString().length == 1 ? "0" + newDate.month.toString() : newDate.month.toString()) +
    //     //       (newDate.day.toString().length == 1 ? "0" + newDate.day.toString() : newDate.day.toString());
    //     // } else
    //     ghestItems.add(ghestModel(date: TextEditingController(), price: TextEditingController(), paymentmethod: TextEditingController(), paymentmethodValue: "", selecteddate: Jalali.now()));
    //     if (index == 0) {
    //       ghestItems[index].date.text = secondDate.year.toString() +
    //           (secondDate.month.toString().length == 1 ? "0" + secondDate.month.toString() : secondDate.month.toString()) +
    //           (secondDate.day.toString().length == 1 ? "0" + secondDate.day.toString() : secondDate.day.toString());
    //     }
    //     if (index >= 1) {
    //       secondDate = ghestItems[0].selecteddate!.addMonths(((index) * (int.parse(bafasele.text))));
    //       print("Hio:" + secondDate.month.toString());
    //       if (secondDate.month == 12 && secondDate.day == 29) {
    //         ghestItems[index].date.text = secondDate.year.toString() +
    //             (secondDate.month.toString().length == 1 ? "0" + secondDate.month.toString() : secondDate.month.toString()) +
    //             (secondDate.day.toString().length == 1 ? "0" + secondDate.day.toString() : "28");
    //       } else {
    //         ghestItems[index].date.text = secondDate.year.toString() +
    //             (secondDate.month.toString().length == 1 ? "0" + secondDate.month.toString() : secondDate.month.toString()) +
    //             (secondDate.day.toString().length == 1 ? "0" + secondDate.day.toString() : secondDate.day.toString());
    //       }
    //     }
    //     // ghestItems[index].price.text = formNum(
    //     //     ((int.parse(sumwithoutTax().replaceAll(',', '')).toDouble() - int.parse(prepayment.text.toString().length == 0 ? "0" : prepayment.text.toString()).toDouble()) /
    //     //             int.parse(countghest.text).toDouble())
    //     //         .ceil()
    //     //         .toString());
    //   }
    // } catch (e) {
    //   print("erorrr:$e");
    // }
  }
  Future<List<List<dynamic>>> readExcel() async {
    Workbook workbook = Workbook();
    final Worksheet sheet1 = workbook.worksheets[0];
    sheet1.getRangeByName('A1:A1').setText('ردیف');
    sheet1.getRangeByName('B1:B1').setText('کد تابلو');
    sheet1.getRangeByName('C1:C1').setText('استان');
    sheet1.getRangeByName('D1:D1').setText('محور/منطقه');

    sheet1.getRangeByName('E1:E1').setText('لوکشین');
    sheet1.getRangeByName('F1:F1').setText('دید');
    sheet1.getRangeByName('G1:G1').setText('سایز تابلو');

    sheet1.getRangeByName('H1:H1').setText('ت نور');
    sheet1.getRangeByName('I1:I1').setText('آغاز اکران');
    sheet1.getRangeByName('J1:J1').setText('مدت اکران');
    sheet1.getRangeByName('K1:K1').setText('خاتمه اکران');

    sheet1.getRangeByName('L1:L1').setText('اجاره ماهانه پس از تخفیف(ريال)');
    sheet1.getRangeByName('M1:M1').setText('جمع اجاره مدت اکران(ريال)');
    sheet1.getRangeByName('N1:N1').setText('مدیای چاپ');

    sheet1.getRangeByName('O1:O1').setText('نوع نصب');
    sheet1.getRangeByName('R1:R1').setText('کنترل');
    sheet1.getRangeByName('P1:P1').setText('اجرای چاپ');
    sheet1.getRangeByName('Q1:Q1').setText('اجرای نصب');

    for (int j = 0; j < itemsData.length; j++) {
      int index = j + 2;
      sheet1.getRangeByName('A$index:A$index').setText('${j + 1}');
      sheet1.getRangeByName('B$index:B$index').setText('${itemsData[j].Code}');
      sheet1.getRangeByName('C$index:C$index').setText('${BillboardData[BillboardCode.indexOf(itemsData[j].Code.toString()) - 1]["State"]}');
      sheet1.getRangeByName('D$index:D$index').setText('${BillboardData[BillboardCode.indexOf(itemsData[j].Code.toString()) - 1]["Area"]}');

      sheet1.getRangeByName('E$index:E$index').setText('${BillboardData[BillboardCode.indexOf(itemsData[j].Code.toString()) - 1]["Location"]}');
      sheet1.getRangeByName('F$index:F$index').setText('${BillboardData[BillboardCode.indexOf(itemsData[j].Code.toString()) - 1]["view"]}');
      sheet1
          .getRangeByName('G$index:G$index')
          .setText('${BillboardData[BillboardCode.indexOf(itemsData[j].Code.toString()) - 1]["Page_lenght"]}*${BillboardData[BillboardCode.indexOf(itemsData[j].Code.toString()) - 1]["Page_height"]}');

      sheet1.getRangeByName('H$index:H$index').setText('${itemsData[j].light}');
      sheet1.getRangeByName('I$index:I$index').setText('${itemsData[j].start.text.substring(0, 4)}/${itemsData[j].start.text.substring(4, 6)}/${itemsData[j].start.text.substring(6, 8)}');
      sheet1.getRangeByName('J$index:J$index').setText("${itemsData[j].timemonth.text} ماه و ${itemsData[j].timeday.text} روز = ${itemsData[j].timedaymonth.text}");
      sheet1.getRangeByName('K$index:K$index').setText('${itemsData[j].finish.text.substring(0, 4)}/${itemsData[j].finish.text.substring(4, 6)}/${itemsData[j].finish.text.substring(6, 8)}');

      sheet1.getRangeByName('L$index:L$index').setText('${itemsData[j].finalPrice.text}');
      sheet1.getRangeByName('M$index:M$index').setText('${itemsData[j].sumPrice.text}');

      sheet1.getRangeByName('N$index:N$index').setText('${BillboardData[BillboardCode.indexOf(itemsData[j].Code.toString()) - 1]["print_media"]}');

      sheet1.getRangeByName('O$index:O$index').setText('${BillboardData[BillboardCode.indexOf(itemsData[j].Code.toString()) - 1]["install_type"]}');
      sheet1.getRangeByName('P$index:P$index').setText('${itemsData[j].printValue}');
      sheet1.getRangeByName('Q$index:Q$index').setText('${itemsData[j].installValue}');

      sheet1.getRangeByName('R$index:R$index').setText('');
    }

    // final PdfDocument pdf =_key.currentState!.exportToPdfDocument();

    final List<int> e = workbook.saveAsStream();

    Uint8List a = Uint8List.fromList(e);

    var excel = excelLib.Excel.decodeBytes(a);
    var sheet = excel['Sheet1']; // Change 'Sheet1' to your sheet name
    List<List<dynamic>> data = [];

    for (var row in sheet.rows) {
      List<dynamic> rowData1 = [];
      for (var cell in row) {
        rowData1.add(cell!.value);
      }
      List<dynamic> rowData = rowData1.reversed.toList();
      data.add(rowData);
    }
    print("eh " + data.length.toString());
    List<dynamic> headerRow = data.removeAt(0);

    // Insert headerRow as column headers
    data.insert(0, headerRow);
    return data;
  }

  Future<void> generatePDF() async {
    // تبدیل تصویر به pw.MemoryImage
// خواندن تصویر از مسیر فایل

    // تبدیل تصویر به pw.MemoryImage
    String statusUser = customerListJson[customerList.indexOf(customerValue!) - 1]["statusUser"];
    String customerName = statusUser == "1"
        ? customerListJson[customerList.indexOf(customerValue!) - 1]["name_hoqoqi"]
        : customerListJson[customerList.indexOf(customerValue!) - 1]["name_haqiqi"] + customerListJson[customerList.indexOf(customerValue!) - 1]["lastname_haqiqi"];
    String customerCode = customerListJson[customerList.indexOf(customerValue!) - 1]["code"];
    String postCode = customerListJson[customerList.indexOf(customerValue!) - 1]["postcode"];
    String phone = customerListJson[customerList.indexOf(customerValue!) - 1]["phone"];
    String NationalCode = customerListJson[customerList.indexOf(customerValue!) - 1]["nationalcode"];
    String Landline_phone = customerListJson[customerList.indexOf(customerValue!) - 1]["Landline_phone"];
    String Landline_phone_no = customerListJson[customerList.indexOf(customerValue!) - 1]["Landline_phone_no"];
    String birthday = customerListJson[customerList.indexOf(customerValue!) - 1]["birthday_date"];

    String Address = customerListJson[customerList.indexOf(customerValue!) - 1]["address"];
    String National_ID = customerListJson[customerList.indexOf(customerValue!) - 1]["National_ID"];
    String Economic_code = customerListJson[customerList.indexOf(customerValue!) - 1]["Economic_code"];
    String sabt_code = customerListJson[customerList.indexOf(customerValue!) - 1]["sabt_code"];
    String signatory = customerListJson[customerList.indexOf(customerValue!) - 1]["signatory"];
    String signphone = customerListJson[customerList.indexOf(customerValue!) - 1]["phone"];
    String nameAgent = customerListJson[customerList.indexOf(customerValue!) - 1]["nameAgent"];
    String phoneAgent = customerListJson[customerList.indexOf(customerValue!) - 1]["phoneAgent"];
    print("Index: " + sellerList.indexOf(SellerValue!).toString());
    print("Index:  all " + sellerJson.length.toString());

    int sellerPersonelcode = sellerJson[sellerList.indexOf(SellerValue!)]["code"];
    int ManageSellerPersonelcode = ManageSellerJson[ManageSellerList.indexOf(ManageSellerValue!)]["code"];

    // String phoneAgent = customerListJson[customerList.indexOf(customerValue!) - 1]["phoneAgent"];
    // String phoneAgent = customerListJson[customerList.indexOf(customerValue!) - 1]["phoneAgent"];

// Load the image
    final imageBytes = await rootBundle.load('images/logo2.png');
    final image = pw.MemoryImage(imageBytes.buffer.asUint8List());

    // String Landline_phone = customerListJson[customerList.indexOf(customerValue!) - 1]["Landline_phone"];
    final pdf = pw.Document();
    List<List<dynamic>> excelData = await readExcel();
    final ttf = await rootBundle.load('fonts/IRANYekanRegular.ttf');
    final ttf2 = await rootBundle.load('fonts/IRANYekanRegular.ttf');

    final ttfFont = pw.Font.ttf(ttf);
    final ttfFont2 = pw.Font.ttf(ttf2);

    DateTime dt = DateTime.now();
    Jalali j = dt.toJalali();

    pdf.addPage(pw.MultiPage(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      pageFormat: PdfPageFormat.a4.landscape,
      header: (context) {
        return pw.Column(children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
              pw.Text("سریال فرم: $formNumber",
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                    fontSize: 6,
                    font: ttfFont,
                  )),
              pw.Text("تاریخ ثبت فرم: ${now()}",
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                    fontSize: 6,
                    font: ttfFont,
                  )),
              pw.Text("تاریخ گزارش: ${now()}",
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                    fontSize: 6,
                    font: ttfFont,
                  )),
            ]),
            pw.Text("فرم اولیه قرارداد",
                textDirection: pw.TextDirection.rtl,
                style: pw.TextStyle(
                  fontSize: 10,
                  font: ttfFont,
                )),
            pw.Image(
              image,
              width: 50,
              height: 50,
            ), // Adjust size as needed

//image here
          ]),
          pw.SizedBox(
            height: 10,
          ),
          pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                createHeaderCell("قرارداد", contractValue.toString() + " " + typevalue.toString() + " - " + ContractTepmlateValue.toString(), ttfFont, width: 145.8),
                createHeaderCell("درخواست مفاصاحساب بیمه", mafasaTypeValue.toString(), ttfFont, width: 145.8),
                createHeaderCellCustomer(ttfFont, width: 145.8),
                createHeaderCell("شماره قرارداد", "-", ttfFont, width: 145.8),
                createHeaderCell("تاریخ قرارداد", "-", ttfFont, width: 145.8),
              ])),
          pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Row(children: [
              createHeaderCell("کارشناس فروش", "$sellerPersonelcode $SellerValue", ttfFont, width: 243),
              createHeaderCell("مدیر فروش", "$ManageSellerPersonelcode $ManageSellerValue", ttfFont, width: 243),
              createHeaderCell("تخصیص کمسیون", CommissionValue.toString(), ttfFont, width: 243),
            ]),
          ),
          statusUser == "1"
              ? pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                    pw.Container(
                        width: 75,
                        height: 20,
                        padding: const pw.EdgeInsets.only(),
                        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25)),
                        child: pw.Center(
                            child: pw.Text("شخص حقوقی",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  font: ttfFont,
                                )))),
                    pw.Column(
                      children: [
                        pw.Row(children: [
                          createHeaderCell("کد مشتری", customerCode, ttfFont, width: 63.2),
                          createHeaderCell("مشتری", customerName, ttfFont, width: 180),
                          createHeaderCell("برند", BrandValue.toString(), ttfFont, width: 130.8),
                          createHeaderCell("شناسه ملی", National_ID.toString(), ttfFont),
                          createHeaderCell("ش ثبت", sabt_code.toString(), ttfFont, width: 80),
                          createHeaderCell("کد اقتصادی", Economic_code.toString(), ttfFont, width: 100),
                        ]),
                      ],
                    )
                  ]))
              : pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                    pw.Container(
                        width: 100,
                        height: 20,
                        padding: const pw.EdgeInsets.only(),
                        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25)),
                        child: pw.Center(
                            child: pw.Text("شخص حقیقی",
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  font: ttfFont,
                                )))),
                    createHeaderCell("مشتری", customerName.toString(), ttfFont, width: 137.5 + 129),
                    createHeaderCell("کد ملی", NationalCode.toString(), ttfFont, width: 87.5),
                    createHeaderCell("تاریخ تولد", birthday.toString(), ttfFont, width: 87.5),
                    createHeaderCell("تلفن همراه", phone.toString(), ttfFont, width: 87.5),
                    createHeaderCell("تلفن", Landline_phone.toString(), ttfFont, width: 100),
                    // createHeaderCell("کد پستی", postCode.toString(), ttfFont, width: 129),
                  ])),
          pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                createHeaderCell("صاحب امضا مجاز", signatory.toString(), ttfFont, width: 229),
                createHeaderCell("تلفن همراه", phone.toString(), ttfFont, width: 100),
                createHeaderCell("تلفن", Landline_phone.toString(), ttfFont, width: 100),
                createHeaderCell("داخلی", Landline_phone_no.toString(), ttfFont, width: 100),
                pw.Container(
                    width: 200,
                    height: 20,
                    padding: const pw.EdgeInsets.only(right: 5, top: 4),
                    decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25)),
                    child: pw.Text("رابط: $nameAgent\t تلفن:$phoneAgent",
                        textDirection: pw.TextDirection.rtl,
                        style: pw.TextStyle(
                          fontSize: 6,
                          font: ttfFont,
                        ))),
              ])),
          pw.Row(children: [
            createHeaderCell("آدرس", Address.toString(), ttfFont, width: 525),
            createHeaderCell("کد پستی", postCode.toString(), ttfFont, width: 129 + 75),
          ])
        ]);
      },
      build: (pw.Context context) => [
        pw.SizedBox(height: 15),
        pw.Directionality(
            child: pw.Table(border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey), columnWidths: {
              0: pw.FlexColumnWidth(0.7),
              1: pw.FlexColumnWidth(0.7),
              2: pw.FlexColumnWidth(0.7),
              3: pw.FlexColumnWidth(0.9),
              4: pw.FlexColumnWidth(0.9),
              5: pw.FlexColumnWidth(1.2),
              6: pw.FlexColumnWidth(1.2),
              7: pw.FlexColumnWidth(1),
              8: pw.FlexColumnWidth(1),
              9: pw.FlexColumnWidth(1),
              10: pw.FlexColumnWidth(0.7),
              11: pw.FlexColumnWidth(0.8),
              12: pw.FlexColumnWidth(1.2),
              13: pw.FlexColumnWidth(3),
              14: pw.FlexColumnWidth(1),
              15: pw.FlexColumnWidth(1),
              16: pw.FlexColumnWidth(1),
              17: pw.FlexColumnWidth(0.5),
            }, children: [
              for (int i = 0; i < excelData.length; i++)
                pw.TableRow(
                  decoration: i == 0 ? pw.BoxDecoration(color: PdfColors.blue50) : null,
                  children: [
                    for (var cell in excelData[i])
                      pw.Container(
                        padding: pw.EdgeInsets.only(right: 5),
                        height: 25,
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                          cell.toString(),
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(font: ttfFont, fontSize: 6),
                        ),
                      ),
                  ],
                ),
            ]),
            textDirection: pw.TextDirection.rtl),
        pw.SizedBox(height: 15),
        pw.Text("پیش پرداخت: ${prepayment.text} سررسید:${sarresid.text} بصورت: ${paymentmethodValue}                    تعداد اقساط: ${countghest.text}",
            textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(
              fontSize: 10,
              font: ttfFont,
            )),
        pw.SizedBox(height: 15),
        pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Container(
              width: 729,
              height: 15,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25)),
              child: pw.Row(children: [
                //column 1
                buildCell("ش قسط", ttfFont2, true),
                buildCell("سر رسید", ttfFont2, true),
                buildCell("مبلغ قسط(ریال)", ttfFont2, true),
                buildCell("نحوه پرداخت", ttfFont2, true),
                buildCell("توضیح", ttfFont2, true),

                //column 2
                buildCell("ش قسط", ttfFont2, true),
                buildCell("سر رسید", ttfFont2, true),
                buildCell("مبلغ قسط(ریال)", ttfFont2, true),
                buildCell("نحوه پرداخت", ttfFont2, true),
                buildCell("توضیح", ttfFont2, true),

                //column 3
                buildCell("ش قسط", ttfFont2, true),
                buildCell("سر رسید", ttfFont2, true),
                buildCell("مبلغ قسط(ریال)", ttfFont2, true),
                buildCell("نحوه پرداخت", ttfFont2, true),
                buildCell("توضیح", ttfFont2, true),

                //column 4
                // buildCell("ش قسط", ttfFont, width: 28),
                // buildCell("سر رسید", ttfFont),
                // buildCell("مبلغ قسط(ریال)", ttfFont),
                // buildCell("نحوه پرداخت", ttfFont),
                // buildCell("توضیح", ttfFont),

                // //column 5
                // buildCell("ش قسط", ttfFont),
                // buildCell("سر رسید", ttfFont),
                // buildCell("مبلغ قسط(ریال)", ttfFont),
              ])),
        ),
        pw.ListView.builder(
            itemBuilder: (context, index) {
              return pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Container(
                    width: 729,
                    height: 15,
                    decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25)),
                    child: pw.Row(children: [
                      //column 1
                      ghestCount > (1 + (3 * index)) - 1 ? buildCell("${1 + (3 * index)}", ttfFont, true) : buildCell("-", ttfFont, true),
                      ghestCount > (1 + (3 * index)) - 1 ? buildCell("${ghestItems[(1 + (3 * index)) - 1].date.text}", ttfFont, false) : buildCell("-", ttfFont, true),
                      ghestCount > (1 + (3 * index)) - 1 ? buildCell("${ghestItems[(1 + (3 * index)) - 1].price.text}", ttfFont, false) : buildCell("-", ttfFont, true),
                      ghestCount > (1 + (3 * index)) - 1 ? buildCell("${ghestItems[(1 + (3 * index)) - 1].paymentmethodValue}", ttfFont, false) : buildCell("-", ttfFont, true),
                      ghestCount > (1 + (3 * index)) - 1 ? buildCell("${ghestItems[(1 + (3 * index)) - 1].paymentdesc.text}", ttfFont, false) : buildCell("-", ttfFont, true),

                      //column 2
                      ghestCount > (2 + (3 * index)) - 1 ? buildCell("${2 + (3 * index)}", ttfFont, true) : buildCell("-", ttfFont, true),
                      ghestCount > (2 + (3 * index)) - 1 ? buildCell("${ghestItems[(2 + (3 * index)) - 1].date.text}", ttfFont, false) : buildCell("-", ttfFont, true),
                      ghestCount > (2 + (3 * index)) - 1 ? buildCell("${ghestItems[(2 + (3 * index)) - 1].price.text}", ttfFont, false) : buildCell("-", ttfFont, true),
                      ghestCount > (2 + (3 * index)) - 1 ? buildCell("${ghestItems[(2 + (3 * index)) - 1].paymentmethodValue}", ttfFont, false) : buildCell("-", ttfFont, true),
                      ghestCount > (2 + (3 * index)) - 1 ? buildCell("${ghestItems[(2 + (3 * index)) - 1].paymentdesc.text}", ttfFont, false) : buildCell("-", ttfFont, true),

                      //column 3

                      ghestCount > (3 + (3 * index)) - 1 ? buildCell("${3 + (3 * index)}", ttfFont, true) : buildCell("-", ttfFont, true),
                      ghestCount > (3 + (3 * index)) - 1 ? buildCell("${ghestItems[(3 + (3 * index)) - 1].date.text}", ttfFont, false) : buildCell("-", ttfFont, true),
                      ghestCount > (3 + (3 * index)) - 1 ? buildCell("${ghestItems[(3 + (3 * index)) - 1].price.text}", ttfFont, false) : buildCell("-", ttfFont, true),

                      ghestCount > (3 + (3 * index)) - 1 ? buildCell("${ghestItems[(3 + (3 * index)) - 1].paymentmethodValue}", ttfFont, false) : buildCell("-", ttfFont, true),
                      ghestCount > (3 + (3 * index)) - 1 ? buildCell("${ghestItems[(3 + (3 * index)) - 1].paymentdesc.text}", ttfFont, false) : buildCell("-", ttfFont, true),
                      // //column 4
                      // buildCell("${4 + (3 * index)}", ttfFont, width: 28),
                      // buildCell("${ghestItems[(4 + (3 * index)) - 1].date.text}", ttfFont),
                      // buildCell("${ghestItems[4 + (3 * index) - 1].price.text}", ttfFont),
                      // buildCell("${ghestItems[4 + (3 * index) - 1].paymentmethodValue}", ttfFont),
                      // buildCell("", ttfFont),

                      // //column 5
                      // buildCell("${5 + (3 * index)}", ttfFont),
                      // buildCell("${ghestItems[5 + (3 * index) - 1].date.text}", ttfFont),
                      // buildCell("${ghestItems[5 + (3 * index) - 1].price.text}", ttfFont),
                    ])),
              );
            },
            itemCount: (ghestItems.length / 3).ceil()),
        pw.SizedBox(height: 15),
        hagh
            ? pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Text(
                  "حق العمل کاری: ${hagholamalkarValue}   حق العمل کار:${hagholamalkarListValue}    محاسبه حق العمل: ${CalhagholamalkarValue}${CalhagholamalkarValue == "درصدی" ? " " + percentHagholamal.text + "%" : ""}    تعلق حق العمل به:${hagholamalToValue}    جمع مبلغ حق العمل:${sumHagholamal.text + "ريال"}   نحوه پرداخت: ${descHagholamal.text}",
                  style: pw.TextStyle(
                    fontSize: 7,
                    font: ttfFont,
                  ),
                  textDirection: pw.TextDirection.rtl,
                )
              ])
            : pw.SizedBox(),
        pw.SizedBox(height: 15),
        bandTcheck
            ? pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                pw.Text(
                  "بند ت: ${BandT}   محاسبه بند ت: ${CalBandTValue}}${CalBandTValue == "درصدی" ? " " + percentHBandT.text + "%" : ""}    تعلق بند ت به:${BandtTo}     شمول VAT در بند ت:${VATvalue}    جمع مبلغ بند ت:${sumBandT.text + "ريال"}   توضیحات بند ت: ${BandTController.text}",
                  style: pw.TextStyle(
                    fontSize: 7,
                    font: ttfFont,
                  ),
                  textDirection: pw.TextDirection.rtl,
                )
              ])
            : pw.SizedBox()
      ],
      footer: (context) => pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Row(children: [
          pw.Column(children: [
            pw.Container(
              child: pw.Text("کارشناس فروش:$sellerPersonelcode $SellerValue\nنام و امضا",
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                    fontSize: 7,
                    font: ttfFont,
                  )),
              width: 145.8,
              height: 50,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25)),
            ),
            pw.Container(
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Text("ورود:..../..../.......\nساعت: .... : .... ",
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        fontSize: 7,
                        font: ttfFont,
                      )),
                  pw.Text("خروج:..../..../.......\nساعت: .... : .... ",
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        fontSize: 7,
                        font: ttfFont,
                      )),
                ],
              ),
              width: 145.8,
              height: 30,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25)),
            ),
          ]),
          pw.Column(children: [
            pw.Container(
              child: pw.Column(children: [
                pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.only(top: 3, left: 1.5, right: 1.5),
                      child: pw.Container(height: 6, width: 6, decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.5)))),
                  pw.Text("آزاد بودن سازه ها مطابق جدول فوق تائید است.",
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        fontSize: 7,
                        font: ttfFont,
                      )),
                ]),
                pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.only(top: 3, left: 1.5, right: 1.5),
                      child: pw.Container(height: 6, width: 6, decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.5)))),
                  pw.Text("  کد و سایز سازه ها تائید است.\n کارشناس اجرایی \nنام و امضا",
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        fontSize: 7,
                        font: ttfFont,
                      )),
                ])
              ]),
              width: 145.8,
              height: 50,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25)),
            ),
            pw.Container(
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Text("ورود:..../..../.......\nساعت: .... : .... ",
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        fontSize: 7,
                        font: ttfFont,
                      )),
                  pw.Text("خروج:..../..../.......\nساعت: .... : .... ",
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        fontSize: 7,
                        font: ttfFont,
                      )),
                ],
              ),
              width: 145.8,
              height: 30,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25)),
            ),
          ]),
          pw.Column(children: [
            pw.Container(
              child: pw.Text("   مدیر فروش:$ManageSellerPersonelcode $ManageSellerValue\n   نام و امضا",
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                    fontSize: 7,
                    font: ttfFont,
                  )),
              width: 145.8,
              height: 50,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25)),
            ),
            pw.Container(
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Text("ورود:..../..../.......\nساعت: .... : .... ",
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        fontSize: 7,
                        font: ttfFont,
                      )),
                  pw.Text("خروج:..../..../.......\nساعت: .... : .... ",
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        fontSize: 7,
                        font: ttfFont,
                      )),
                ],
              ),
              width: 145.8,
              height: 30,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25)),
            ),
          ]),
          pw.Column(children: [
            pw.Container(
              child: pw.Column(children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Padding(
                        padding: pw.EdgeInsets.only(top: 3, left: 1.5, right: 1.5),
                        child: pw.Container(height: 6, width: 6, decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.5)))),
                    pw.Text("اعتبار صاحب امضا کنترل شد.",
                        textDirection: pw.TextDirection.rtl,
                        style: pw.TextStyle(
                          fontSize: 7,
                          font: ttfFont,
                        )),
                  ],
                ),
                pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.only(top: 3, left: 1.5, right: 1.5),
                      child: pw.Container(height: 6, width: 6, decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.5)))),
                  pw.Text("قرارداد تنظیم گردید.\nمسئول قراردادها\nنام و امضا",
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        fontSize: 7,
                        font: ttfFont,
                      )),
                ])
              ]),
              width: 145.8,
              height: 50,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25)),
            ),
            pw.Container(
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Text("ورود:..../..../.......\nساعت: .... : .... ",
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        fontSize: 7,
                        font: ttfFont,
                      )),
                  pw.Text("خروج:..../..../.......\nساعت: .... : .... ",
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        fontSize: 7,
                        font: ttfFont,
                      )),
                ],
              ),
              width: 145.8,
              height: 30,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25)),
            ),
          ]),
          pw.Column(children: [
            pw.Container(
              child: pw.Column(children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Padding(
                        padding: pw.EdgeInsets.only(top: 3, left: 1.5, right: 1.5),
                        child: pw.Container(height: 6, width: 6, decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.5)))),
                    pw.Text("فاکتورهای اجاره صادر گردید.",
                        textDirection: pw.TextDirection.rtl,
                        style: pw.TextStyle(
                          fontSize: 7,
                          font: ttfFont,
                        )),
                  ],
                ),
                pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.only(top: 3, left: 1.5, right: 1.5),
                      child: pw.Container(height: 6, width: 6, decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.5)))),
                  pw.Text("فاکتورهای اجرا صادر گردید.\nکارشناس مالی\nنام و امضا",
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        fontSize: 7,
                        font: ttfFont,
                      )),
                ])
              ]),
              width: 145.8,
              height: 50,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25)),
            ),
            pw.Container(
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Text("ورود:..../..../.......\nساعت: .... : .... ",
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        fontSize: 7,
                        font: ttfFont,
                      )),
                  pw.Text("خروج:..../..../.......\nساعت: .... : .... ",
                      textDirection: pw.TextDirection.rtl,
                      style: pw.TextStyle(
                        fontSize: 7,
                        font: ttfFont,
                      )),
                ],
              ),
              width: 145.8,
              height: 30,
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25)),
            ),
          ]),
        ]),
      ),
    ));

    final Uint8List bytes = await pdf.save();
    webFile.File(bytes, '${j.year}-${j.month}-${j.day}.pdf');

    Uint8List a = Uint8List.fromList(bytes);

    FileSaver.instance.saveFile(
      name: '${j.year}${j.month.toString().padLeft(2, '0')}${j.day} test.pdf',
      bytes: a,
      mimeType: MimeType.pdf,
    );
  }

// تابع کمکی برای ایجاد سلول‌های هدر
  pw.Widget createHeaderCell(String title, String value, pw.Font font, {double width = 100}) {
    return pw.Container(
        width: width,
        height: 20,
        padding: const pw.EdgeInsets.only(right: 5, top: 4),
        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25)),
        child: pw.Text("$title: $value",
            textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(
              fontSize: 6,
              font: font,
            )));
  }

  pw.Widget createHeaderCellCustomer(pw.Font font, {double width = 100}) {
    return pw.Container(
      width: width,
      height: 20,
      padding: const pw.EdgeInsets.only(right: 5, top: 4),
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25)),
      child: pw.Row(children: [
        pw.Text("نوع مشتری:",
            textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(
              fontSize: 6,
              font: font,
            )),
        pw.SizedBox(
          width: 5,
        ),
        pw.Row(children: [
          pw.Text("همکار",
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                fontSize: 6,
                font: font,
              )),
          pw.SizedBox(
            width: 3,
          ),
          pw.Container(width: 7, height: 7, decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.5)))
        ]),
        pw.SizedBox(width: 5),
        pw.Row(children: [
          pw.Text("مشتری",
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                fontSize: 6,
                font: font,
              )),
          pw.SizedBox(
            width: 3,
          ),
          pw.Container(width: 7, height: 7, decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.5)))
        ])
      ]),
    );
  }

  pw.Container buildCell(String text, pw.Font ttfFont, bool haveColor) {
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey, width: 0.25), color: haveColor ? PdfColors.blue50 : null),
      height: 15,
      width: 729 / 15,
      child: pw.Center(
        child: pw.Text(
          text,
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(font: ttfFont, fontSize: 6),
        ),
      ),
    );
  }

  String now() {
    return "${Jalali.now().year}/${Jalali.now().month}/${Jalali.now().day}   ${Jalali.now().hour}:${Jalali.now().minute}";
  }

  void calSecondRaminig() {
    setState(() {
      int sumPrice = 0;
      for (int index = 0; index < ghestCount; index++) {
        sumPrice = sumPrice + int.parse(ghestItems[index].price.text.replaceAll(",", ""));
      }
      secondremaining = firstremaining - sumPrice;
    });
  }
}
