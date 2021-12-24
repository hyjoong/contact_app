import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());  // start App
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  var tmp =1;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Text(tmp.toString()),
            onPressed: (){
              print(tmp);
              tmp++;
            },
          ),
          appBar:AppBar(),
          body:ListView.builder(
            itemCount:3,
            itemBuilder: (c,i){
              return ListTile(
                leading: Image.asset('hams.png'),
                title: Text('김이름'),
              );
            }
        )
      )
    );
  }
}


class ShopItem extends StatelessWidget {
  const ShopItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text('안녕'),
    );
  }
}
