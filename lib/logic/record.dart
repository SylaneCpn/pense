import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pense/logic/month.dart';

class Record extends ChangeNotifier {
  List<RecordElement> _elements;

  static const path = "record.json";

  UnmodifiableListView get elements => UnmodifiableListView(_elements);

  Record({required List<RecordElement> elements}) : _elements = elements;
  factory Record.fromJson(List<dynamic> json) {
    try {
      final elements = json.map(RecordElement.fromJson).toList();
      return Record(elements: elements);
    } catch (e) {
      rethrow;
    }
  }

  List<Map<String, dynamic>> toJson() {
    try {
      return _elements.map((element) => element.toJson()).toList();
    } catch (e) {
      rethrow;
    }
  }

  // expose notifyListeners to watchers
  void notify() {
    notifyListeners();
  }

  static Future<Record> getRecord() async {
    final appDir = await getApplicationSupportDirectory();
    try {
      final record = await File("${appDir.path}/$path").readAsString();
      final json = await compute(jsonDecode, record);
      return Record.fromJson(json);
    }
    // file doesn't exist
    catch (e) {
      return Record(elements: []);
    }
  }

  Future<void> storeRecord() async {
    final appDir = await getApplicationSupportDirectory();
    final recordAsJson = toJson();
    final recordAsString = await compute(jsonEncode, recordAsJson);
    await File("${appDir.path}/$path").writeAsString(recordAsString);
  }

  RecordElement where(Month month, int year) {
    try {
      return _elements.firstWhere((e) => e.month == month && e.year == year);
    } on StateError catch (_) {
      final newElem = RecordElement.empty(month: month, year: year);
      _elements.add(newElem);
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

  factory RecordElement.fromJson(dynamic json) {
    try {
      return switch (json) {
        {
          'month': String month,
          'year': int year,
          'expenses': List<dynamic> expenses,
          'incomes': List<dynamic> incomes,
        } =>
          RecordElement(
            month: Month.values.byName(month),
            year: year,
            expenses: expenses.map(Category.fromJson).toList(),
            incomes: incomes.map(Category.fromJson).toList(),
          ),
        _ => throw const FormatException('Failed to load record element.'),
      };
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month.name,
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

  factory Category.fromJson(dynamic json) {
    try {
      return switch (json) {
        {'label': String label, 'sources': List<dynamic> sources} => Category(
          label: label,
          sources: sources.map(Source.fromJson).toList(),
        ),
        _ => throw const FormatException('Failed to load category.'),
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


  Iterable<Source> getTopSources(int count) {
    final  List<Source> sortedSources = List.from(sources);
    sortedSources.sort((a,b) => Comparable.compare(b.value, a.value));
    return sortedSources.take(count);
  }


  static Iterable<Source> getTopSourcesInAllCategory(Iterable<Category> categories , int count) {
    final top = categories.map((e) => e.getTopSources(count)).expand((e) => e).toList();
    top.sort((a,b) => Comparable.compare(b.value, a.value));
    return top.take(count);

  }
}

class Source {
  final String label;
  final double value;

  const Source({required this.label, required this.value});

  factory Source.fromJson(dynamic json) {
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
