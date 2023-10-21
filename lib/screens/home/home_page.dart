import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:homework3/models/photo_item.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  String? _error;
  List<PhotoItem>? _itemList;

  void getPhotos() async {
    try {
      setState(() {
        _error = null;
      });

      // await Future.delayed(const Duration(seconds: 3), () {});

      final response =
      await _dio.get('https://jsonplaceholder.typicode.com/albums');
      debugPrint(response.data.toString());
      // parse
      List list = jsonDecode(response.data.toString());
      setState(() {
        _itemList = list.map((item) => PhotoItem.fromJson(item)).toList();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      debugPrint('เกิดข้อผิดพลาด: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    getPhotos();
  }
  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_error != null) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error!),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              getPhotos();
            },
            child: const Text('RETRY'),
          )
        ],
      );
    } else if (_itemList == null) {
      body = const Center(child: CircularProgressIndicator());
    }
    else{
      body = ListView.builder(
          itemCount: _itemList!.length,
          itemBuilder: (context, index) {
            var todoItem = _itemList![index];
            return Card(
                child: Padding(
                    padding: const EdgeInsets.only(left: 10.0,bottom: 2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todoItem.title),
                        Row(
                          children: [
                            Card(
                              color: Colors.pink[100],
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 6.0),
                                child: Text("Album ID:${todoItem.id}",
                                  style:TextStyle(
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              color: Colors.lightBlue[100],
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 6.0),
                                child: Text("User ID: ${todoItem.userId}",
                                  style:TextStyle(
                                    fontSize: 10.0
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                ),
            );
          });
    }
    return Scaffold(body: body,appBar: AppBar(title: Text('Photo Albums'),
      centerTitle: true,
    ),
    );
  }
}
//Text("Album ID:${todoItem.id}"),
//Text("User ID: ${todoItem.userId}"),