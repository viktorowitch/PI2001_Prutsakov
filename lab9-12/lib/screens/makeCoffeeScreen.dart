import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab9/classes/Machine.dart';
import 'package:lab9/classes/Resources.dart';
import 'package:lab9/classes/Enums.dart';
import 'package:lab9/async/methods.dart';
import 'package:flutter/material.dart';

class MakeCoffeeScreen extends StatefulWidget {
  const MakeCoffeeScreen({super.key});

  @override
  State<MakeCoffeeScreen> createState() => _MakeCoffeeScreenState();
}

Machine machine = Machine();

class _MakeCoffeeScreenState extends State<MakeCoffeeScreen> {
  void popUp(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 700),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> message(
      String text, int duration) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(seconds: duration),
      ),
    );
  }

  CoffeeType? coffeeType = CoffeeType.Americano;
  final textController = TextEditingController();
  String? errorText;
  void _onChanged(String text) {
    setState(() {
      if (text == '' || text == '0') {
        errorText = 'Не забудьте положить деньги';
      } else {
        errorText = null;
      }
    });
  }

  void _onSubmitted(String text) {
    setState(() {
      if (text == '' || text == '0') {
        errorText = 'Не забудьте положить деньги';
      } else {
        errorText = null;
      }
    });
  }

  void _onPressed() {
    setState(() {
      if (textController.text == '' || textController.text == '0') {
        errorText = 'Не забудьте положить деньги';
      } else {
        errorText = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
              width: double.infinity,
              height: 300,
              child: Container(
                color: Colors.lime,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    children: [
                      rowWidget('Зерна: ${machine.res.coffee}'),
                      rowWidget('Молоко: ${machine.res.milk}'),
                      rowWidget('Вода: ${machine.res.water}'),
                      const SizedBox(
                        height: 10,
                      ),
                      windowWidget(220),
                    ],
                  ),
                ),
              )),
          radioPickerWidget(),
          const Divider(),
          const SizedBox(
            height: 20,
          ),
          textFieldWidget(),
        ],
      ),
    ]);
  }

  Stack radioPickerWidget() {
    return Stack(children: [
      SizedBox(
        height: 160,
        child: ListView(
          children: [
            listTileWidget('американо', CoffeeType.Americano),
            listTileWidget('каппучино', CoffeeType.Cappucino),
            listTileWidget('эспрессо', CoffeeType.Espresso),
          ],
        ),
      ),
      Positioned(
        right: 10,
        bottom: 0,
        child: CircleAvatar(
          radius: 24,
          child: IconButton(
              iconSize: 34,
              splashRadius: 30,
              padding: const EdgeInsets.all(0),
              onPressed: () async {
                var check = machine.makeCoffeeByType(coffeeType!.toNewString());
                if (!check) {
                  popUp('Недостаточно ресурсов');
                } else {
                  message('Греем воду', 3);
                  await waterHeating();
                  message('Вода горячая', 1);

                  message('Варим кофе', 5);
                  await coffeeMaking();
                  message('Кофе сварено', 1);

                  message('Добавляем молоко', 5);
                  await milkShaking();
                  message('Молоко добавлено', 1);

                  message('Последние штрихи', 3);
                  await gathering();
                  message('Кофе готов!', 3);
                }
              },
              icon: const Icon(Icons.play_arrow)),
        ),
      ),
    ]);
  }

  Row textFieldWidget() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: _onChanged,
              onSubmitted: _onSubmitted,
              onEditingComplete: _onPressed,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: textController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                errorText: errorText,
                hintText: 'Положите денежку',
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              machine.res.addCash(int.tryParse(textController.text)!);
              textController.text = '';
            });
          },
          icon: const Icon(Icons.money_rounded),
          iconSize: 30,
        ),
      ],
    );
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
                'Кофе-машина',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              'Доступно средств: ${machine.res.cash}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
    );
  }

  ListTile listTileWidget(String title, CoffeeType value) {
    return ListTile(
      title: Text(title),
      leading: Radio<CoffeeType>(
        groupValue: coffeeType,
        value: value,
        onChanged: (CoffeeType? value) {
          setState(() {
            coffeeType = value;
          });
        },
      ),
    );
  }

  Row rowWidget(String text) {
    return Row(
      children: [
        Text(text),
      ],
    );
  }
}
