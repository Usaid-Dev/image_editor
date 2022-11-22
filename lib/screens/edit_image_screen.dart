import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_editor/screens/home_screen.dart';
import 'package:image_editor/widgets/edit_image_viewmodel.dart';
import 'package:image_editor/widgets/image_text.dart';
import 'package:screenshot/screenshot.dart';

class EditImageScreen extends StatefulWidget {
  const EditImageScreen({super.key, required this.selectedImage});
  final String selectedImage;

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends EditImageViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: _bottombar,
      appBar: _appBar,
      body: Screenshot(
        controller: screenshotController,
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                _selectedImage,
                for (int i = 0; i < texts.length; i++)
                  Positioned(
                    left: texts[i].left,
                    top: texts[i].top,
                    child: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          currentIndex = i;
                          removeText(context);
                        });
                      },
                      onTap: () => setCurrentIndex(context, i),
                      child: Draggable(
                        feedback: ImageText(textInfo: texts[i]),
                        child: ImageText(textInfo: texts[i]),
                        onDragEnd: (drag) {
                          final renderBox =
                              context.findRenderObject() as RenderBox;
                          Offset off = renderBox.globalToLocal(drag.offset);
                          setState(() {
                            texts[i].top = off.dy - 96;
                            texts[i].left = off.dx;
                          });
                        },
                      ),
                    ),
                  ),
                creatorText.text.isNotEmpty
                    ? Positioned(
                        left: 0,
                        bottom: 0,
                        child: Text(
                          creatorText.text,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(
                                0.3,
                              )),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _selectedImage => Center(
        child: Image.file(
          File(
            widget.selectedImage,
          ),
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
      );

  AppBar get _appBar => AppBar(
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'EDIT YOUR IMAGE ',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 20),
        ),
      );

  BottomAppBar get _bottombar => BottomAppBar(
        child: SizedBox(
          height: 50,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                IconButton(
                  icon:
                      const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  tooltip: 'Back',
                ),
                IconButton(
                  icon: const Icon(Icons.save, color: Colors.black),
                  onPressed: () => saveToGallery(context),
                  tooltip: 'Save Image',
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  onPressed: () => addNewDialog(context),
                  tooltip: "Add New Text",
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.black),
                  onPressed: increaseFontSize,
                  tooltip: 'Increase Font Size',
                ),
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.black),
                  onPressed: decreaseFontSize,
                  tooltip: 'Decrease Font Size',
                ),
                IconButton(
                  icon:
                      const Icon(Icons.format_align_left, color: Colors.black),
                  onPressed: alignLeft,
                  tooltip: 'Align Left',
                ),
                IconButton(
                  icon: const Icon(Icons.format_align_center,
                      color: Colors.black),
                  onPressed: alignCenter,
                  tooltip: 'Align Center',
                ),
                IconButton(
                  icon:
                      const Icon(Icons.format_align_right, color: Colors.black),
                  onPressed: alignRight,
                  tooltip: 'Align Right',
                ),
                IconButton(
                  icon: const Icon(Icons.format_bold, color: Colors.black),
                  onPressed: boldText,
                  tooltip: 'Bold',
                ),
                IconButton(
                  icon: const Icon(Icons.format_italic, color: Colors.black),
                  onPressed: italicText,
                  tooltip: 'Italic',
                ),
                IconButton(
                  icon: const Icon(Icons.space_bar, color: Colors.black),
                  onPressed: addLinesToText,
                  tooltip: 'Add New Line',
                ),
                Tooltip(
                  message: "White",
                  child: GestureDetector(
                    onTap: () => changeTextColor(Colors.white),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Tooltip(
                  message: "Black",
                  child: GestureDetector(
                    onTap: () => changeTextColor(Colors.black),
                    child: const CircleAvatar(
                      backgroundColor: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Tooltip(
                  message: "Blue",
                  child: GestureDetector(
                    onTap: () => changeTextColor(Colors.blue),
                    child: const CircleAvatar(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Tooltip(
                  message: "Red",
                  child: GestureDetector(
                    onTap: () => changeTextColor(Colors.red),
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Tooltip(
                  message: "Yellow",
                  child: GestureDetector(
                    onTap: () => changeTextColor(Colors.yellow),
                    child: const CircleAvatar(
                      backgroundColor: Colors.yellow,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Tooltip(
                  message: "Green",
                  child: GestureDetector(
                    onTap: () => changeTextColor(Colors.green),
                    child: const CircleAvatar(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Tooltip(
                  message: "orange",
                  child: GestureDetector(
                    onTap: () => changeTextColor(Colors.orange),
                    child: const CircleAvatar(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Tooltip(
                  message: "Pink",
                  child: GestureDetector(
                    onTap: () => changeTextColor(Colors.pink),
                    child: const CircleAvatar(
                      backgroundColor: Colors.pink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
