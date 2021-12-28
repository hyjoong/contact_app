import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(
      MaterialApp(
        theme: ThemeData(
          iconTheme: IconThemeData( // 모든 아이콘들 스타일
            color: Colors.blue
          ),
          appBarTheme: AppBarTheme(
            color:Colors.grey,
            actionsIconTheme: IconThemeData(color: Colors.blue)
          ),
          textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.red)
          )
        ), 
          home: MyApp()
      )
  );// start App
}

var a = TextStyle();

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data=[];

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

  getData()async{
    var res = await http.get(Uri.parse('url'));
    if(res.statusCode == 200){
      print("Data load success");
    } else{
      print("Data load fail");
    }
    var decodeRes = jsonDecode(res.body);
    setState(() {
      data = decodeRes;
    });
  }

  @override
  void initState() {  // initState 안에 적은 코드는 위젯 로드될 떄 한번 실행이 된다
    super.initState();
    getData();
  }

  var total =3;
  List<Contact> name = [];
  var like = [0,0,0];
  addOne(){
    setState((){
      total++;
    });
  }
//  C:\"Program Files"\Android\"Android Studio"\jre\bin\keytool -genkey -v -keystore C:\Users\khj\Desktop\flutter\flutter_keys\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload

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
      body: [Home(data:data),ContactHome(name:name)][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap:(i){
          setState(() {
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined),label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.phone_android_outlined),label: 'Phone')
      ],
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

class ContactHome extends StatelessWidget {
  ContactHome({Key? key, this.name}) : super(key: key);
  final name;

  @override 
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: name.length,
        itemBuilder: (c,i){
          return ListTile(
            leading: Image.asset('hams.png'),
            title: Text(name[i].givenName??'no Name'),
          );
        }
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key,this.data}) : super(key: key);
  final data;
  @override
  Widget build(BuildContext context) {
    print(data);
    if(data.isNotEmpty){
      return ListView.builder(itemCount:3,itemBuilder: (c,i){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(data[i]['image']),
            Container(
              constraints: BoxConstraints(maxWidth: 600),
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data[i]['date']),
                  Text(data[i]['user']),
                  Text(data[i]['content']),
                ],
              ),
            )
          ],
        );
      });
    }else{
      return Text("Loding...");
    }

  }
}

