import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

class Utils {
  void ToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.grey.withOpacity(0.1),
        textColor: Colors.black,
        fontSize: 16.0);
        
  }
  ListView ShimmerEffect() {
    return ListView.builder(
      itemCount: 5, // Display 5 shimmer placeholders
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(210, 224, 224, 224),
            highlightColor: const Color.fromARGB(190, 245, 245, 245),
            child: Container(
              height: 80.0,
              decoration: BoxDecoration(
                color: const Color.fromARGB(195, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }
}
