
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:htp/User/UI/HomeScreen.dart';
import 'package:htp/User/Utils/Utils.dart';
import 'package:htp/User/Widgets/CRoundButton.dart';

class VerifyCode extends StatefulWidget {
  final verificationId;
  const VerifyCode({super.key, required this.verificationId});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  bool loading = false;
  // ignore: non_constant_identifier_names
  TextEditingController CodeController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('verify'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: CodeController,
              decoration: const InputDecoration(
                hintText: ' ^ disgits code',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            CRoundButton(
              loading: loading,
                buttonText: 'verify',
                onTap: () async{
                  setState(() {
                    loading = true;
                  });
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: CodeController.text.toString());
        
                      try{
        
                         await _auth.signInWithCredential(credential);
                         Navigator.push(context, MaterialPageRoute(builder: 
                         (context) => const Homescreen()));
                        
                      } 
                  
                      catch(e){
                         setState(() {
                    loading = false;
                  });
                        Utils().ToastMessage(e.toString());
        
                      }
                }
                
              
                )
          ],
        ),
      ),
    );
  }
}
