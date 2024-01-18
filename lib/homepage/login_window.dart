import 'package:flutter/material.dart';
import 'package:thefinalproject/homepage/homepge.dart';
import 'package:thefinalproject/homepage/login_window.dart';
void main(){
  runApp(
      MaterialApp(
        home: loginform(),
      )
  );
}

class loginform extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyForm();
  }
}

class MyForm extends State<loginform>{
  final _valid1key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(
        title: const SizedBox(
            child: Text("Login"),
        ),
      ),

        body :
        Container(
          padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
          child: Form(
            key: _valid1key,
            child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(10.0),
              child: TextFormField(
                validator: (state) {  //error 9january
                  if(state!.length<3) {
                    return "State should be atleast three character";
                  }
                  return null;
                },

                decoration: InputDecoration(
                    labelText:"State",
                    hintText: "Enter your state",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)
                    )

                ),
              ),
              ),

              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  validator: (id) => id!.length<15? 'ID should be 15 digit' :null,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      labelText:"Consumer ID",
                      hintText: "Enter 15 digit consumer id",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)
                      )

                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,

                  decoration: InputDecoration(
                      labelText:"OTP",
                      hintText: "Enter OTP",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)
                      )
                  ),
                ),
              ),

            ],
            ),
          ),
        ),
      bottomNavigationBar:
      Container(
        height: 400,
        color: Colors.grey[400],
        width: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [ElevatedButton(
          style: ElevatedButton.styleFrom(
          primary: Colors.green,
            onPrimary: Colors.white,
            padding: EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed:(){
            _valid1key.currentState!.validate();
          }, child: Text('Submit') ),
            ],
          )
      ),



      );
    }
  }

