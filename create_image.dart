import 'dart:io';
import 'dart:convert';

void main() {
  final imageContent = base64Decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=');
  final file = File('assets/images/cattle_bg.jpg');
  file.createSync(recursive: true);
  file.writeAsBytesSync(imageContent);
}
