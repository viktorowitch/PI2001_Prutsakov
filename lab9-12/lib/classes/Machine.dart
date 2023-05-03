import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../async/methods.dart';
import 'Coffee.dart';
import 'Resources.dart';
import 'package:lab9/screens/makeCoffeeScreen.dart';

class Machine {
  final res = Resources(0, 0, 0, 0);
  ICoffee? ctype;
  ICoffee cof(ICoffee) {
    return ctype = ICoffee;
  }

  bool isAvailableRes() {
    if (res.coffee >= ctype!.coffeBeans() &&
        res.water >= ctype!.water() &&
        res.cash >= ctype!.cash() &&
        res.milk >= ctype!.milk()) {
      return true;
    }
    return false;
  }

  Future subStractRes() async {
    int water;
    int milk;
    int cash;
    int beans;
    milk = res.milk - ctype!.milk();
    res.setMilk = milk;
    water = res.water - ctype!.water();
    res.setWater = water;
    cash = res.cash - ctype!.cash();
    res.setCash = cash;
    beans = res.coffee - ctype!.coffeBeans();
    res.setCoffee = beans;
    return;
  }

  bool makeCoffeeByType(String? type) {
    type = type!.toLowerCase();
    switch (type) {
      case 'Американо':
        cof(CoffeeAmericano());
        if (!isAvailableRes()) {
          return false;
        }
        subStractRes();
        break;
      case 'Каппучино':
        cof(CoffeeCappucino());
        if (!isAvailableRes()) {
          return false;
        }
        subStractRes();
        break;
      case 'Эспрессо':
        cof(CoffeeEspresso());
        if (!isAvailableRes()) {
          return false;
        }
        subStractRes();
        break;
    }
    return true;
  }
}
