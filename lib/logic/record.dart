import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pense/logic/month.dart';

Future<Record> getRecord() async {
  print("Fetching record");
  final appDir = await getApplicationDocumentsDirectory();
  print("Got AppDir : ${appDir.path}");
  try {
    final record = await File("${appDir.path}/record.json").readAsString();
    print("read file : ${appDir.path}/record.json");
    final jsonRecord = await compute(jsonDecode, record);
    print("Parsed json");
    print("Record wil be generated from json");
    return Record.fromJson(
      (jsonRecord as List<Object?>).cast<Map<String, Object?>>(),
    );

  }
  // file doesn't exist
  catch (e) {
    print("$e appened : default record");
    return Record(elements: []);
  }
}

Future<void> storeRecord(Record record) async {

  print("storing record");
  final appDir = await getApplicationDocumentsDirectory();
  print("Got AppDir : ${appDir.path}");
  final recordAsJson = record.toJson();
  print("record converted to json");
  final recordAsString = await compute(jsonEncode, recordAsJson);
  print("record encoded to json");
  await File("${appDir.path}/record.json").writeAsString(recordAsString);
  print("file written to : ${appDir.path}/record.json");
}

class Record extends ChangeNotifier {
  List<RecordElement> elements;

  Record({required this.elements});
  factory Record.fromJson(List<Map<String, dynamic>> json) {
    try {
      final elements = json.map(RecordElement.fromJson).toList();
      return Record(elements: elements);
    } catch (e) {
      rethrow;
    }
  }

  List<Map<String, dynamic>> toJson() {
    try {
      return elements.map((element) => element.toJson()).toList();
    } catch (e) {
      rethrow;
    }
  }

  void notify() {
    notifyListeners();
  }

  RecordElement where(Month month, int year) {
    try {
      return elements.firstWhere((e) => e.month == month && e.year == year);
    } on StateError catch (_) {
      final newElem = RecordElement.empty(month: month, year: year);
      elements.add(newElem);
      return newElem;
    }
  }
}

class RecordElement {
  final Month month;
  final int year;
  List<Category> expenses;
  List<Category> incomes;

  RecordElement({
    required this.month,
    required this.year,
    required this.expenses,
    required this.incomes,
  });
  RecordElement.empty({required this.month, required this.year})
    : expenses = [],
      incomes = [];

  factory RecordElement.fromJson(Map<String, dynamic> json) {
    try {
      return switch (json) {
        {
          'month': String month,
          'year': int year,
          'expenses': List<Map<String, dynamic>> expenses,
          'incomes': List<Map<String, dynamic>> incomes,
        } =>
          RecordElement(
            month: Month.values.byName(month),
            year: year,
            expenses: expenses.map(Category.fromJson).toList(),
            incomes: incomes.map(Category.fromJson).toList(),
          ),
        _ => throw const FormatException('Failed to load source.'),
      };
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month.toString(),
      'year': year,
      'expenses': expenses.map((expense) => expense.toJson()).toList(),
      'incomes': incomes.map((income) => income.toJson()).toList(),
    };
  }

  double totalIncome() {
    return incomes
        .map((e) => e.sourceSum())
        .fold(0.0, (value, element) => value + element);
  }

  double totalExpense() {
    return expenses
        .map((e) => e.sourceSum())
        .fold(0.0, (value, element) => value + element);
  }

  double totalElement() {
    return totalIncome() - totalExpense();
  }
}

class Category {
  String label;
  List<Source> sources;

  Category({required this.label, required this.sources});
  Category.empty({required this.label}) : sources = [];

  factory Category.fromJson(Map<String, dynamic> json) {
    try {
      return switch (json) {
        {
          'label': String label,
          'sources': List<Map<String, dynamic>> sources,
        } =>
          Category(
            label: label,
            sources: sources.map(Source.fromJson).toList(),
          ),
        _ => throw const FormatException('Failed to load source.'),
      };
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'sources': sources.map((source) => source.toJson()).toList(),
    };
  }

  double sourceSum() {
    return sources
        .map((e) => e.value)
        .fold(0.0, (value, element) => value + element);
  }
}

class Source {
  final String label;
  final double value;

  const Source({required this.label, required this.value});

  factory Source.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'label': String label, 'value': double value} => Source(
        label: label,
        value: value,
      ),
      _ => throw const FormatException('Failed to load source.'),
    };
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'value': value};
  }
}
