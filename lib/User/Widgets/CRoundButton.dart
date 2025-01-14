import 'package:flutter/material.dart';

class CRoundButton extends StatelessWidget {
  const CRoundButton({super.key, required this.buttonText, required this.onTap , this.loading= false});

  final VoidCallback onTap;
  final String buttonText;
   final bool loading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 10), // changes position of shadow
              ),
            ],
            //border: Border.all(width: 0.1),
              // color: const Color(0xffB71540), //red color
                color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: loading? const CircularProgressIndicator(strokeWidth: 3, color: Colors.white,): Text(
            buttonText,
            style: const TextStyle(
              // color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18
            ),
          )),
        ),
      ),
    );
  }
}
