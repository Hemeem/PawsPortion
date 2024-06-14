import 'package:flutter/material.dart';

class ManualFeedButton extends StatelessWidget {
  const ManualFeedButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Tambahkan aksi manual feed di sini
        },
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Color(0xFFFADABC)),
        ),
        child: Text(
          'MANUAL FEED',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
