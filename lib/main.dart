import 'package:contact/notification.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c) => Store1()),
          ChangeNotifierProvider(create: (c) => Store2()),
        ],
        child: MaterialApp(
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
        ),
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
  var userImage;
  var userContent;

  saveData() async{
    var storage = await SharedPreferences.getInstance();
    var map = {"age":20};
    storage.setString('map',jsonEncode(map));
    var res = storage.getString('map')?? "Not exist";
    print(jsonDecode(res));
    // storage.setString('name',"john");
    // storage.setInt('bool',2);
    // storage.remove('name');
    // var res = storage.get('name');
  }


  addMyData(){
    print("addData..");
    var myData ={
      'id': data.length,
      'image': userImage,
      'likes': 5,
      'date': "July 5",
      'content': userContent,
      'liked': false,
      'user': "Hyjoong"
    };
    setState(() {
      data.add(myData);
    });
  }

  setUserContent(a){
    setState(() {
      print(a);
      userContent = a;
    });
  }

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
    var res = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
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
    initNotification(context);
    getData();
    saveData();
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
        floatingActionButton: FloatingActionButton(child: Text('+'),
          onPressed: (){
            showNotification();
          },
        // onPressed: (){
        //   showDialog(context: context, builder: (context){
        //     return DialogUI(addOne:addOne, addName: addName);
        //   });
        // },
      ),
      appBar:AppBar(
          title: Text(total.toString()),
          actions: [
            IconButton(
              icon: [Icon(Icons.add_box_outlined),Icon(Icons.contacts)][tab],
              onPressed: () async{
                var picker = ImagePicker();
                var image = await picker.pickImage(source: ImageSource.gallery);
                if(image!=null) { // 이미지를 골랐으면
                  setState(() {
                    userImage = File(image.path);
                  });
                }

                Navigator.push(context,
                  MaterialPageRoute(builder: (c) =>Upload(userImage:userImage, setUserContent: setUserContent, addMyData:addMyData))
                  );
                },
                iconSize:30,
            )
          ]
        ),
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

class Home extends StatefulWidget {
  const Home({Key? key,this.data}) : super(key: key);
  final data;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scroll = ScrollController();

  getMore() async{
    var res = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var decodeRes = jsonDecode(res.body);

  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if(scroll.position.pixels == scroll.position.maxScrollExtent){  // 유저가 맨 밑까지 스크롤 했는지 검사
        getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.data.isNotEmpty){
      return ListView.builder(itemCount:widget.data.length, controller: scroll, itemBuilder: (c,i){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.data[i]['image'].runtimeType ==String
                ?Image.network(widget.data[i]['image'])
                :Image.file(widget.data[i]['image']),
            Container(
              constraints: BoxConstraints(maxWidth: 600),
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Text(widget.data[i]['user']),
                    onTap: (){
                      Navigator.push(context,
                        // CupertinoPageRoute(builder: (c)=>Profile()),
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => Profile(),
                          transitionsBuilder: (c, a1, a2, child)=>
                              FadeTransition(opacity: a1,child: child)
                        )
                      );
                    },
                  ),
                  Text(widget.data[i]['date']),
                  Text('Like: ${widget.data[i]['likes']}'),
                  Text(widget.data[i]['content']),
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

class Upload extends StatelessWidget {
  const Upload({Key? key,this.userImage, this.setUserContent, this.addMyData}) : super(key: key);
  final userImage;
  final setUserContent;
  final addMyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( actions: [
        IconButton(onPressed: (){
          addMyData();
        },icon: Icon(Icons.send)),
      ],),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage),
          Text("Image Upload modal"),
          TextField(onChanged: (text){
            setUserContent(text);
          },),
          IconButton(
              onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.close)),
        ],
      )
    );
  }
}

class Store2 extends ChangeNotifier {
  var name = 'hyjoong kim';
}

class Store1 extends ChangeNotifier {
  var follower = 0;
  var friend = false;
  var profileImage =  [];

  getData() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);

    profileImage = result2;
    notifyListeners();
  }

  addFollower(){
    if(friend == false) {
      follower++;
      friend = true;
    } else{
      follower--;
      friend = false;
    }
    notifyListeners();
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<Store2>().name),),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
          ),
          Text('팔로워 ${context.watch<Store1>().follower}명'),
          ElevatedButton(onPressed: (){
            context.read<Store1>().addFollower();
          }, child: Text('팔로우')),
          ElevatedButton(onPressed: (){
            context.read<Store1>().getData();
          }, child: Text('사진가져오기'))
        ],
      ),
    );
  }
}


