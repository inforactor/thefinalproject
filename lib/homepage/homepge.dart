import 'package:flutter/material.dart';
import 'package:thefinalproject/homepage/homepge.dart';
import 'package:thefinalproject/homepage/login_window.dart';
void main(){
  runApp(HomeScreen());
}

class HomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("BillSpark"),
            centerTitle:true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                '/home/gunjan/Documents/figma/bolt-solid.svg', // Replace with the path to your logo image
                width: 32, // Adjust the width as needed
                height: 24, // Adjust the height as needed
              ),
            ),
          ),
          body: Material(
            child: Container(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          padding: EdgeInsets.all(20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                          onPressed:(){
                            print("Bill Paid");
                          }, child: Text('View Bill')),


                      ElevatedButton(

                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                            padding: EdgeInsets.all(20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed:(){
                            Navigator.push(context, MaterialPageRoute(builder:(BuildContext context) {
                              return loginform();
                            },),);
                          }, child: Text('Pay Bill') ),
                    ]

                  ),

                  Row(

                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              onPrimary: Colors.white,
                              padding: EdgeInsets.all(20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed:(){
                              print("Hellow World");
                            }, child: Text('Apply for new connection') ),

                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              onPrimary: Colors.white,
                              padding: EdgeInsets.all(20.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed:(){
                              print("Hellow World");
                            }, child: Text('Helpline') ),
                      ]

                  ),

                ]
              ),


            ),
          ),
          bottomNavigationBar: Container(
            height: 222,
            color: Colors.green,
          ),

        )
    );
  }

}