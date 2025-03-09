import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/dicom_cubit.dart';
class DicomListPage extends StatefulWidget {
  static String id = 'DicomListPage';

  const DicomListPage({super.key});

  @override
  DicomListPageState createState() => DicomListPageState();
}

class DicomListPageState extends State<DicomListPage> {
  static String id = 'DicomListPage';
  final String dicomID = '67a8c53310c4de96bae696ee';
  bool isPlaying = false;
  // double brightness = 1.0;
  void togglePlay(BuildContext context) async {
    setState(() {
      isPlaying = !isPlaying;
    });

    while (isPlaying) {
      await Future.delayed(Duration(seconds: 1));
      if (!isPlaying) break;
      if (!mounted) return;
      context.read<DicomCubit>().nextImage();
    }
  }

void showBrightnessDialog(BuildContext context, double currentBrightness) {  
  double dialogBrightness=currentBrightness;
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return AlertDialog(  
        title: Text("Adjust Brightness"),  
        content: StatefulBuilder(  
          builder: (context, setState) {  
            return Column(  
              mainAxisSize: MainAxisSize.min,  
              children: [  
                Text("Current Brightness: ${dialogBrightness.toStringAsFixed(2)}"),  
                Slider(  
                  value: dialogBrightness,  
                  min: 0.0,  
                  max: 2.5,  
                  divisions: 20,  
                  onChanged: (value) {  
                    setState(() {  
                      dialogBrightness = value;   
                    });  
                  },  
                ),  
              ],  
            );  
          },  
        ),  
        actions: [  
          TextButton(  
            child: Text("Cancel"),  
            onPressed: () {  
              Navigator.of(context).pop();  
            },  
          ),  
          TextButton(  
            child: Text("OK"),  
            onPressed: () {  
             context.read<DicomCubit>().adjustBrightness(dialogBrightness);  
            Navigator.of(context).pop();  
            },  
          ),  
        ],  
      );  
    },  
  );  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("DICOM Viewer"),
        backgroundColor: sky,
      ),
      body: BlocBuilder<DicomCubit, DicomState>(
        builder: (context, state) {
          if (state is DicomInitial) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context
                      .read<DicomCubit>()
                      .fetchDicomImages('67a6aab185b7b3f0fef15050');
                },
                child: Text("Load DICOM Images"),
              ),
            );
          } else if (state is DicomLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is DicomLoaded) {
            if (state.images.isEmpty) {
              return Center(child: Text("No images found"));
            }
            return Row(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    color: Colors.black,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 30),
                            onPressed: () => togglePlay(context),
                          ),
                          IconButton(
                            icon: Icon(Icons.brightness_6,
                                color: Colors.white, size: 30),
                            onPressed: () => showBrightnessDialog(context,state.brightness),
                          ),
                        ])),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            if (details.delta.dy < 0) {
                              print("next image");
                              context.read<DicomCubit>().nextImage();
                            } else if (details.delta.dy > 0) {
                              print("previous image");
                              context.read<DicomCubit>().previousImage();
                            }
                          },
                          child: Center(
                            child: InteractiveViewer(
                              panEnabled: true,
                              scaleEnabled: true,
                              child: ColorFiltered(
                                 colorFilter: ColorFilter.matrix([
    state.brightness, 0, 0, 0, 0,  // تأثير على الأحمر
    0, state.brightness, 0, 0, 0,  // تأثير على الأخضر
    0, 0, state.brightness, 0, 0,  // تأثير على الأزرق
    0, 0, 0, 1, 0,                // قيمة الألفا (شفافية)
  ]),
                                child: Image(
                                  image: state.cachedImages[state.currentIndex],
                                  fit: BoxFit.contain,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Image ${state.currentIndex + 1} of ${state.images.length}",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackShape: RectangularSliderTrackShape(),
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 8),
                        overlayColor: Colors.transparent,
                        trackHeight: 8,
                        thumbColor: sky,
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white,
                      ),
                      child: Slider(
                        value: state.currentIndex.toDouble(),
                        min: 0,
                        max: (state.images.length - 1).toDouble(),
                        divisions: state.images.length - 1,
                        onChanged: (value) {
                          context
                              .read<DicomCubit>()
                              .updateImageBySlider(value.toInt());
                        },
                      ),
                    ),
                    
                  ),
                  
                ),
              ],
            );
          } else if (state is DicomError) {
            return Center(
              child: Text(
                "Error: ${state.message}",
                style: TextStyle(color: Colors.redAccent),
              ),
            );
          }
          return Container();
        },
      ),
    );
    // floatingActionButton: Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.only(left: 30.0),
    //       child: FloatingActionButton(
    //         heroTag: "prev",
    //         onPressed: () => context.read<DicomCubit>().previousImage(),
    //         child: Icon(Icons.arrow_back),
    //       ),
    //     ),
    //     FloatingActionButton(
    //       heroTag: "next",
    //       onPressed: () => context.read<DicomCubit>().nextImage(),
    //       child: Icon(Icons.arrow_forward),
    //     ),
    // ],
    // ),
    // );
  }
}
