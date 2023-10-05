import 'package:search3/src/infrastructure/image_recognize/ai/tf_interpreter.dart';

class InterpreterData {
  int interpreterAddress;
  List<String> labels;
  List<int> inputShape;
  List<int> outputShape;

  InterpreterData(
      this.interpreterAddress, this.labels, this.inputShape, this.outputShape);

  TFInterpreter getInterpreter() {
    return TFInterpreter.fromIntrepterData(this);
  }
}
