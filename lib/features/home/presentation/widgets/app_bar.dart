import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              // width: 266,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(39),
                border: Border.all(width: 1, color: Colors.black),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search Product',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            radius: 29,
            backgroundColor: Colors.white,
            child: Image.asset(
              'assets/avator/boy.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.person, color: Colors.grey,size: 50,);
              },
            ),
          ),
        ],
      ),
    );
  }
}
