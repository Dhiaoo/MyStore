import 'package:flutter/material.dart';

import '../../DatabaseServices/database.dart';

class ReturnsPage extends StatefulWidget {
  const ReturnsPage({super.key});

  @override
  State<ReturnsPage> createState() => _ReturnsPageState();
}

class _ReturnsPageState extends State<ReturnsPage> {
  List data = [];
  double buypricesums = 0;
  double soldedsums = 0;

  getData()async{
    final dbHelper = await ProductsServices.instance;
    List<Map<String, dynamic>> allRows = await dbHelper.queryAllRows();
    setState(() {
      data =allRows;
    });

    for(int i=0; i<data.length; i++){
      buypricesums = buypricesums + (double.parse(data[i]["Buyprice"])*double.parse(data[i]["quantity"]));
      soldedsums = soldedsums + ((double.parse(data[i]["Sell_price"])-double.parse(data[i]["Buyprice"]))*double.parse(data[i]["soldedProducts"]));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height*0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text("Products Count : ${data.length}", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2,)),
          Center(child: Text("Capital  : ${buypricesums}", style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2,)),
          Center(child: Text("Total Returns : ${soldedsums}" , style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2, )),
        ],
      ),
    );
  }
}
