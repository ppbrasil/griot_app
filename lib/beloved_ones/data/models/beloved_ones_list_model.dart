import 'package:griot_app/beloved_ones/data/models/beloved_one_model.dart';

class BelovedOneListModel {
  final List<BelovedOneModel> belovedOnes;

  BelovedOneListModel({required this.belovedOnes});

  factory BelovedOneListModel.fromJson(List<dynamic> json) {
    // Iterating through the list and converting each item to `BelovedOneModel`
    List<BelovedOneModel> belovedOnesList = json
        .map((item) => BelovedOneModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return BelovedOneListModel(belovedOnes: belovedOnesList);
  }
}
