import 'package:flutter/material.dart';

void main() {
  runApp(
      MaterialApp(
          home: MyApp()
      )
  );// start App
}



class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var total =3;
  var name = ['기면증','김현증','기면중'];

  addOne(){
    setState((){
      total++;
    });
  }

  addName(a){
    setState(() {
      name.add(a);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              showDialog(context: context, builder: (context){
                return DialogUI(addOne:addOne, addName: addName);
              });
            },
          ),
          appBar:AppBar(title: Text(total.toString()),),
          body:ListView.builder(
            itemCount: name.length,
            itemBuilder: (c,i){
              return ListTile(
                leading: Image.asset('hams.png'),
                title: Text(name[i]),
              );
            }
        )
      );
  }
}

class DialogUI extends StatelessWidget {
  DialogUI({Key? key,this.addOne, this.addName}) : super(key: key);
  final addOne;
  final addName;
  var inputData = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        width: 300,
        height: 300,
        child: Column(
          children: [
            TextField(controller: inputData ,),
            TextButton(child: Text('완료'),onPressed: (){
              addOne();
              addName(inputData.text);
            }),
            TextButton(child: Text('취소'),onPressed: (){
              Navigator.pop(context);
            }),
          ],
        )
      )
    );
  }
}
