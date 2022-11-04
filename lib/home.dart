import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  var _image;
  var _output;
  final picker = ImagePicker(); //allows us to pick image from gallery or camera
  final _key1 = GlobalKey();
  final _key2 = GlobalKey();
  final _key3 = GlobalKey();
  final _key4 = GlobalKey();

  @override
  void initState() {
    //initS is the first function that is executed by default when this class is called
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context).startShowCase(
        [_key1, _key2, _key3, _key4],
      ),
    );
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    //dis function disposes and clears our memory
    super.dispose();
    Tflite.close();
  }

  classifyImage(File image) async {
    //this function runs the model on the image
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 3, //the amout of categories our neural network can predict
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    //this function loads our model
    await Tflite.loadModel(
        model: 'assets/model_060622_92.tflite',
        labels: 'assets/labels_060622_92.txt');
  }

  pickImage() async {
    //this function to grab the image from camera
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  pickGalleryImage() async {
    //this function to grab the image from gallery
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Showcase(
        key: _key2,
        description: 'Presiona aqui para Seleccionar imagen',
        showcaseBackgroundColor: Colors.blue,
        descTextStyle: const TextStyle(
            fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16),
        shapeBorder: const CircleBorder(),
        overlayPadding: const EdgeInsets.all(8),
        child: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: Colors.redAccent,
          overlayColor: Colors.black,
          overlayOpacity: 0.4,
          spacing: 2,
          spaceBetweenChildren: 12,
          closeManually: false,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add_a_photo_rounded),
              label: 'Tomar una foto',
              backgroundColor: Colors.greenAccent,
              onTap: pickImage,
            ),
            SpeedDialChild(
              child: const Icon(Icons.add_photo_alternate_rounded),
              label: 'Elegir de la Galeria',
              backgroundColor: Colors.yellowAccent,
              onTap: pickGalleryImage,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            setState(() {
              ShowCaseWidget.of(context)
                  .startShowCase([_key1, _key2, _key3, _key4]);
            });
          },
          icon: Showcase(
              key: _key1,
              description: 'Para ayuda presiona aqui',
              shapeBorder: const CircleBorder(),
              showcaseBackgroundColor: Colors.blue,
              descTextStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16),
              child: const Icon(Icons.help_rounded)),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 17, 45, 78),
        title: const Text(
          'Diagnostico de Artritis Reumatoide',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
              letterSpacing: 0.8),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 249, 247, 247),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 17, 45, 78),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Showcase(
                key: _key3,
                description: 'Aqui se mostraran tus resultados',
                overlayColor: Colors.white,
                overlayOpacity: 0.4,
                showArrow: true,
                //shapeBorder: const CircleBorder(),
                overlayPadding: const EdgeInsets.only(
                    left: 1, top: 300, right: 4, bottom: 8),

                child: Center(
                  child: _loading == true
                      ? null //show nothing if no picture selected
                      : Column(
                          children: [
                            SizedBox(
                              height: 350,
                              width: 350,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.file(
                                  _image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const Divider(
                              height: 25,
                              thickness: 1,
                            ),
                            _output != null
                                ? Text(
                                    '${_output[0]}',
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  )
                                : Container(),
                            const Divider(
                              height: 100,
                              thickness: 1,
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
