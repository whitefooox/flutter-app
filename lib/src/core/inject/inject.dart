import 'package:search3/src/features/auth/auth_injection.dart';
import 'package:search3/src/features/recognize/recognize_injection.dart';

void inject() {
  injectRecognize();
  injectAuth();
}
