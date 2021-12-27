import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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

  getPermission() async {
    var status = await Permission.contacts.status;
    if(status.isGranted){
      print("allowed");
      var contacts = await ContactsService.getContacts();
      print(contacts);
      setState(() {
        name = contacts;
      });
      // var newPerson = Contact();
      // newPerson.givenName = '현증';
      // newPerson.familyName = '김';
      // ContactsService.addContact(newPerson);
    }
    else if(status.isDenied){
      print('rejected');
      Permission.contacts.request();  // 거절되어 있는 상태면 허락해달라고 팝업을 띄움
    }
  }

  @override
  void initState() {  // initState 안에 적은 코드는 위젯 로드될 떄 한번 실행이 된다
    super.initState();
  }

  var total =3;
  var name = [];
  var like =[0,0,0];

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
          appBar:AppBar(title: Text(total.toString()), actions: [
            IconButton(onPressed: (){ getPermission();}, icon: Icon(Icons.contacts))
          ],),
          body:ListView.builder(
            itemCount: name.length,
            itemBuilder: (c,i){
              return ListTile(
                leading: Image.asset('hams.png'),
                title: Text(name[i].givenName),
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
