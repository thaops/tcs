import 'package:flutter/material.dart';

class QrBank extends StatelessWidget {
  final String accountNumber;
  const QrBank({super.key, required this.accountNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Bank"),
      ),
      body:  Center(
          child: Image(
        fit: BoxFit.cover,
        image: NetworkImage(
            "https://img.vietqr.io/image/970423-${accountNumber}-compact.png"),
      )),
    );
  }
}
