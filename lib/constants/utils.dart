import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

// Bu işlev, context ve metin alır ve ekranda bir SnackBar gösterir.
// SnackBar, kısa bir bilgi veya uyarı mesajı göstermek için kullanılır.
void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

// Bu işlev, kullanıcının cihazından bir veya birden fazla resim seçmesini sağlar.
// FilePicker kullanarak resim dosyalarını seçer ve bir liste olarak döner.
Future<List<File>> pickImages() async {
  List<File> images = [];
  try {
    // FilePicker kullanarak resim dosyalarını seçer. allowMultiple: true, birden fazla dosya seçilmesine izin verir.
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    // Eğer dosyalar seçilmişse, seçilen dosyaları File nesnelerine dönüştürerek images listesine ekler.
    if (files != null && files.files.isNotEmpty) {
      for (int i = 0; i < files.files.length; i++) {
        images.add(File(files.files[i].path!));
      }
    }
  } catch (e) {
    // Eğer bir hata oluşursa, hata mesajını debug konsoluna yazdırır.
    debugPrint(e.toString());
  }
  // Seçilen resim dosyalarının listesini döner.
  return images;
}
