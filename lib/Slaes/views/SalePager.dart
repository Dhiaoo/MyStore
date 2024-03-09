import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../DatabaseServices/database.dart';

class SalePage extends StatefulWidget {
  const SalePage({super.key});

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  List data = [];
  List dataState = [];
  String categorieId = "";
  String sellprice = "";
  double quantety = 0;
  TextEditingController categorieIdController = TextEditingController();

  getData()async{
    final dbHelper = await ProductsServices.instance;
    List<Map<String, dynamic>> allRows = await dbHelper.queryAllRows();
    for(int i=0; i<allRows.length; i++)
      dataState.add(false);
    setState(() {
      data =allRows;
    });
  }

  searchData(String id)async{
    final dbHelper = await ProductsServices.instance;
    List<Map<String, dynamic>> fetchedData = await dbHelper.get(id);
    for(int i=0; i<fetchedData.length; i++)
      dataState.add(false);
    setState(() {
      data =fetchedData;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height*0.17,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: ()async{
                        if(categorieId==""){
                          getData();
                        }else{
                          await searchData(categorieId);
                        }
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.07,
                        width: MediaQuery.of(context).size.width*0.2,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.deepOrange
                        ),
                        child: Center(child: Text("Search", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),)),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.07,
                      width: MediaQuery.of(context).size.width*0.7,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.deepOrange, width: 1.5)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: ()async{
                                var result = await BarcodeScanner.scan();
                                setState(() {
                                  categorieId = result.rawContent;
                                  categorieIdController.text = result.rawContent;
                                });
                              },
                              child: Icon(Icons.camera_alt_outlined, color:  Colors.deepOrange,)),
                          Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: TextField(
                              textDirection: TextDirection.rtl,
                              controller: categorieIdController,
                              onChanged: (String val){
                                categorieId =  val;
                              },
                              decoration: InputDecoration(
                                hintText: "Product Id ",
                                border: InputBorder.none,
                                hintTextDirection: TextDirection.rtl,
                                isCollapsed: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 12),
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.8,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for(int i=0; i<data.length; i++)
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            dataState[i] = !dataState[i];
                          });
                          if(dataState[i]){
                            showDialog(
                                context: context,
                                builder: (BuildContext context)=>AlertDialog(
                                      content: Container(
                                        height: MediaQuery.of(context).size.height*0.5,
                                        width: MediaQuery.of(context).size.height,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          //{_id: 123456789, product_name: زيت محرك, Buyprice: 300.0, Sell_price: 500.0, quantity: 5.6}
                                          children: [
                                            Text("Product Name : ${data[i]["product_name"]}", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2,),
                                            Text("Product Id : ${data[i]["_id"]}", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2,),
                                            Text("Product Count : ${data[i]["quantity"]}" , style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2, ),
                                            Text("Buy Price : ${data[i]["Buyprice"]}", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2, ),
                                            Text("Sell Price : ${data[i]["Sell_price"]}", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2, ),
                                            Padding(
                                              padding:  EdgeInsets.symmetric(horizontal: 10.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Quantity  ", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold),),
                                                  Container(
                                                    height: MediaQuery.of(context).size.height*0.05,
                                                    width: MediaQuery.of(context).size.width*0.3,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(color: Colors.grey, width: 1)
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                      child: TextField(
                                                        textDirection: TextDirection.rtl,
                                                        keyboardType: TextInputType.number,
                                                        onChanged: (String val){
                                                          if(val!=""){
                                                            setState(() {
                                                              quantety =  double.parse(val);
                                                            });
                                                          }

                                                        },
                                                        decoration: InputDecoration(
                                                          hintText: "Product Count ",
                                                          border: InputBorder.none,
                                                          hintTextDirection: TextDirection.rtl,
                                                          isCollapsed: true,
                                                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                                                          hintStyle: TextStyle(color: Colors.grey),
                                                        ),
                                                      ),
                                                    ),),
                                                ],
                                              ),
                                            ),
                                            Center(
                                              child: Text( "Total : ${(double.parse(data[i]["Sell_price"])*quantety).toStringAsFixed(2)}", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2, ),
                                            ),
                                            GestureDetector(
                                              onTap: ()async{
                                                if(quantety<=double.parse(data[i]["quantity"]) && quantety>=0 ){
                                                  print(data[i]["soldedProducts"]);
                                                  final dbHelper = await ProductsServices.instance;
                                                  Map<String, dynamic> row = {
                                                    ProductsServices.columnId: data[i]["_id"],
                                                    ProductsServices.columnProductName: data[i]["product_name"],
                                                    ProductsServices.columnBuyPrice: data[i]["Buyprice"],
                                                    ProductsServices.columnSellPrice: data[i]["Sell_price"],
                                                    ProductsServices.columnQuantity: (double.parse(data[i]["quantity"])-quantety).toStringAsFixed(2).toString(),
                                                    ProductsServices.columnSolded: (double.parse(data[i]["soldedProducts"]==null?"0.0" : data[i]["soldedProducts"])+quantety).toStringAsFixed(2).toString(),
                                                  };

                                                  await dbHelper.update(row).then((value)async{
                                                    Get.back();
                                                    getData();
                                                  });

                                                }else{
                                                  setState(() {
                                                    quantety =  0;
                                                  });
                                                  Get.snackbar("Note", "The Quantity is not enought",
                                                      colorText: Colors.white,backgroundColor: Colors.deepOrange);
                                                }
                                              },
                                              child: Center(
                                                child: Container(
                                                  height: MediaQuery.of(context).size.height*0.05,
                                                  width: MediaQuery.of(context).size.width*0.3,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.deepOrange
                                                  ),

                                                  child: Center(
                                                      child: Text("Sell " ,
                                                        style: TextStyle( fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),)),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                )
                            ).then((value){
                              setState(() {
                                quantety =  0;
                                dataState[i] = !dataState[i];
                              });
                            });

                          }

                        },
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height*0.2,
                            width: MediaQuery.of(context).size.width*0.82,
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color:dataState[i]? Colors.deepOrange : Colors.grey, width: 1.5)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              //{_id: 123456789, product_name: زيت محرك, Buyprice: 300.0, Sell_price: 500.0, quantity: 5.6}
                              children: [
                                Text("Product Name : ${data[i]["product_name"]}", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2,),
                                Text("Product Id : ${data[i]["_id"]}", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2,),
                                Text("Product Count : ${data[i]["quantity"]}" , style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2, ),
                                Text("Buy Price : ${data[i]["Buyprice"]}", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2, ),
                                Text("Sell Price : ${data[i]["Sell_price"]}", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2, ),
                              ],
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
