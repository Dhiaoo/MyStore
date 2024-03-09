
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../DatabaseServices/database.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({super.key});

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {

  String categorieName ="";
  TextEditingController categorieNameController = TextEditingController();
  String categorieId = "";
  TextEditingController categorieIdController = TextEditingController();
  double categorieCount = 0;
  TextEditingController categorieCountController = TextEditingController();
  double buyprice = 0;
  TextEditingController buypriceController = TextEditingController();
  double sellprice = 0;
  TextEditingController sellpriceController = TextEditingController();
  String barCode = "";
  bool isUploading = false;

  void buy()async{
    if(categorieName!=""){
      if(categorieId!=""){
        if(categorieCount!=0 && categorieCount>0){
          if(buyprice!=0 && buyprice>0){
            if(sellprice!=0 && sellprice>0 ){
              if(!isUploading){
                Get.dialog(Center(child: CircularProgressIndicator(color: Colors.deepOrange,),),);
                bool doesitalreadyExist = false;
                setState(() {
                  isUploading = true;
                });
                final dbHelper = await ProductsServices.instance;
                Map<String, dynamic> row = {
                  ProductsServices.columnId: categorieId,
                  ProductsServices.columnProductName: categorieName,
                  ProductsServices.columnBuyPrice: buyprice.toString(),
                  ProductsServices.columnSellPrice: sellprice.toString(),
                  ProductsServices.columnQuantity: categorieCount.toString(),
                  ProductsServices.columnSolded:"0"
                };
                List data = await dbHelper.get(categorieId);
               for(int i=0; i<data.length; i++){
                  if(data[i]["_id"]==categorieId && data[i]["product_name"]==categorieName &&
                      data[i]["Sell_price"]==sellprice.toString() && data[i]["Buyprice"]==buyprice.toString()){
                    setState(() {
                      doesitalreadyExist =true;
                    });
                    double count = double.parse(data[i]["quantity"]);
                    Map<String, dynamic> updatedrow = {
                      ProductsServices.columnId: categorieId,
                      ProductsServices.columnProductName: categorieName,
                      ProductsServices.columnBuyPrice: buyprice.toString(),
                      ProductsServices.columnSellPrice: sellprice.toString(),
                      ProductsServices.columnQuantity: (categorieCount + count).toString(),
                      ProductsServices.columnSolded:"0"
                    };

                    try{
                      await dbHelper.update(updatedrow).then((value){
                        setState(() {
                          categorieNameController.clear();
                          categorieIdController.clear();
                          categorieCountController.clear();
                          buypriceController.clear();
                          sellpriceController.clear();
                           isUploading = false;
                           Get.back();
                        });
                      });

                    }catch(e){
                      print(e);
                      setState(() {
                        Get.back();
                      });
                    }
                  }
                }
               if(!doesitalreadyExist){
                 try{
                   await dbHelper.insert(row).then((value){
                     setState(() {
                       categorieNameController.clear();
                       categorieIdController.clear();
                       categorieCountController.clear();
                       buypriceController.clear();
                       sellpriceController.clear();
                       isUploading = false;
                       Get.back();
                     });
                   });
                 }catch(e){
                   print(e);
                   setState(() {
                     Get.back();
                     isUploading = false;
                   });
                 }
               }
              }else{
                Get.snackbar("Note", "wait for moment",
                    colorText: Colors.white,backgroundColor: Colors.deepOrange);
              }
            }else{
              Get.snackbar("note", "Sell Price required",
                  colorText: Colors.white,backgroundColor: Colors.deepOrange);
            }
          }else{
            Get.snackbar("note", "Buy Price required",
                colorText: Colors.white,backgroundColor: Colors.deepOrange);
          }
        }else{
          Get.snackbar("note", "Product Count required",
              colorText: Colors.white,backgroundColor: Colors.deepOrange);
        }
      }else{
        Get.snackbar("note", "Product Id required",
            colorText: Colors.white,backgroundColor: Colors.deepOrange);
      }
    }else{
      Get.snackbar("note", "Product Name required",
          colorText: Colors.white,backgroundColor: Colors.deepOrange);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width*0.8,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height*0.06,),
                    Text("Product Name ", style: TextStyle( fontSize: 25, fontWeight: FontWeight.bold),),
                    SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.07,
                        width: MediaQuery.of(context).size.width*0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey, width: 3)
                        ),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextField(
                            textDirection: TextDirection.rtl,
                            controller: categorieNameController,
                            onChanged: (String val){
                              categorieName =  val;
                              print(val);
                            },
                            decoration: InputDecoration(
                              hintText: "Product Name ",
                              border: InputBorder.none,
                              hintTextDirection: TextDirection.rtl,
                              isCollapsed: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    Text("Product Id ", style: TextStyle( fontSize: 25, fontWeight: FontWeight.bold),),
                    SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.07,
                        width: MediaQuery.of(context).size.width*0.8,
                        padding:  EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey, width: 3)
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
                              padding:  EdgeInsets.symmetric(horizontal: 10.0),
                              width: MediaQuery.of(context).size.width*0.6,
                              child: TextField(
                                controller: categorieIdController,
                                textDirection: TextDirection.rtl,
                                onChanged: (String val){
                                  categorieId =  val;
                                  print(val);
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
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    Text("Product Count ", style: TextStyle( fontSize: 25, fontWeight: FontWeight.bold),),
                    SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.07,
                        width: MediaQuery.of(context).size.width*0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey, width: 3)
                        ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextField(
                              controller: categorieCountController,
                              textDirection: TextDirection.rtl,
                            keyboardType: TextInputType.number,
                            onChanged: (String val){
                              categorieCount =  double.parse(val);
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
                          ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    Text("Buy Price", style: TextStyle( fontSize: 25, fontWeight: FontWeight.bold),),
                    SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.07,
                        width: MediaQuery.of(context).size.width*0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey, width: 3)
                        ),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textDirection: TextDirection.rtl,
                            controller: buypriceController,
                            onChanged: (String val){
                              buyprice =  double.parse(val);
                              print(val);
                            },
                            decoration: InputDecoration(
                              hintText: "Buy Price",
                              border: InputBorder.none,
                              hintTextDirection: TextDirection.rtl,
                              isCollapsed: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                    Text("Sell Price", style: TextStyle( fontSize: 25, fontWeight: FontWeight.bold),),
                    SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.07,
                        width: MediaQuery.of(context).size.width*0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey, width: 3)
                        ),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextField(
                            textDirection: TextDirection.rtl,
                            keyboardType: TextInputType.number,
                            controller: sellpriceController,
                            onChanged: (String val){
                              sellprice =  double.parse(val);
                              print(val);
                            },
                            decoration: InputDecoration(
                              hintText: "Sell Price",
                              border: InputBorder.none,
                              hintTextDirection: TextDirection.rtl,
                              isCollapsed: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height*0.15,)
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height*0.07,
                child: GestureDetector(
                  onTap: (){
                    buy();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.07,
                    width: MediaQuery.of(context).size.width*0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.deepOrange
                    ),
                    child: Center(
                      child: Text(" Buy ", style: TextStyle( color: Colors.white,fontSize: 25, fontWeight: FontWeight.bold),),
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
