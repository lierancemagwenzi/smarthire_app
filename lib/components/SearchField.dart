import 'package:flutter/material.dart';

SeachField() {
  return new TextField(
    decoration: new InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        filled: true,
        hintStyle: new TextStyle(color: Colors.grey[800]),
        hintText: "Search for products",
        fillColor: Colors.white70),
  );
}
