import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../resources/color.dart';

class wallet extends StatefulWidget {
  const wallet({super.key});

  @override
  State<wallet> createState() => _walletState();
}

class _walletState extends State<wallet> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: bluetext,
      appBar: AppBar(
        backgroundColor: bluetext,
        title: Text("Wallet",style: TextStyle(fontSize: 15,color: white),),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: white,width: .2),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Verify your Wallet",style: TextStyle(color: white),),

                    SvgPicture.asset(
                      "assets/svg/verify.svg",
                      height: 18,
                    ),
                  ],
                ),
              ),

            ),
          ),

          SizedBox(height: 20,),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 177,

              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [gradnew, gradnew1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  Text("Available balance",style:TextStyle(color: white,fontSize: 16,fontWeight: FontWeight.w300),),

                  SizedBox(height: 10,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/svg/verify.svg",
                        height: 40,
                      ),

                      SizedBox(width: 10,),

                      Text("21.3",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 36,color: white),)
                    ],
                  ),

                  SizedBox(height: 10,),


                  Container(
                    height: 36,
                    width: 130,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: white,
                          width: .2
                        ),
                        gradient: LinearGradient(
                          colors: [gradnew, gradnew1],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Sent Money",style: TextStyle(fontSize: 10,color: white),),
                        SizedBox(width: 10,),
                        SvgPicture.asset(
                          "assets/svg/arrow.svg",
                          height: 7,
                        ),

                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),

          SizedBox(height: 50,),



          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              // height: 330,
              width: 400,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [gradnew, gradnew1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),

              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Align(
                    alignment:Alignment.topLeft,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      child: Text("Market Value",style: TextStyle(color: white),),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                            child: Text("RBD",style: TextStyle(color: white),),
                          ),

                          Text("5.3",style: TextStyle(color: white,fontWeight: FontWeight.w900,fontSize: 25),),

                        ],
                      ),

                      SizedBox(width: 50,),

                      Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                            child: Text("IND",style: TextStyle(color: white),),
                          ),

                          Text("1000.3",style: TextStyle(color: white,fontWeight: FontWeight.w900,fontSize: 25),),

                        ],
                      ),


                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: white,thickness: .1,),
                  ),

                  SizedBox(height: 10,),
                  Align(
                    alignment:Alignment.topLeft,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      child: Text("Market Value",style: TextStyle(color: white),),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                            child: Text("Volume",style: TextStyle(color: white),),
                          ),

                          Text("100.05",style: TextStyle(color: white,fontWeight: FontWeight.w900,fontSize: 18),),

                        ],
                      ),



                      Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                            child: Text("High",style: TextStyle(color: white),),
                          ),

                          Text("1000.3",style: TextStyle(color: white,fontWeight: FontWeight.w900,fontSize: 18),),

                        ],
                      ),

                      Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                            child: Text("Low",style: TextStyle(color: white),),
                          ),

                          Text("88.05",style: TextStyle(color: white,fontWeight: FontWeight.w900,fontSize: 18),),

                        ],
                      ),




                    ],
                  ),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Align(
                      alignment:Alignment.topLeft,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Text("Price Change 24 hours",style: TextStyle(color: white),),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Text("RBD",style: TextStyle(color: white,fontWeight: FontWeight.w900),),

                                SizedBox(width: 10,),

                                Container(
                                  height: 18,
                                  width: 48,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: white,
                                          width: .2
                                      ),
                                      gradient: LinearGradient(
                                        colors: [gradnew, gradnew1],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  child: Center(child: Text("11.64",style: TextStyle(fontSize: 10,color: white),)),
                                 ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),

                  SizedBox(height: 20,),



                ],
              ),






            ),
          )



        ],
      ),

    );
  }
}
