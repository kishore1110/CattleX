# YOLOv8 Model Setup for BPA Scanner

## Overview
The BPA Scanner uses a YOLOv8 TensorFlow Lite model to detect cattle and buffalo in images before proceeding to breed classification.

## Model Requirements

### File Location
Place your YOLOv8 TensorFlow Lite model file here:
```
assets/models/yolov8_cattle.tflite
```

### Model Specifications
- **Format**: TensorFlow Lite (.tflite)
- **Input Size**: 640x640 pixels
- **Input Format**: RGB image (normalized 0-1)
- **Output Format**: [1, 25200, 6] where 6 = [x, y, w, h, confidence, class]

### Class IDs
The model should be trained to detect:
- **Class 0**: Cattle/Cow
- **Class 1**: Buffalo

### Confidence Threshold
- Minimum confidence: 50% (0.5)
- Detections below this threshold are ignored

## Model Training (Optional)

If you need to train your own YOLOv8 model:

1. **Prepare Dataset**
   - Collect images of cattle and buffalo
   - Annotate using tools like LabelImg or Roboflow
   - Export in YOLO format

2. **Train YOLOv8 Model**
   ```python
   from ultralytics import YOLO
   
   # Load a model
   model = YOLO('yolov8n.pt')  # or yolov8s.pt, yolov8m.pt, yolov8l.pt, yolov8x.pt
   
   # Train the model
   results = model.train(data='path/to/dataset.yaml', epochs=100, imgsz=640)
   ```

3. **Export to TensorFlow Lite**
   ```python
   # Export the model
   model.export(format='tflite', int8=True)  # Creates model.tflite
   ```

## Testing the Model

Once you place the model file:

1. **Run the app**: `flutter run`
2. **Navigate to Scanner** tab
3. **Select an image** of cattle or buffalo
4. **Tap "Analyze Breed"** to test detection

## Expected Behavior

### ✅ Successful Detection
- Shows "Animal Detected!" dialog
- Displays confidence percentage
- Proceeds to breed identification
- Shows final breed result

### ❌ Failed Detection
- Shows "No Animal Detected" dialog
- Provides tips for better images
- Suggests trying another image

## Troubleshooting

### Model Not Loading
- Check file path: `assets/models/yolov8_cattle.tflite`
- Verify file format is .tflite
- Check model file size (should be reasonable, not corrupted)

### Low Detection Accuracy
- Ensure model was trained on similar cattle/buffalo images
- Check image quality (clear, well-lit, animal visible)
- Verify confidence threshold (currently 50%)

### App Crashes
- Check model input/output dimensions match code expectations
- Verify TensorFlow Lite dependencies are properly installed
- Check device compatibility with TensorFlow Lite

## Future Enhancements

1. **Breed Classification Model**
   - Second-stage model for specific breed identification
   - Will be integrated after cattle/buffalo detection

2. **Model Optimization**
   - Quantization for smaller file size
   - GPU acceleration support
   - Edge TPU compatibility

## Support

For issues with model integration, check:
- Flutter logs for error messages
- Model loading status in app
- TensorFlow Lite compatibility

---
**Note**: This is a placeholder README. Replace with actual model file and update specifications as needed.
