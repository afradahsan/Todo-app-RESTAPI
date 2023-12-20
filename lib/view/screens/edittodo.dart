import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditTodoPage extends StatefulWidget {
  String? title;
  String? description;
  String? id;

  EditTodoPage({required this.title,required this.description,required this.id, super.key});

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    TextEditingController titleController = TextEditingController(text: widget.title);
    TextEditingController descriptionController = TextEditingController(text: widget.description);

    Future onUpdate() async{
    final title = titleController.text.toString();
    final description = descriptionController.text.toString();

    final body = {
      'title': title,
      'description': description,
      'is_completed': false
    }; 

    final url = 'https://api.nstack.in/v1/todos/${widget.id}';
    final uri = Uri.parse(url);

    final response = await http.put(uri, body: jsonEncode(body),
    headers: {
      'Content-Type': 'application/json'
    });
    //Dont forget to add header as well, not necessary for all tho.
    //Whenever sending data we gotta encode it first.

    if(response.statusCode == 200){
      showSuccessMessage('Updated Successfully!');
      Navigator.of(context).pop();
    }
    else{
      showErrorMessage('Updation Failed, Please try again');
    }

    print(response.statusCode);
    print(response.body);
``
  }

    return Scaffold(
      body: SafeArea(child: 
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: const Color.fromARGB(255, 0, 43, 130),
              ),
              const Text(
                'Edit Todo',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color:  Color.fromARGB(255, 0, 43, 130),
                    fontSize: 20),
              ),
              ElevatedButton(
                onPressed: () {
                  onUpdate();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 0, 43, 130)),
                child: const Text(
                  'Update',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
              )
            ],
            ),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.fromLTRB(14,0,14,0),
            child: Form(child: 
              Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color:  Color.fromARGB(255, 0, 43, 130),),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 0, 43, 130))
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 0, 43, 130))
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    fillColor: const Color.fromARGB(255, 0, 43, 130),
                    focusColor: const Color.fromARGB(255, 0, 43, 130),
                    prefixIcon: const Icon(Icons.today_rounded, color: Color.fromARGB(255, 0, 43, 130),size: 20,),
                    labelText: 'Todo Title',
                    labelStyle: const TextStyle(fontFamily: 'Poppins', color: Color.fromARGB(255, 0, 43, 130)),
                    hintText: 'Input Text Here',
                    hintStyle: const TextStyle(color: Color.fromRGBO(2, 56, 138, 0.444))
                    ),
                  ),

                  const SizedBox(height: 10,),

                  TextFormField(
                    validator: (value) {
                      
                    },
                    controller: descriptionController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color.fromARGB(255, 0, 43, 130)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 0, 43, 130))
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 0, 43, 130))
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    fillColor: const Color.fromARGB(255, 0, 43, 130),
                    focusColor: const Color.fromARGB(255, 0, 43, 130),
                    prefixIcon: const Icon(Icons.today_rounded, color: Color.fromARGB(255, 0, 43, 130),size: 20,),
                    labelText: 'Todo Description',
                    labelStyle: const TextStyle(fontFamily: 'Poppins', color: Color.fromARGB(255, 0, 43, 130)),
                    hintText: 'Description',
                    hintStyle: const TextStyle(color: Color.fromRGBO(2, 56, 138, 0.444))
                    ),
                  ),
              ],
              ),
            ),
          ),
        ],
      )),
    );
  }
  
    void showSuccessMessage(String message){
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void showErrorMessage(String message){
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
}