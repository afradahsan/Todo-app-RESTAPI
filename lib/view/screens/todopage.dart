import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app_restapi/view/screens/addtodo.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app_restapi/view/screens/edittodo.dart';
import 'package:todo_app_restapi/view/widgets/constants.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;

    return RefreshIndicator(
        onRefresh: fetchTodo,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 234, 234, 234),
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)), onPressed: () 
            {
              navigatetoadd();
            }, 
            backgroundColor: const Color.fromARGB(255, 0, 43, 130),
            child: const Icon(Icons.add, 
            color: Color.fromRGBO(226, 226, 226, 1)),),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: SafeArea(child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const Text("Your Todo List!", style: TextStyle(fontSize: 26,fontWeight: FontWeight.w500, color: Color.fromARGB(255, 0, 43, 130)),),
                  hdiv10,
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder: (context, index) {
                      return hdiv10;
                    },
                    itemBuilder: (context, index){
                      final item = items[index];
                      final id = item['_id'] as String;
                    return Container(
                      height: screenHeight/5.5,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),  
                        color: const Color.fromARGB(55, 0, 43, 130),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item['title'], style: const TextStyle(color: Color.fromARGB(255, 0, 43, 130), fontSize: 24, fontWeight: FontWeight.w500),),
                                 PopupMenuButton(
                                  iconSize: 15,
                                  itemBuilder: (context){
                                  return [
                                    PopupMenuItem(child: Text('Edit'),
                                    onTap: (){
                                      navigatetoedit(item, id);
                                    },),
                                    PopupMenuItem(child: Text('Delete'),
                                    onTap: (){
                                      showDialog(context: context, builder: (context){
                                        return  AlertDialog(title: Text('Are you sure you want to Delete?'), actions: [
                                          ElevatedButton(onPressed: (){
                                            deletebyId(id);
                                          }, child: Text('Yes')),
                                          ElevatedButton(onPressed: (){
                                            Navigator.of(context).pop();
                                          }, child: Text('No'))
                                        ],);
                                      });
                                    },)
                                  ];
                                 })
                              ],
                            ),
                            Text(item['description'], style: const TextStyle(color: Color.fromARGB(200, 0, 43, 130), fontSize: 14, fontWeight: FontWeight.w400),),
                          ],
                        ),
                      ),
                    );
                  })
                ],
              ),
            )),
          ),
        ),
    );
  }
  Future fetchTodo() async{
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);

    final response = await http.get(uri);

    print(response.statusCode);

    if(response.statusCode == 200){
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
          print(true);

      setState(() {
        items = result;
        print('items=result');
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> navigatetoadd()async{
    await Navigator.of(context).push(MaterialPageRoute(builder: (context){return const AddTodoPage();}));
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigatetoedit(dynamic item, String id)async{
    await Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return EditTodoPage(title: item['title'], description: item['description'],id: id);}));
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deletebyId(String id) async{
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if(response.statusCode == 200){
      Navigator.of(context).pop();
      final filtered = items.where((element) => element['_id']!=id).toList();
      setState(() {
        items = filtered;
      });
    }
    else{

    }
  }
}