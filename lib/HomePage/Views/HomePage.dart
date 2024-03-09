import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../BuyingPages/views/BuyPage.dart';
import '../../RdeturnsPage/view/ReturnsPage.dart';
import '../../Slaes/views/SalePager.dart';
import '../../StorePages/views/StorePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.deepOrangeAccent.withOpacity(0.9),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(MediaQuery.of(context).size.width*0.2), bottomRight: Radius.circular(MediaQuery.of(context).size.width*0.2))
            ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Text("My Store ", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),)
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.7,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.08,),
                Padding(
                  padding:  EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        //Get.to(()=>BuyPage())
                        onTap: (){
                          Get.to(BuyPage());

                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.2,
                          width: MediaQuery.of(context).size.width*0.3,
                          decoration: BoxDecoration(
                              color: Colors.deepOrangeAccent.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Center(
                              child: Text("Buy", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),)
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Get.to(SalePage());
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.2,
                          width: MediaQuery.of(context).size.width*0.3,
                          decoration: BoxDecoration(
                              color: Colors.deepOrangeAccent.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Center(
                              child: Text("Sell", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.08,),
                Padding(
                  padding:  EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context)=>AlertDialog(
                                content: ReturnsPage(),
                              ));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.2,
                          width: MediaQuery.of(context).size.width*0.3,
                          decoration: BoxDecoration(
                              color: Colors.deepOrangeAccent.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Center(
                              child: Text("Returns", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),)
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Get.to(StorePAGE());
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.2,
                          width: MediaQuery.of(context).size.width*0.3,
                          decoration: BoxDecoration(
                              color: Colors.deepOrangeAccent.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Center(
                              child: Text("Products", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),)
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
