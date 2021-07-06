import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

enum ImageOrigin { camera, gallery }

class ImageInput extends StatefulWidget {
  final File oldImage;
  final Function onSelectImage;

  ImageInput(this.oldImage, this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  @override
  void initState() {
    super.initState();
    setState(() {
      _storedImage = widget.oldImage;
    });
  }

  _takePicture(ImageOrigin imageOrigin) async {
    final ImagePicker _picker = ImagePicker();
    PickedFile imageFile;
    if (imageOrigin == ImageOrigin.camera) {
      imageFile = await _picker.getImage(
        source: ImageSource.camera,
        maxWidth: 600,
      );
    } else {
      imageFile = await _picker.getImage(
        source: ImageSource.gallery,
        maxWidth: 600,
      );
    }

    if (imageFile == null) return;

    setState(() {
      _storedImage = File(imageFile.path);
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    String fileName = path.basename(_storedImage.path);
    final savedImage = await _storedImage.copy(
      '${appDir.path}/$fileName',
    );
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 135,
          height: 180,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Text('Nenhuma imagem!'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              TextButton.icon(
                icon: Icon(Icons.photo_camera),
                label: Text('Tirar Foto'),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor)),
                onPressed: () {
                  _takePicture(ImageOrigin.camera);
                },
              ),
              TextButton.icon(
                icon: Icon(Icons.photo_library),
                label: Text('Escolher Foto'),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor)),
                onPressed: () {
                  _takePicture(ImageOrigin.gallery);
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
