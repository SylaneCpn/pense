import 'package:pense/logic/month.dart';

class Record {}

class RecordElement {
  final Month month;
  final int year;
  List<Category> categories;

  RecordElement({
    required this.month,
    required this.year,
    required this.categories,
  });
  RecordElement.empty({required this.month, required this.year})
    : categories = [];

  factory RecordElement.fromJson(Map<String, dynamic> json) {
    try {
      return switch (json) {
        {
          'month': String month,
          'year': int year,
          'categories': List<Map<String, dynamic>> categories,
        } =>
          RecordElement(
            month: Month.values.byName(month),
            year: year,
            categories: categories.map(Category.fromJson).toList(),
          ),
        _ => throw const FormatException('Failed to load source.'),
      };
    } catch (e) {
      rethrow;
    }
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
}
