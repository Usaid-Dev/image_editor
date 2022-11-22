import 'package:flutter/material.dart';
import 'package:image_editor/screens/edit_image_screen.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
          title: const Text(
            'PRESS THE ICON FOR ADDING IMAGE',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 18),
          )),
      body: Center(
        child: IconButton(
          icon: const Icon(
            Icons.add_a_photo,
            size: 50,
            color: Colors.white,
          ),
          onPressed: () async {
            XFile? file = await ImagePicker().pickImage(
              source: ImageSource.gallery,
            );
            if (file != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditImageScreen(
                    selectedImage: file.path,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
