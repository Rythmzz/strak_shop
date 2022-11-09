import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:strak_shop_project/services/auth.dart';
import 'package:strak_shop_project/services/colors.dart';
import 'package:strak_shop_project/services/database.dart';
import 'package:strak_shop_project/views/home_view.dart';
import 'package:strak_shop_project/views/register_view.dart';

import '../models/account.dart';

class LoginPage extends StatefulWidget{
  String? uid;
  LoginPage({required this.uid});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();
  bool _isLoading = false;
  bool _errorText = false;

  bool _checkAccountError = false;
  bool _checkPasswordError =false;
  bool _loadingPage = true;

  final TextEditingController _textEditingControllerAccount = TextEditingController();
  final TextEditingController _textEditingControllerPassword = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(Duration(seconds: 2));
      if(!mounted) return;
      if(widget.uid == null) {
        setState(() {
          _loadingPage = false;
        });
      }
    });

    super.initState();
  }

  String? validateAccount (String? input){
      if (input!.isEmpty){
        setState(() {
          _checkAccountError = true;
        });
        return ("Please enter your username or email");
      }
      setState(() {
        _checkAccountError = false;
      });
      return null;
  }
  String? validatePassword(String? input){
    if(input!.isEmpty){
      setState(() {
        _checkPasswordError = true;
      });
      return("Please enter your password.");
    }
    setState(() {
      _checkPasswordError = false;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: SafeArea(child:
      Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  titleTheme(),
                  inputForm(),
                  loginWithLinked(),
                  registerAccount()
                ],
              ),
            ),
          ),
         Visibility(
           visible: _isLoading ? true : false,
           child: Scaffold(
              backgroundColor: Colors.black26,
              body: Center(
                child: SpinKitChasingDots(
                  color: Theme.of(context).primaryColor,
                  size: 50,
                ),
              )
            ),
         ),
          Visibility(visible: _loadingPage == true ? true : false,
            child: Scaffold(
              body: Center(
                child: SpinKitThreeBounce(
                 color: Colors.blue,
                  size: 50,

                )
                ),
              ),
            ),

        ],

      )
      ),
    );
  }


  Column titleTheme() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          child: Image.asset("assets/images_app/logo_strak_red.png"),
        ),
        SizedBox(
          height: 16,
        ),
        Text("Welcome to Strak Shop",style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16
        ),),
        SizedBox(
          height: 8,
        ),
        Text("Sign in to continue",style: TextStyle(
            color: Colors.grey,
            fontSize: 12
        ),),
        SizedBox(
          height: 16,
        )

      ],
    );
  }
  @override
  void dispose() {
    _textEditingControllerAccount.dispose();
    _textEditingControllerPassword.dispose();
    super.dispose();
  }


  Widget inputForm(){
    return Form(key: _formKey,child:Column(
      children: [
        TextFormField(
          controller: _textEditingControllerAccount,
          validator: validateAccount,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: StrakColor.colorTheme6,width:3)
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width:3)
              )
              ,
              prefixIcon: Icon(Icons.email_outlined,size: 24,color: _checkAccountError ? Colors.red : null,),
              hintText: "Your Email",
          ),style: TextStyle(
            fontSize: 12
        ),
        ),
        SizedBox(height: 8,),
        TextFormField(
          controller: _textEditingControllerPassword,
          validator: validatePassword,
          obscureText: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: StrakColor.colorTheme6,width:3)
            ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width:3),
              ),
              prefixIcon: Icon(Icons.lock_outline,size: 24,color: _checkPasswordError ? Colors.red : null),
              hintText: "Password",
          ),
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(
          height: 8,
        ),
        Visibility(visible: _errorText ? true : false,child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("incorrect user or password",style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 14
          ),),
        )),
        SizedBox(width: double.infinity,child: ElevatedButton(onPressed: () async{
          if (_formKey.currentState!.validate()){
            setState(() {
              _isLoading = true;
            });
            dynamic result = await _auth.loginAccount(_textEditingControllerAccount.text, _textEditingControllerPassword.text);
            if(result == null){
              setState(() {
                _isLoading = false;
                _errorText = true;
              });
            }
            else {
              if(!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Success")));
            }

            // await _auth.loginWithAsynonmous();
          }
        }, child: Text("Sign In"),style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(StrakColor.colorTheme7)
        ))),
      SizedBox(
        height: 16,
      )
      ],

    ));
  }

  Column loginWithLinked(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 2,child: Divider(height: 10,color:Colors.grey,)),
            Flexible(flex: 1,
              child: Text("OR",style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold
              ),),
            ),
            Flexible(flex: 2,child: Divider(height: 10,color: Colors.grey,))
          ],),
        SizedBox(
          height: 8,
        ),
        InkWell(onTap: (){},
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(width:3,color: StrakColor.colorTheme6),
                borderRadius: BorderRadius.all(Radius.circular(4))
            ),
            child:Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset("assets/images_app/logo_gg.png"),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text("Login with Google",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),SizedBox(
          height: 16,
        ),
        InkWell(onTap: (){},
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(width:3,color: StrakColor.colorTheme6),
                borderRadius: BorderRadius.all(Radius.circular(4))
            ),
            child:Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset("assets/images_app/logo_fb.png"),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text("Login with Facebook",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 16,
        )
      ],
    );
  }

  Column registerAccount(){
    return Column(
      children: [
        InkWell(onTap: (){},
          child: Text("Forgot Password?",style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontSize: 12
          ),),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have a account?",style: TextStyle(
                color: Colors.grey,
                fontSize: 12
            ),),
            InkWell(onTap: () async {
              final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPage()));

              if(!mounted) return;

              setState(() {
                _loadingPage = result ?? false;
              });
            },
              child: Text("Register",style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),),
            )
          ],
        )
      ],
    );
  }
}


// Center(
// child: ElevatedButton(onPressed: () async {
// dynamic result = await _auth.loginWithAsynonmous();
// if(result != null){
// print("Login Success");
// print("User Id :${result.uid}");
// }
// else {
// print("Error Right Now");
// }
// }, child: Text("Login With Asynonmous"),),
// )