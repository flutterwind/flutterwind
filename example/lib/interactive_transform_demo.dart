import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';

/// An interactive demo that allows users to experiment with different transform
/// utilities in FlutterWind by adjusting sliders and seeing the results in real-time.
class InteractiveTransformDemo extends StatefulWidget {
  const InteractiveTransformDemo({Key? key}) : super(key: key);

  @override
  State<InteractiveTransformDemo> createState() => _InteractiveTransformDemoState();
}

class _InteractiveTransformDemoState extends State<InteractiveTransformDemo> {
  // Scale values
  double scaleValue = 1.0;
  double scaleXValue = 1.0;
  double scaleYValue = 1.0;
  
  // Rotate value
  double rotateValue = 0.0;
  
  // Translate values
  double translateXValue = 0.0;
  double translateYValue = 0.0;
  
  // Skew values
  double skewXValue = 0.0;
  double skewYValue = 0.0;
  
  // Origin values
  String selectedOrigin = 'center';
  
  // List of available origins
  final List<String> origins = [
    'center',
    'top',
    'top-right',
    'right',
    'bottom-right',
    'bottom',
    'bottom-left',
    'left',
    'top-left',
  ];
  
  @override
  Widget build(BuildContext context) {
    // Build the transform classes string based on current values
    String transformClasses = _buildTransformClasses();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Transform Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview area
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Container(
                  child: Container(
                    width: 150,
                    height: 150,
                    color: Colors.blue,
                    child: const Center(
                      child: Text(
                        'Transform\nDemo',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ).className(transformClasses),
              ),
            ),
            
            // Current transform classes
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    transformClasses,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
            
            const Divider(),
            
            // Scale controls
            _buildSectionTitle('Scale'),
            _buildSlider('Scale (both axes)', scaleValue, 0.5, 2.0, (value) {
              setState(() => scaleValue = value);
            }),
            _buildSlider('Scale X', scaleXValue, 0.5, 2.0, (value) {
              setState(() => scaleXValue = value);
            }),
            _buildSlider('Scale Y', scaleYValue, 0.5, 2.0, (value) {
              setState(() => scaleYValue = value);
            }),
            
            const Divider(),
            
            // Rotate controls
            _buildSectionTitle('Rotate'),
            _buildSlider('Rotate (degrees)', rotateValue, -180, 180, (value) {
              setState(() => rotateValue = value);
            }),
            
            const Divider(),
            
            // Translate controls
            _buildSectionTitle('Translate'),
            _buildSlider('Translate X (pixels)', translateXValue, -100, 100, (value) {
              setState(() => translateXValue = value);
            }),
            _buildSlider('Translate Y (pixels)', translateYValue, -100, 100, (value) {
              setState(() => translateYValue = value);
            }),
            
            const Divider(),
            
            // Skew controls
            _buildSectionTitle('Skew'),
            _buildSlider('Skew X (degrees)', skewXValue, -45, 45, (value) {
              setState(() => skewXValue = value);
            }),
            _buildSlider('Skew Y (degrees)', skewYValue, -45, 45, (value) {
              setState(() => skewYValue = value);
            }),
            
            const Divider(),
            
            // Origin controls
            _buildSectionTitle('Transform Origin'),
            DropdownButton<String>(
              value: selectedOrigin,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedOrigin = newValue;
                  });
                }
              },
              items: origins.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 32),
            
            // Reset button
            Center(
              child: ElevatedButton(
                onPressed: _resetValues,
                child: const Text('Reset All Transforms'),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  // Build the transform classes string based on current values
  String _buildTransformClasses() {
    List<String> classes = [];
    
    // Only add scale if it's not the default value (1.0)
    if (scaleValue != 1.0) {
      classes.add('scale-[${scaleValue.toStringAsFixed(2)}]');
    }
    
    // Only add scale-x if it's not the default value (1.0)
    if (scaleXValue != 1.0) {
      classes.add('scale-x-[${scaleXValue.toStringAsFixed(2)}]');
    }
    
    // Only add scale-y if it's not the default value (1.0)
    if (scaleYValue != 1.0) {
      classes.add('scale-y-[${scaleYValue.toStringAsFixed(2)}]');
    }
    
    // Only add rotate if it's not the default value (0.0)
    if (rotateValue != 0.0) {
      classes.add('rotate-[${rotateValue.toStringAsFixed(0)}deg]');
    }
    
    // Only add translate-x if it's not the default value (0.0)
    if (translateXValue != 0.0) {
      classes.add('translate-x-[${translateXValue.toStringAsFixed(0)}px]');
    }
    
    // Only add translate-y if it's not the default value (0.0)
    if (translateYValue != 0.0) {
      classes.add('translate-y-[${translateYValue.toStringAsFixed(0)}px]');
    }
    
    // Only add skew-x if it's not the default value (0.0)
    if (skewXValue != 0.0) {
      classes.add('skew-x-[${skewXValue.toStringAsFixed(0)}deg]');
    }
    
    // Only add skew-y if it's not the default value (0.0)
    if (skewYValue != 0.0) {
      classes.add('skew-y-[${skewYValue.toStringAsFixed(0)}deg]');
    }
    
    // Only add origin if it's not the default value (center)
    if (selectedOrigin != 'center') {
      classes.add('origin-$selectedOrigin');
    }
    
    return classes.join(' ');
  }
  
  // Reset all transform values to their defaults
  void _resetValues() {
    setState(() {
      scaleValue = 1.0;
      scaleXValue = 1.0;
      scaleYValue = 1.0;
      rotateValue = 0.0;
      translateXValue = 0.0;
      translateYValue = 0.0;
      skewXValue = 0.0;
      skewYValue = 0.0;
      selectedOrigin = 'center';
    });
  }
  
  // Build a section title widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
  
  // Build a slider with label and current value
  Widget _buildSlider(String label, double value, double min, double max, 
      Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(value.toStringAsFixed(1)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) * 10).toInt(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}