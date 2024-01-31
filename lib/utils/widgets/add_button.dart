import 'package:flutter/material.dart';

const createButtonWidth = 38.0;
Widget get addVideoBtn => SizedBox(
      width: 45.0,
      height: 27.0,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10.0),
            width: createButtonWidth,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 250, 45, 108),
              borderRadius: BorderRadius.circular(7.0),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            width: createButtonWidth,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 32, 211, 234),
              borderRadius: BorderRadius.circular(7.0),
            ),
          ),
          Center(
            child: Container(
              height: double.infinity,
              width: createButtonWidth,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7.0)),
              child: const Icon(
                Icons.add,
                size: 20.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
