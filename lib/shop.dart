import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart ';

final firestore = FirebaseFirestore.instance;

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {

  getData() async{

    await firestore.collection('product').where().get();
        // .add({'name':'내복', 'price':5000});
        // .doc().delete(); // 삭제
        // update({}) // update



    try{
      var result =await firestore.collection('product').doc('ldTNsMJOPteFNOSHZLeo').get();
      for(var doc in result.docs){
        print(doc['name']);
      }
    } catch(e){
      print('에러');
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('샵페이지'),
    );
  }
}
