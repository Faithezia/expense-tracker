import 'package:flutter/material.dart';

class TotalBudget extends StatelessWidget {
  const TotalBudget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.wallet_outlined),
          trailing: Text(
            "₱696969.69",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          title: Text(
            "Spending Wallet",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
