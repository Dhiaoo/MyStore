import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../DatabaseServices/database.dart';

class StorePAGE extends StatefulWidget {
  const StorePAGE({super.key});

  @override
  State<StorePAGE> createState() => _StorePAGEState();
}

class _StorePAGEState extends State<StorePAGE> {

  List data = [];
  String filterValue = "";

  getData()async{
    final dbHelper = await ProductsServices.instance;
    List<Map<String, dynamic>> allRows = await dbHelper.queryAllRows();
    print(allRows);
    setState(() {
      data =allRows;
    });
  }

  getTheNewest(){
    setState(() {
      data = List.from(data.reversed);
    });
  }

  sorttheLow()async{
    final dbHelper = await ProductsServices.instance;
    List<Map<String, dynamic>> allRows = await dbHelper.getDataSortedByQuantityDescending();
    print(allRows);
    setState(() {
      data =allRows;
    });
  }

  sortthehigh()async{
    final dbHelper = await ProductsServices.instance;
    List<Map<String, dynamic>> allRows = await dbHelper.getDataSortedByQuantityAsc();
    print(allRows);
    setState(() {
      data =allRows;
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.08,),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height*0.07,
                width: MediaQuery.of(context).size.width*0.8,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.deepOrange, width: 1.5)
                ),
                child: DropdownButton<String>(
                    value: filterValue,
                    elevation: 0,
                    underline: Container(),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(20),
                    items:  [
                      DropdownMenuItem(
                        child: Text('Random ', ),
                        value: '',
                      ),
                      DropdownMenuItem(
                        child: Text('New', ),
                        value: 'new',
                      ),
                      DropdownMenuItem(
                        child: Text('the low in stock ', ),
                        value: 'low',
                      ),
                      DropdownMenuItem(
                        child: Text('The high in stock  ', ),
                        value: 'high',
                      ),

                    ],
                    onChanged: (String? newVal)async{

                      setState(() {
                        filterValue = newVal!;
                      });

                      if(filterValue==""){
                         getData();
                      }else if(filterValue=="new"){
                         getTheNewest();
                      }else if(filterValue=="low"){
                         sorttheLow();

                      }else if(filterValue=="high"){
                         sortthehigh();
                      }
                      setState(() {

                      });

                    }),
              ),
            ),
            for(int i=0; i<data.length; i++)
              Center(
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.2,
                      width: MediaQuery.of(context).size.width*0.82,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.deepOrange, width: 1.5)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        //{_id: 123456789, product_name: زيت محرك, Buyprice: 300.0, Sell_price: 500.0, quantity: 5.6}
                        children: [
                          Text("Product Name : ${data[i]["product_name"]}", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2,),
                          Text("Product Id : ${data[i]["_id"]}", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2,),
                          Text("Product Count : ${data[i]["quantity"]}" , style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold, color: double.parse(data[i]["quantity"])<=10 ?Colors.red :null), maxLines: 2, ),
                          Text("Buy Price : ${data[i]["Buyprice"]}", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2, ),
                          Text("Sell Price : ${data[i]["Sell_price"]}", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2, ),
                          Text("Sell Count  : ${data[i]["soldedProducts"]}", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2, ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 15,
                        left: 10,
                        child: GestureDetector(
                          onTap: (){
                            showDialog(
                                context: context,
                                builder:
                                    (BuildContext context)=>AlertDialog(
                                      content: Container(
                                        height: MediaQuery.of(context).size.height*0.2,
                                        child: Column(
                                          children: [
                                            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                            Center(
                                              child: Text("Are you sure to delet the product ", style: TextStyle( fontSize: 25, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                                            ),
                                            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: (){
                                                    Get.back();
                                                  },
                                                  child: Container(
                                                    height: MediaQuery.of(context).size.height*0.05,
                                                    width: MediaQuery.of(context).size.width*0.3,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.deepOrange
                                                    ),
                                                    child: Center(child: Text("Cancel", style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),)),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: ()async{
                                                    final dbHelper = await ProductsServices.instance;
                                                    await dbHelper.remove(data[i]).then((value){
                                                      Get.back();
                                                      getData();
                                                    });
                                                  },
                                                  child: Container(
                                                    height: MediaQuery.of(context).size.height*0.05,
                                                    width: MediaQuery.of(context).size.width*0.3,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: Colors.deepOrange
                                                    ),
                                                    child: Center(
                                                        child: Text("Delete", style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),)),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                            );
                          },
                            child: Icon(Icons.remove_circle_outline, color: Colors.grey,)))
                  ],
                ),
              )

          ],
        ),
      ),
    );
  }
}
