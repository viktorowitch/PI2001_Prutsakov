import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab9/classes/Machine.dart';
import 'package:lab9/classes/Resources.dart';
import 'package:lab9/screens/makeCoffeeScreen.dart';

class AddResourceScreen extends StatefulWidget {
  const AddResourceScreen({super.key});

  @override
  State<AddResourceScreen> createState() => _AddResourceScreenState();
}

class _AddResourceScreenState extends State<AddResourceScreen> {
  final textControllerMilk = TextEditingController();
  final textControllerWater = TextEditingController();
  final textControllerBeans = TextEditingController();
  final textControllerCash = TextEditingController();
  String? errorText;

  void _onChanged(String text) {
    setState(() {
      if (text == '') {
        errorText = 'Введите значение';
      } else {
        errorText = null;
      }
    });
  }

  void _onSubmitted(String text) {
    setState(() {
      if (text == '') {
        errorText = 'Введите значение';
      } else {
        errorText = null;
      }
    });
  }

  void _onPressed() {
    setState(() {
      if (textControllerMilk.text == '') {
        errorText = 'Введите значение';
      } else {
        errorText = null;
      }
    });
  }

  void addResources() {
    setState(() {
      int cash;
      int milk;
      int water;
      int beans;
      cash = int.tryParse(textControllerCash.text) ?? 0;
      milk = int.tryParse(textControllerMilk.text) ?? 0;
      water = int.tryParse(textControllerWater.text) ?? 0;
      beans = int.tryParse(textControllerBeans.text) ?? 0;
      machine.res.addCash(cash);
      machine.res.addCoffee(beans);
      machine.res.addWater(water);
      machine.res.addMilk(milk);
      textControllerMilk.text = '';
      textControllerWater.text = '';
      textControllerBeans.text = '';
      textControllerCash.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Container(
                color: Colors.lime,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Column(
                      children: [
                        windowWidget(250),
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            textFieldWidget('молоко', textControllerMilk),
            textFieldWidget('вода', textControllerWater),
            textFieldWidget('зерна', textControllerBeans),
            textFieldWidget('деньги', textControllerCash),
            CircleAvatar(
                radius: 24,
                child: IconButton(
                  onPressed: addResources,
                  icon: const Icon(Icons.add),
                  iconSize: 30,
                  splashRadius: 30,
                  padding: const EdgeInsets.all(0),
                ))
          ],
        )
      ],
    );
  }

  Row textFieldWidget(String text, TextEditingController textController) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: textController,
              onChanged: _onChanged,
              onSubmitted: _onSubmitted,
              onEditingComplete: _onPressed,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                errorText: errorText,
                hintText: 'Положите $text здесь',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

SizedBox windowWidget(double height) {
  return SizedBox(
    width: double.infinity,
    height: height,
    child: Container(
      color: Colors.white54,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 30),
            child: Text(
              'Ресурсы',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
          ),
          resourceWidget('Молоко: ${machine.res.milk}'),
          resourceWidget('Вода: ${machine.res.water}'),
          resourceWidget('Зерна: ${machine.res.coffee}'),
          resourceWidget('Деньги: ${machine.res.cash}'),
        ],
      ),
    ),
  );
}

Padding resourceWidget(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Align(
      alignment: Alignment.bottomLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      ),
    ),
  );
}
