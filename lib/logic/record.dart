import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pense/logic/month.dart';

Future<Record> getRecord() async {
  final appDir = await getApplicationDocumentsDirectory();
  try {
    final record = await File("${appDir.path}/record.json").readAsString();
    final jsonRecord = await compute(jsonDecode, record);
    return Record.fromJson(
      (jsonRecord as List<Object?>).cast<Map<String, Object?>>(),
    );
  }
  // file doesn't exist
  catch (e) {
    return Record(elements: []);
  }
}

Future<void> storeRecord(Record record) async {
  final appDir = await getApplicationDocumentsDirectory();
  final recordAsJson = record.toJson();
  final recordAsString = await compute(jsonEncode, recordAsJson);
  await File("${appDir.path}/record.json").writeAsString(recordAsString);
}

class Record extends ChangeNotifier {
  List<RecordElement>? elements;

  Record({this.elements});
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
      return elements?.map((element) => element.toJson()).toList() ?? [];
    } catch (e) {
      rethrow;
    }
  }

  void notify() {
    notifyListeners();
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
      'month': month,
      'year': year,
      'expenses': expenses.map((expense) => expense.toJson()).toList(),
      'incomes': incomes.map((income) => income.toJson()).toList(),
    };
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
}

class Source {
  final String label;
  final String value;

  const Source({required this.label, required this.value});

  factory Source.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'label': String label, 'value': String value} => Source(
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
