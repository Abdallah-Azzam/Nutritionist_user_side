import 'dart:math';

class BmiBrain {
  BmiBrain(this.height, this.weight);
  final int height;
  final int weight;

  String bmiCalculation() {
    double bmi = weight / pow(height / 100, 2);
    return bmi.toStringAsFixed(1);
  }

  String getResult() {
    double _bmi = weight / pow(height / 100, 2);
    if (_bmi >= 25)
      return 'Overweight';
    else if (_bmi >= 18.5)
      return 'Normal';
    else
      return 'UnderWeight';
  }

  String interpertation() {
    double _bmi = weight / pow(height / 100, 2);
    if (_bmi >= 25)
      return 'You Fat Lol';
    else if (_bmi >= 18.5)
      return 'you chillin';
    else
      return 'What are they feeding you';
  }
}
