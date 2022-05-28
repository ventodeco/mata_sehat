import 'dart:io';

import 'package:image_class/models/doctor.dart';
import 'package:image_class/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_class/widget/doctor_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class DetectionPage extends StatefulWidget {
  @override
  _DetectionPage createState() => _DetectionPage();
}

class _DetectionPage extends State<DetectionPage> {
  late File pickedImage;
  bool isImageLoaded = false;

  late List _result;

  String _confidence = "";
  String _name = "";
  String _newName = "";
  String _information = "";
  String _causes = "";
  String _healing = "";

  String numbers = "";

  getImageFromGallery() async {
    final tempStore = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = File(tempStore!.path);
      isImageLoaded = true;
      applyModelOnImage(pickedImage);
    });
  }

  loadMyModel() async {
    // print("masuk load");
    var result = await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );

    // print("Result : $result");
  }

  applyModelOnImage(File file) async {
    var res = await Tflite.runModelOnImage(
      path: file.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    // print("apply nih");
    print(res);

    setState(() {
      _result = res!;

      String str = _result[0]["label"];

      _name = str.substring(2);
      _confidence = _result != null
          ? (_result[0]["confidence"] * 100.0).toString().substring(0, 2) + "%"
          : "";
      Map<String, String> mapInformation = {
        'glaucoma':
            'Glaukoma adalah kerusakan pada saraf mata akibat tingginya tekanan di dalam bola mata. Kondisi ini ditandai dengan nyeri di mata, mata merah, penglihatan kabur, serta mual dan muntah. Glaukoma perlu segera ditangani untuk mencegah terjadinya kebutaan.',
        'normal':
            'Mata normal adalah mata yang memiliki pandangan jelas, bersih, dan tidak mengalami gejala penyakit tertentu. Ciri-ciri mata normal, antara lain mata bebas dari rasa sakit dan sklera berwarna putih.',
        'pathological_myopia':
            'Miopi adalah gangguan pada penglihatan yang menyebabkan objek yang letaknya jauh terlihat kabur, tetapi tidak ada masalah melihat objek yang letaknya dekat. Miopi atau rabun jauh dikenal juga dengan istilah mata minus.',
        'cataract':
            'Katarak adalah suatu penyakit ketika lensa mata menjadi keruh dan berawan. Pada umumnya, katarak berkembang perlahan dan awalnya tidak terasa mengganggu. Namun, lama-kelamaan, katarak akan mengganggu penglihatan dan membuat pengidap merasa seperti melihat jendela berkabut, sulit menyetir, membaca, serta melakukan aktivitas sehari-hari. Penyakit mata ini merupakan penyebab kebutaan utama di dunia yang dapat diobati.',
      };

      Map<String, String> mapCauses = {
        'glaucoma':
            'Gejala glaukoma tergantung pada jenisnya. Gejala umum pada penderita glaukoma sudut terbuka adalah penglihatan kabur. Sedangkan gejala yang sering terjadi pada glaukoma sudut tertutup adalah sakit kepala berat, nyeri di mata, dan mata merah.',
        'normal': '-',
        'pathological_myopia':
            'Miopi atau rabun jauh terjadi ketika cahaya yang masuk ke mata tidak jatuh pada tempat yang semestinya, yaitu retina. Kondisi ini disebabkan oleh bentuk bola mata yang lebih panjang dari bola mata normal. Miopi juga bisa terjadi ketika kornea dan lensa mata, yang berfungsi untuk memfokuskan cahaya pada retina, mengalami kelainan.',
        'cataract':
            'Penyebab katarak yang paling umum ditemui adalah akibat proses penuaan atau trauma yang menyebabkan perubahan pada jaringan mata. Lensa mata sebagian besar terdiri dari air dan protein. Dengan bertambahnya usia, lensa menjadi semakin tebal dan tidak fleksibel.\nBeberapa kelainan genetik bawaan juga bisa menyebabkan masalah kesehatan lain yang bisa meningkatkan risiko katarak. Selain itu, katarak juga bisa disebabkan oleh kondisi mata lain, operasi mata sebelumnya, atau kondisi medis seperti diabetes. Penggunaan obat steroid jangka panjang juga bisa menyebabkan penyakit mata tersebut berkembang.',
      };

      Map<String, String> mapHealing = {
        'glaucoma':
            'Pemeriksaan dan penanganan mata rutin dapat menghindari risiko kebutaan pada penderita glaukoma. Metode pengobatannya tergantung kondisi pasien dan tingkat keparahan glaukoma yang diderita.',
        'normal':
            'Memeriksa mata secara rutin. Mengonsumsi makanan bergizi. Menghindari penggunaan gawai terlalu lama. Menghindari paparan sinar ultraviolet. Menghentikan kebiasaan merokok. Olahraga secara rutin',
        'pathological_myopia':
            'Jika Anda mencurigai terjadinya perubahan atau penurunan kemampuan penglihatan, segera periksakan ke dokter,misalnya jika tidak bisa melihat tulisan atau benda-benda jauh yang biasanya terlihat.\nSelain itu, ada kondisi medis darurat yang merupakan komplikasi dari rabun jauh, yaitu pelepasan atau ablasi retina. Segera konsultasikan ke dokter jika menderita gejala pelepasan retina, seperti: Muncul kilatan-kilatan cahaya pada salah satu atau kedua mata. Muncul bayangan seperti tirai pada penglihatan. Mata berkunang-kunang. Melihat bintik-bintik atau benda-benda yang mengambang (floaters).',
        'cataract':
            'Jika katarak tidak terlalu mengganggu, Anda mungkin hanya perlu mengenakan kacamata baru untuk membantu kamu melihat lebih baik. \nJika katarak menyebabkan penglihatan semakin memburuk dan sulit menjalani aktivitas sehari-hari, prosedur operasi merupakan pengobatan yang bisa dilakukan untuk mengatasi masalah mata tersebut.\nAdapun beberapa upaya yang dapat dilakukan untuk mencegah katarak, antara lain: Memeriksakan mata secara teratur pada dokter spesialis mata. Melindungi mata dari benturan dan cahaya matahari yang terlalu lama, dengan menggunakan kacamata yang melindungi dari sinar ultraviolet baik UVA dan UVB. Kelola masalah kesehatan lain, seperti diabetes yang bisa meningkatkan risiko katarak. Membatasi kebiasaan menyetir di malam hari. Memperbaiki pencahayaan di rumah. Menggunakan kaca pembesar saat membaca. Berhenti merokok dan kurangi konsumsi alkohol. Terapkan pola makan dengan memperbanyak buah-buahan dan sayuran.',
      };

      Map<String, String> mapName = {
        'glaucoma': 'Glukoma',
        'cataract': 'Katarak',
        'normal': 'Normal',
        'pathological_myopia': 'Miopi'
      };

      _information = mapInformation[_name] ?? '';
      _causes = mapCauses[_name] ?? '';
      _healing = mapHealing[_name] ?? '';
      _newName = mapName[_name] ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    loadMyModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: edge,
        ),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 28,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'btn_back.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    'Deteksi Mata',
                    style: blackTextStyle.copyWith(
                      fontSize: 22,
                    ),
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    children: [
                      isImageLoaded
                          ? Center(
                              child: Container(
                              height: 350,
                              width: 350,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(File(pickedImage.path)),
                                      fit: BoxFit.contain)),
                            ))
                          : Container(),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Kondisi Mata Anda terdeteksi:',
                        style: blackTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '$_newName',
                        style: blackTextStyle.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Kemungkinan diagnosis: $_confidence',
                        style: blackTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Informasi Umum',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  '$_information',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Gejala dan Penyebab',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  '$_causes',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Pengobatan dan Pencegahan',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  '$_healing',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Rekomendasi Dokter',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                isImageLoaded
                    ? Container(
                        height: 300,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            DoctorItem(
                              Doctor(
                                name: "dr. Yosep Novento, Sp.M.",
                                phoneNumber: "081809929885",
                                imageUrl: "assets/dokter1.png",
                                location: 'Wonogiri',
                              ),
                            ),
                            SizedBox(
                              width: 24,
                            ),
                            DoctorItem(
                              Doctor(
                                name: "dr. Mahadiva Ayu, Sp.M.",
                                phoneNumber: "021-2522-2323",
                                imageUrl: "assets/dokter2.png",
                                location: 'Solo',
                              ),
                            ),
                            SizedBox(
                              width: 24,
                            ),
                            DoctorItem(
                              Doctor(
                                name: "dr. Nanda Arfan Hakim, Sp.M",
                                phoneNumber: "021-3553-2323",
                                imageUrl: "assets/dokter1.png",
                                location: 'Semarang',
                              ),
                            ),
                            SizedBox(
                              width: 24,
                            ),
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImageFromGallery();
        },
        child: const Icon(Icons.photo_album),
      ),
    );
  }
}
