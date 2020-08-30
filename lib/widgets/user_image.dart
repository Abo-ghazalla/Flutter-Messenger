import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImage extends StatefulWidget {
  final void Function(File image) _imagePickerFunction;

  UserImage(this._imagePickerFunction);

  @override
  _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File _image;

  Future<void> _getImageFromUser(ImageSource source) async {
    final pickedImage = await ImagePicker().getImage(
      source: source,
      maxWidth: 400,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _image = File(pickedImage.path);
    });
    widget._imagePickerFunction(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundImage: _image == null ? null : FileImage(_image),
          backgroundColor: _image == null ? Colors.grey : null,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              FlatButton.icon(
                onPressed: () => _getImageFromUser(ImageSource.camera),
                icon: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).accentColor,
                ),
                label: const Text("Take Photo"),
                textColor: Theme.of(context).accentColor,
              ),
              FlatButton.icon(
                onPressed: () => _getImageFromUser(ImageSource.gallery),
                icon: Icon(
                  Icons.image,
                  color: Theme.of(context).accentColor,
                ),
                label: const Text("From Device"),
                textColor: Theme.of(context).accentColor,
              ),
            ],
          ),
        )
      ],
    );
  }
}
