import 'package:flutter/material.dart';
import '../mixins/validation.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> with Validation {

  final formKey = GlobalKey<FormState>(); //MEMBUAT GLOBAL KEY UNTUK VALIDASI 
  
  // DEFINE VARIABLE
  String name = '';
  String email = '';
  String password = '';


  Widget build(context) {
    return Container(
      margin: EdgeInsets.all(10.0), //SET MARGIN DARI CONTAINER 
      child: Form( 
         key: formKey, //MENGGUNAKAN GLOBAL KEY
        child: Column( 
          //CHILDREN DARI COLUMN BERISI 4 BUAH OBJECT YANG AKAN DI-RENDER, YAKNI
          // TextInput UNTUK NAME, EMAIL, PASSWORD DAN TOMBOL DAFTAR
          children: [
            OutlineButton(
              onPressed: chooseImage,
              child: Text('Choose Image'),
            ),
            SizedBox(
              height: 20.0,
            ),
            showImage(),
            SizedBox(
              height: 20.0,
            ),
            nameField(),
            SizedBox(height: 16.0),
            emailField(),
            SizedBox(height: 16.0),
            passwordField(),
            SizedBox(height: 16.0),
            registerButton(),
          ],
        )
      ),
    );
  }

  // START UPLOAD IMAGE
  
  static final String uploadEndPoint =
      'http://192.168.9.58/x/lab/api_upload_flutter/upload.php';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.camera);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);
  }

  upload(String fileName) {
    http.post(uploadEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((result) {
      setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      setStatus(error);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  // END UPLOAD

  Widget nameField() {
    //MEMBUAT TEXT INPUT 
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(16.0),
        labelText: 'Nama Lengkap' //DENGAN LABEL Nama Lengkap
      ),
      //AKAN BERISI VALIDATION
      validator: validateName, //validateName ADALAH NAMA FUNGSI PADA FILE validation.dart
      onSaved: (String value) { //KETIKA LOLOS VALIDASI
        name = value; //MAKA VARIABLE name AKAN DIISI DENGAN TEXT YANG TELAH DI-INPUT
      },
    );
  }

  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress, // KEYBOARD TYPENYA ADALAH EMAIL ADDRESS
      //AGAR SYMBOL @ DILETAKKAN DIDEPAN KETIKA KEYBOARD DI TAMPILKAN
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(16.0),
        labelText: 'Email',
        hintText: 'email@example.com',
      ),
      //AKAN BERISI VALIDATION
      validator: validateEmail, //BERLAKU SAMA DENGAN HELPERS SEBELUMNYA
      onSaved: (String value) {
        email = value;
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      obscureText: true, //KETIKA obsecureText bernilai TRUE
      //MAKA SAMA DENGAN TYPE PASSWORD PADA HTML
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(16.0),
        labelText: 'Password',
        hintText: 'Enter Password',
      ),
      //AKAN BERISI VALIDATION
      validator: validatePassword, //BERLAKU SAMA DENGAN HELPERS SEBELUMNYA
      onSaved: (String value) {
        password = value;
      },
    );
  }

  Widget registerButton() {
    //MEMBUAT TOMBOL
    return 
    SizedBox(
      width: double.infinity,
      child: RaisedButton(
        child: Text(
          'LOG IN',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'NanumGothic',
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Color(0xFF6C63FF),
        onPressed: () {
          // TODO: do something in here when button login pressed 

          //formKey ADALAH GLOBAL KEY, KEMUDIAN DIIKUTI DENGAN currentState
          //LALU METHOD validate(), NILAINYA ADALAH FALSE / TRUE
          if (formKey.currentState.validate()) { //JIKA TRUE
            formKey.currentState.save(); //MAKA FUNGSI SAVE() DIJALANKAN
            
            //DISINI KAMU BISA MENGHANDLE DATA YANG SDH DITAMPUNG PADA MASING-MASING VARIABLE
            //KAMU DAPAT MENGIRIMNYA KE API ATAU APAPUN
            //NAMUN UNTUK SEMENTARA KITA PRINT KE CONSOLE SAJA
            //KARENA BELUM MEMBAHAS TENTANG HTTP REQUEST
            print('Nama lengkap: $name');
            print('Email: $email');
            print('Passwor: $password');
          }

        }, //TEXT YANG AKAN DITAMPILKAN PADA TOMBOL
      ),
    );
    
  }
}