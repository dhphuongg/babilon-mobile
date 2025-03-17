import 'package:babilon/core/domain/constants/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CustomColorPicker extends StatefulWidget {
  final Function(Color) onChanged;
  final Color color;

  const CustomColorPicker(
      {super.key, required this.onChanged, required this.color});

  @override
  State<CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  late Color currentColor;
  String selectedFormat = 'RGB';

  // Controllers for RGB and HSB inputs
  TextEditingController redController = TextEditingController();
  TextEditingController greenController = TextEditingController();
  TextEditingController blueController = TextEditingController();
  TextEditingController alphaController = TextEditingController();

  TextEditingController hueController = TextEditingController();
  TextEditingController saturationController = TextEditingController();
  TextEditingController brightnessController = TextEditingController();

  TextEditingController hexController = TextEditingController();

  // Initialize RGB and Alpha controllers with the current color values
  void initRgbControllers() {
    redController.text = currentColor.red.toString();
    greenController.text = currentColor.green.toString();
    blueController.text = currentColor.blue.toString();
    alphaController.text = ((currentColor.alpha / 255) * 100)
        .toStringAsFixed(0); // Alpha as percentage
  }

  // Initialize HSB and Alpha controllers with the current color values
  void initHsbControllers() {
    Map<String, double> hsb = rgbToHsb(currentColor);
    hueController.text = hsb['hue']!.toStringAsFixed(1);
    saturationController.text = hsb['saturation']!.toStringAsFixed(1);
    brightnessController.text = hsb['brightness']!.toStringAsFixed(1);
    alphaController.text = ((currentColor.alpha / 255) * 100)
        .toStringAsFixed(0); // Alpha as percentage
  }

  // Initialize Hex controller with the current color value
  void initHexController() {
    hexController.text = colorToHexWithAlpha(currentColor);
  }

  // Function to convert RGB to HSB (Hue, Saturation, Brightness)
  Map<String, double> rgbToHsb(Color color) {
    double hue, saturation, brightness;
    final r = color.red / 255;
    final g = color.green / 255;
    final b = color.blue / 255;

    final max = [r, g, b].reduce((a, b) => a > b ? a : b);
    final min = [r, g, b].reduce((a, b) => a < b ? a : b);
    final delta = max - min;

    // Calculate Hue
    if (delta == 0) {
      hue = 0;
    } else if (max == r) {
      hue = ((g - b) / delta) % 6;
    } else if (max == g) {
      hue = (b - r) / delta + 2;
    } else {
      hue = (r - g) / delta + 4;
    }
    hue = (hue * 60) % 360;
    if (hue < 0) hue += 360;

    // Calculate Saturation (as percentage)
    saturation = max == 0 ? 0 : delta / max;

    // Calculate Brightness (as percentage)
    brightness = max;

    return {
      'hue': hue,
      'saturation': saturation * 100, // Convert to percentage
      'brightness': brightness * 100, // Convert to percentage
    };
  }

  // Function to convert HSB to RGB
  Color hsbToRgb(
      double hue, double saturation, double brightness, double alpha) {
    double c = (brightness / 100) * (saturation / 100);
    double x = c * (1 - ((hue / 60) % 2 - 1).abs());
    double m = (brightness / 100) - c;

    double r = 0, g = 0, b = 0;
    if (hue >= 0 && hue < 60) {
      r = c;
      g = x;
    } else if (hue >= 60 && hue < 120) {
      r = x;
      g = c;
    } else if (hue >= 120 && hue < 180) {
      g = c;
      b = x;
    } else if (hue >= 180 && hue < 240) {
      g = x;
      b = c;
    } else if (hue >= 240 && hue < 300) {
      r = x;
      b = c;
    } else if (hue >= 300 && hue < 360) {
      r = c;
      b = x;
    }

    return Color.fromARGB((alpha * 255).round(), ((r + m) * 255).round(),
        ((g + m) * 255).round(), ((b + m) * 255).round());
  }

  // Function to convert color to Hex including alpha
  String colorToHexWithAlpha(Color color) {
    return '#${color.alpha.toRadixString(16).padLeft(2, '0').toUpperCase()}${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  @override
  void initState() {
    super.initState();
    currentColor = widget.color;
    initRgbControllers();
    initHsbControllers();
    initHexController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Color Picker
          ColorPicker(
            pickerColor: currentColor,
            onColorChanged: (Color color) {
              setState(() {
                currentColor = color;
                initRgbControllers(); // Update RGB controllers
                initHsbControllers(); // Update HSB controllers
                initHexController(); // Update Hex controller
              });
              widget.onChanged(color);
            },
            labelTypes: const [],
            enableAlpha: true,
            // Enable alpha (transparency)
            pickerAreaHeightPercent: 0.8,
          ),
          // Dropdown for selecting format
          DropdownButton<String>(
            isExpanded: true,
            value: selectedFormat,
            items: <String>['RGB', 'HSB', 'Hex']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedFormat = newValue!;
              });
            },
          ),
          // RGB Input Fields with Alpha
          if (selectedFormat == 'RGB')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: TextFormField(
                    controller: redController,
                    decoration: const InputDecoration(labelText: 'Red'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        currentColor = currentColor.withRed(int.parse(value));
                        initHsbControllers(); // Update HSB controllers
                        initHexController(); // Update Hex controller
                      });
                    },
                  ),
                ),
                Flexible(
                  child: TextFormField(
                    controller: greenController,
                    decoration: const InputDecoration(labelText: 'Green'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        currentColor = currentColor.withGreen(int.parse(value));
                        initHsbControllers(); // Update HSB controllers
                        initHexController(); // Update Hex controller
                      });
                    },
                  ),
                ),
                Flexible(
                  child: TextFormField(
                    controller: blueController,
                    decoration: const InputDecoration(labelText: 'Blue'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        currentColor = currentColor.withBlue(int.parse(value));
                        initHsbControllers(); // Update HSB controllers
                        initHexController(); // Update Hex controller
                      });
                    },
                  ),
                ),
                Flexible(
                  child: TextFormField(
                    controller: alphaController,
                    decoration: const InputDecoration(labelText: 'Alpha (%)'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        currentColor = currentColor.withAlpha(
                            ((double.parse(value) / 100) * 255).round());
                        initHsbControllers(); // Update HSB controllers
                        initHexController(); // Update Hex controller
                      });
                    },
                  ),
                ),
              ],
            ),

          // HSB Input Fields with Alpha
          if (selectedFormat == 'HSB')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: TextFormField(
                    controller: hueController,
                    decoration: const InputDecoration(labelText: 'Hue'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        double hue = double.parse(value);
                        double saturation =
                            double.parse(saturationController.text);
                        double brightness =
                            double.parse(brightnessController.text);
                        double alpha = double.parse(alphaController.text) / 100;
                        currentColor =
                            hsbToRgb(hue, saturation, brightness, alpha);
                        initRgbControllers(); // Update RGB controllers
                        initHexController(); // Update Hex controller
                      });
                    },
                  ),
                ),
                Flexible(
                  child: TextFormField(
                    controller: saturationController,
                    decoration:
                        const InputDecoration(labelText: 'Saturation (%)'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        double hue = double.parse(hueController.text);
                        double saturation = double.parse(value);
                        double brightness =
                            double.parse(brightnessController.text);
                        double alpha = double.parse(alphaController.text) / 100;
                        currentColor =
                            hsbToRgb(hue, saturation, brightness, alpha);
                        initRgbControllers(); // Update RGB controllers
                        initHexController(); // Update Hex controller
                      });
                    },
                  ),
                ),
                Flexible(
                  child: TextFormField(
                    controller: brightnessController,
                    decoration:
                        const InputDecoration(labelText: 'Brightness (%)'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        double hue = double.parse(hueController.text);
                        double saturation =
                            double.parse(saturationController.text);
                        double brightness = double.parse(value);
                        double alpha = double.parse(alphaController.text) / 100;
                        currentColor =
                            hsbToRgb(hue, saturation, brightness, alpha);
                        initRgbControllers(); // Update RGB controllers
                        initHexController(); // Update Hex controller
                      });
                    },
                  ),
                ),
                Flexible(
                  child: TextFormField(
                    controller: alphaController,
                    decoration: const InputDecoration(labelText: 'Alpha (%)'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        double hue = double.parse(hueController.text);
                        double saturation =
                            double.parse(saturationController.text);
                        double brightness =
                            double.parse(brightnessController.text);
                        double alpha = double.parse(value) / 100;
                        currentColor =
                            hsbToRgb(hue, saturation, brightness, alpha);
                        initRgbControllers(); // Update RGB controllers
                        initHexController(); // Update Hex controller
                      });
                    },
                  ),
                ),
              ],
            ),

          // Hex Input Field (with Alpha)
          if (selectedFormat == 'Hex')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: hexController,
                decoration: const InputDecoration(labelText: 'Hex (#RRGGBBAA)'),
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    currentColor =
                        Color(int.parse(value.substring(1), radix: 16));
                    initRgbControllers(); // Update RGB controllers
                    initHsbControllers(); // Update HSB controllers
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
