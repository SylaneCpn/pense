import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pense/logic/category_type.dart';
import 'package:pense/logic/retrospect_type.dart';
import 'package:pense/logic/date_range.dart';
import 'package:pense/logic/month.dart';

class Record extends ChangeNotifier {
  final List<RecordElement> _elements;

  static const path = "record.json";

  List<RecordElement> sortedElements() {
    final copy = List.of(_elements);
    return copy..sort();
  }

  // Get all the existing elments in the given range
  List<RecordElement> existingElementsRange(DateRange range) {
    return sortedElements()
        .where((element) => element.isInDateRange(range))
        .toList();
  }

  // Get all the elements in the given range and return null if the element isn't defined for this date
  List<RecordElement?> maybeElementsRange(DateRange range) {
    return range
        .generateDates()
        .map((date) => whereOrNull(date.$1, date.$2))
        .toList();
  }

  UnmodifiableListView<RecordElement> get elements =>
      UnmodifiableListView(_elements);

  Record({required List<RecordElement> elements})
    : _elements = List.of(elements);
  factory Record.fromJson(List<dynamic> json) {
    final elements = json.map(RecordElement.fromJson).toList();
    return Record(elements: elements);
  }

  List<Map<String, dynamic>> toJson() =>
      _elements.map((element) => element.toJson()).toList();

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

  RecordElement? whereOrNull(Month month, int year) {
    try {
      return _elements.firstWhere((e) => e.month == month && e.year == year);
    } on StateError catch (_) {
      return null;
    }
  }
}

RecordElement? whereOrNull(
  List<RecordElement> elements,
  Month month,
  int year,
) {
  try {
    return elements.firstWhere((e) => e.month == month && e.year == year);
  } on StateError catch (_) {
    return null;
  }
}

// Get all the elements in the given range and return null if the element isn't defined for this date
List<RecordElement?> maybeRecordElementsRange(
  UnmodifiableListView<RecordElement> elements,
  DateRange range,
) {
  return range
      .generateDates()
      .map((date) => whereOrNull(elements, date.$1, date.$2))
      .toList();
}

Future<List<RecordElement?>> computeMaybeRecordElementsRange(
  UnmodifiableListView<RecordElement> elements,
  DateRange range,
) async {
  return await Isolate.run(() => maybeRecordElementsRange(elements, range));
}

class RecordElement implements Comparable<RecordElement> {
  final Month month;
  final int year;
  final List<Category> expenses;
  final List<Category> incomes;

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
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month.name,
      'year': year,
      'expenses': expenses.map((expense) => expense.toJson()).toList(),
      'incomes': incomes.map((income) => income.toJson()).toList(),
    };
  }

  bool isInDateRange(DateRange range) {
    final isBeforeEnd = switch (compareDates(
      thisMonth: month,
      thisYear: year,
      otherMonth: range.endMonth,
      otherYear: range.endYear,
    )) {
      1 => false,
      _ => true,
    };

    final isAfterBegin = switch (compareDates(
      thisMonth: month,
      thisYear: year,
      otherMonth: range.beginMonth,
      otherYear: range.beginYear,
    )) {
      -1 => false,
      _ => true,
    };

    return isAfterBegin && isBeforeEnd;
  }

  int totalIncome() {
    return incomes
        .map((e) => e.sourceSum())
        .fold(0, (value, element) => value + element);
  }

  int totalExpense() {
    return expenses
        .map((e) => e.sourceSum())
        .fold(0, (value, element) => value + element);
  }

  int totalFromCategoryType(CategoryType type) {
    return switch (type) {
      CategoryType.expense => totalExpense(),
      CategoryType.income => totalIncome(),
    };
  }

  int totalFromRetrospectType(RetrospectType type) {
    return switch (type) {
      RetrospectType.expense => totalExpense(),
      RetrospectType.income => totalIncome(),
      RetrospectType.diff => totalElement()
    };
  }

  int totalElement() {
    return totalIncome() - totalExpense();
  }

  //By chronological order
  @override
  int compareTo(RecordElement other) => compareDates(
    thisMonth: month,
    thisYear: year,
    otherMonth: other.month,
    otherYear: other.year,
  );

  Iterable<Category> getTopCategories(CategoryType type , [int? count]) {
    
    final sources = switch (type) {
      CategoryType.expense => expenses,
      CategoryType.income => incomes
    };

    count ??= sources.length;

    final List<Category> sortedCategorires = List.from(sources);
    sortedCategorires.sort((a, b) => Comparable.compare(b.sourceSum(), a.sourceSum()));
    return sortedCategorires.take(count);
  }

  Iterable<SourceWithCategoryRef> getTopSources(CategoryType type , [int? count]) {
    final sources = switch (type) {
      CategoryType.expense => expenses,
      CategoryType.income => incomes
    };

    count ??= sources.length;
    return Category.getTopSourcesWithRefInAllCategory(sources, count);
  }
}



class Category {
  final String label;
  final List<Source> sources;

  Category({required this.label, required this.sources});
  Category.empty({required this.label}) : sources = [];

  factory Category.fromJson(dynamic json) {
    return switch (json) {
      {'label': String label, 'sources': List<dynamic> sources} => Category(
        label: label,
        sources: sources.map(Source.fromJson).toList(),
      ),
      _ => throw const FormatException('Failed to load category.'),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'sources': sources.map((source) => source.toJson()).toList(),
    };
  }

  int sourceSum() {
    return sources
        .map((e) => e.value)
        .fold(0, (value, element) => value + element);
  }

  Iterable<Source> getTopSources(int count) {
    final List<Source> sortedSources = List.from(sources);
    sortedSources.sort((a, b) => Comparable.compare(b.value, a.value));
    return sortedSources.take(count);
  }

  Iterable<SourceWithCategoryRef> getTopSourcesWithRef(int count) {
    final List<SourceWithCategoryRef> sortedSources = sources.map((s) => SourceWithCategoryRef(categoryRef: this, source: s)).toList();
    sortedSources.sort((a, b) => Comparable.compare(b.source.value, a.source.value));
    return sortedSources.take(count);
  }

  static Iterable<Source> getTopSourcesInAllCategory(
    Iterable<Category> categories,
    int count,
  ) {
    final top = categories
        .map((e) => e.getTopSources(count))
        .expand((e) => e)
        .toList();
    top.sort((a, b) => Comparable.compare(b.value, a.value));
    return top.take(count);
  }

  static Iterable<SourceWithCategoryRef> getTopSourcesWithRefInAllCategory(
    Iterable<Category> categories,
    int count,
  ) {
    final top = categories
        .map((e) => e.getTopSourcesWithRef(count))
        .expand((e) => e)
        .toList();
    top.sort((a, b) => Comparable.compare(b.source.value, a.source.value));
    return top.take(count);
  }
}

class Source {
  final String label;
  //as cents
  final int value;

  const Source({required this.label, required this.value});

  factory Source.fromJson(dynamic json) {
    return switch (json) {
      {'label': String label, 'value': int value} => Source(
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

class SourceWithCategoryRef {
  final Category categoryRef;
  final Source source;

  SourceWithCategoryRef({required this.categoryRef , required this.source});


}