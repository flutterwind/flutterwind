import 'package:flutter/material.dart';
import 'package:flutterwind_core/flutterwind.dart';

/// This example demonstrates the various transform utilities available in FlutterWind
/// including scale, rotate, translate, skew, and transform origin.
class TransformExamplesPage extends StatelessWidget {
  const TransformExamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transform Utilities'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Scale Transforms'),
            _buildScaleExamples(),
            const SizedBox(height: 32),
            
            _buildSectionTitle('Rotate Transforms'),
            _buildRotateExamples(),
            const SizedBox(height: 32),
            
            _buildSectionTitle('Translate Transforms'),
            _buildTranslateExamples(),
            const SizedBox(height: 32),
            
            _buildSectionTitle('Skew Transforms'),
            _buildSkewExamples(),
            const SizedBox(height: 32),
            
            _buildSectionTitle('Transform Origin'),
            _buildOriginExamples(),
            const SizedBox(height: 32),
            
            _buildSectionTitle('Combined Transforms'),
            _buildCombinedExamples(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildExampleBox(String label, String transformClasses) {
    return Column(
      children: [
        Container(
          child: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
            child: Center(
              child: Text(
                'Box',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ).className(transformClasses),
        ),
        const SizedBox(height: 8),
        Text(label),
        Text(
          transformClasses,
          style: TextStyle(fontFamily: 'monospace', fontSize: 12),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildScaleExamples() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildExampleBox('No Scale', ''),
        _buildExampleBox('Scale 150%', 'scale-150'),
        _buildExampleBox('Scale X 150%', 'scale-x-150'),
        _buildExampleBox('Scale Y 150%', 'scale-y-150'),
        _buildExampleBox('Scale 50%', 'scale-50'),
        _buildExampleBox('Custom Scale', 'scale-[1.35]'),
      ],
    );
  }

  Widget _buildRotateExamples() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildExampleBox('No Rotation', ''),
        _buildExampleBox('Rotate 45°', 'rotate-45'),
        _buildExampleBox('Rotate 90°', 'rotate-90'),
        _buildExampleBox('Rotate 180°', 'rotate-180'),
        _buildExampleBox('Rotate -45°', 'rotate-[-45]'),
        _buildExampleBox('Custom Rotation', 'rotate-[33deg]'),
      ],
    );
  }

  Widget _buildTranslateExamples() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildExampleBox('No Translation', ''),
        _buildExampleBox('Translate X 20px', 'translate-x-[20px]'),
        _buildExampleBox('Translate Y 20px', 'translate-y-[20px]'),
        _buildExampleBox('Translate X -20px', 'translate-x-[-20px]'),
        _buildExampleBox('Translate Y -20px', 'translate-y-[-20px]'),
        _buildExampleBox('Translate X 50%', 'translate-x-1/2'),
      ],
    );
  }

  Widget _buildSkewExamples() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildExampleBox('No Skew', ''),
        _buildExampleBox('Skew X 12°', 'skew-x-12'),
        _buildExampleBox('Skew Y 12°', 'skew-y-12'),
        _buildExampleBox('Skew X -12°', 'skew-x-[-12]'),
        _buildExampleBox('Skew Y -12°', 'skew-y-[-12]'),
        _buildExampleBox('Custom Skew', 'skew-x-[17deg]'),
      ],
    );
  }

  Widget _buildOriginExamples() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildExampleBox('Center Origin\n(Default)', 'rotate-45'),
        _buildExampleBox('Top-Left Origin', 'rotate-45 origin-top-left'),
        _buildExampleBox('Top-Right Origin', 'rotate-45 origin-top-right'),
        _buildExampleBox('Bottom-Left Origin', 'rotate-45 origin-bottom-left'),
        _buildExampleBox('Bottom-Right Origin', 'rotate-45 origin-bottom-right'),
        _buildExampleBox('Custom Origin', 'rotate-45 origin-[10px_10px]'),
      ],
    );
  }

  Widget _buildCombinedExamples() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildExampleBox('Scale + Rotate', 'scale-125 rotate-45'),
        _buildExampleBox('Rotate + Translate', 'rotate-45 translate-x-[20px]'),
        _buildExampleBox('Scale + Skew', 'scale-125 skew-x-12'),
        _buildExampleBox('Complex Transform', 'scale-125 rotate-45 translate-x-[10px] translate-y-[10px] origin-top-left'),
      ],
    );
  }
}