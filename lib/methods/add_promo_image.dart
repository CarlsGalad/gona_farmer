import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelperPromo {
  ImageHelperPromo({
    ImagePicker? imagePicker,
    ImageCropper? imageCropper,
  })  : _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();

  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;
  bool _isImagePickerActive =
      false; // Add a flag to track the image picker status

  Future<List<XFile>> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 100,
    bool multiple = false,
  }) async {
    if (_isImagePickerActive) {
      throw Exception('Image picker is already active');
    }
    _isImagePickerActive =
        true; // Set the flag to true before starting the image picker
    try {
      if (multiple) {
        return await _imagePicker.pickMultiImage(imageQuality: imageQuality);
      }
      final file = await _imagePicker.pickImage(
          source: source, imageQuality: imageQuality);
      if (file != null) return [file];
      return [];
    } finally {
      _isImagePickerActive =
          false; // Reset the flag after the image picker is completed
    }
  }

  Future<CroppedFile?> crop({
    required XFile file,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async =>
      await _imageCropper.cropImage(
        sourcePath: file.path.toString(),
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            cropStyle: cropStyle,
            toolbarColor: Colors.green,
            toolbarTitle: 'Crop Image',
            statusBarColor: Colors.green.shade900,
            backgroundColor: Colors.white,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );

  Future<String?> uploadImageToFirebaseStorage(CroppedFile croppedImage) async {
    try {
      // Convert CroppedFile to File
      File croppedImageFile = File(croppedImage.path);
      // Generate a unique file name for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Get a reference to the Firebase Storage location
      Reference storageRef =
          FirebaseStorage.instance.ref().child('promo_images').child(fileName);

      // Upload the image file to Firebase Storage
      TaskSnapshot taskSnapshot = await storageRef.putFile(croppedImageFile);

      // Get the download URL of the uploaded image
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Return the download URL
      return downloadURL;
    } catch (error) {
      // Handle any errors that occur during the upload process
    
      return null;
    }
  }
}
