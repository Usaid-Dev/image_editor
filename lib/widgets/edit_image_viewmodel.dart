import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/models/text_info.dart';
import 'package:image_editor/screens/edit_image_screen.dart';
import 'package:image_editor/widgets/default_button.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import '../screens/home_screen.dart';
import '../utils/utils.dart';

abstract class EditImageViewModel extends State<EditImageScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  List<TextInfo> texts = [];
  int currentIndex = 0;

  saveToGallery(BuildContext context) {
    if (texts.isNotEmpty) {
      screenshotController.capture().then((Uint8List? image) {
        saveImage(image!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            content: Text(
              'Image Saved To Gallery',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 18,
              ),
            ),
          ),
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }).catchError((err) => print(err));
    }
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "screenshot_$time";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  removeText(BuildContext context) {
    setState(() {
      texts.removeAt(currentIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.blueGrey,
        content: Text(
          'Deleted',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  setCurrentIndex(BuildContext context, index) {
    setState(() {
      currentIndex = index;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.blueGrey,
        content: Text(
          'Selected For Styling',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  changeTextColor(Color color) {
    setState(() {
      texts[currentIndex].color = color;
    });
  }

  increaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize += 2;
    });
  }

  decreaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize -= 2;
    });
  }

  alignLeft() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.left;
    });
  }

  alignCenter() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.center;
    });
  }

  alignRight() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.right;
    });
  }

  boldText() {
    setState(() {
      if (texts[currentIndex].fontWeight == FontWeight.bold) {
        texts[currentIndex].fontWeight = FontWeight.normal;
      } else {
        texts[currentIndex].fontWeight = FontWeight.bold;
      }
    });
  }

  italicText() {
    setState(() {
      if (texts[currentIndex].fontStyle == FontStyle.italic) {
        texts[currentIndex].fontStyle = FontStyle.normal;
      } else {
        texts[currentIndex].fontStyle = FontStyle.italic;
      }
    });
  }

  addLinesToText() {
    setState(() {
      if (texts[currentIndex].text.contains('\n')) {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll('\n', '');
      } else {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll('', '\n');
      }
    });
  }

  addNewText(BuildContext context) {
    setState(() {
      texts.add(
        TextInfo(
          text: textEditingController.text,
          left: 200,
          top: 50,
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          fontSize: 20,
          textAlign: TextAlign.left,
        ),
      );
      Navigator.of(context).pop();
    });
  }

  addNewDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Add New Text',
        ),
        content: TextField(
          controller: textEditingController,
          decoration: const InputDecoration(
            suffixIcon: Icon(
              Icons.edit,
            ),
            filled: true,
            hintText: "Your Text Here..",
          ),
        ),
        actions: <Widget>[
          DefaultButton(
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.blueGrey,
            child: const Text("Back"),
          ),
          DefaultButton(
            onPressed: () => addNewText(context),
            color: Colors.blueGrey,
            child: const Text("Add Text"),
          ),
        ],
      ),
    );
  }
}
