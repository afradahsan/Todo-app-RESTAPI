import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
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
                'Add Todo',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color:  Color.fromARGB(255, 0, 43, 130),
                    fontSize: 20),
              ),
              ElevatedButton(
                onPressed: () {
                  onSave();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 0, 43, 130)),
                child: const Text(
                  'Save',
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
  Future onSave() async{
    final title = titleController.text.toString();
    final description = descriptionController.text.toString();

    final body = {
      'title': title,
      'description': description,
      'is_completed': false
    }; 
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);

    final response = await http.post(uri, body: jsonEncode(body),
    headers: {
      'Content-Type': 'application/json'
    });
    //Dont forget to add header as well, not necessary for all tho.
    //Whenever sending data we gotta encode it first.

    if(response.statusCode == 201){
      showSuccessMessage('Task Added Successfully!');
      titleController.text = '';
      descriptionController.text = '';
      Navigator.of(context).pop();
    }
    else{
      showErrorMessage('Task not saved, Please try again');
    }

    print(response.statusCode);
    print(response.body);

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