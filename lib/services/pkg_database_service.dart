import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PkgDatabaseService {
  Map<String, dynamic> _translations = {};
  List<dynamic> _interpretations = [];
  List<dynamic> _combinationRules = [];

  // Categorized knowledge collections
  List<dynamic> majorLines = [];
  List<dynamic> minorLines = [];
  List<dynamic> mounts = [];
  List<dynamic> marks = [];
  List<dynamic> fingers = [];
  List<dynamic> thumbFeatures = [];
  List<dynamic> nails = [];
  List<dynamic> fingerprints = [];
  List<dynamic> handShapes = [];
  List<dynamic> wizardSteps = [];
  List<dynamic> hands = [];
  List<dynamic> palms = [];
  List<dynamic> physicals = [];
  List<dynamic> timing = [];

  // Initialize and load assets from pkg_database/
  Future<void> initialize() async {
    try {
      // Load Persian translations
      final String transContent =
          await rootBundle.loadString('pkg_database/translations/fa.json');
      _translations = json.decode(transContent);

      // Load interpretations table
      final String interpContent = await rootBundle
          .loadString('pkg_database/knowledge/interpretations.json');
      _interpretations = json.decode(interpContent)['records'];

      // Load combination rules
      final String rulesContent = await rootBundle
          .loadString('pkg_database/knowledge/combination_rules.json');
      _combinationRules = json.decode(rulesContent)['rules'];

      // Load specific knowledge assets
      majorLines = await _loadKnowledgeList('major_lines.json');
      minorLines = await _loadKnowledgeList('minor_lines.json');
      mounts = await _loadKnowledgeList('mounts.json');
      marks = await _loadKnowledgeList('marks.json');
      fingers = await _loadKnowledgeList('fingers.json');
      thumbFeatures = await _loadKnowledgeList('thumb.json');
      nails = await _loadKnowledgeList('nails.json');
      fingerprints = await _loadKnowledgeList('fingerprints.json');
      handShapes = await _loadKnowledgeList('hand_shapes.json');
      wizardSteps = await _loadKnowledgeList('wizard_steps.json');
      hands = await _loadKnowledgeList('hands.json');
      palms = await _loadKnowledgeList('palms.json');
      physicals = await _loadKnowledgeList('physical_features.json');
      timing = await _loadKnowledgeList('timing.json');
    } catch (e) {
      debugPrint("Error loading PKG database: $e");
    }
  }

  Future<List<dynamic>> _loadKnowledgeList(String fileName) async {
    try {
      final String content =
          await rootBundle.loadString('pkg_database/knowledge/$fileName');
      final Map<String, dynamic> data = json.decode(content);
      return data['features'] ?? data['steps'] ?? [];
    } catch (e) {
      debugPrint("Error loading $fileName: $e");
      return [];
    }
  }

  // Get localized Farsi translation for a key
  String translate(String key, {String fallback = ""}) {
    return _translations[key] ?? fallback;
  }

  // Retrieve interpretation string based on entity ID, attribute, and selected value
  String getInterpretation(String entityId, String attribute, String value) {
    for (var record in _interpretations) {
      if (record['target_entity'] == entityId &&
          record['condition_attribute'] == attribute &&
          record['condition_value'] == value) {
        final String overallKey = record['interpretation']['overall'] ?? '';
        return translate(overallKey, fallback: "$entityId ($attribute=$value)");
      }
    }
    return "";
  }

  // Get all interpretations for a given feature ID
  List<Map<String, String>> getInterpretationsForFeature(String entityId) {
    final List<Map<String, String>> results = [];
    for (var record in _interpretations) {
      if (record['target_entity'] == entityId) {
        final String overallKey = record['interpretation']['overall'] ?? '';
        final String translationVal = translate(overallKey);

        // Split raw "State: Explanation" text
        if (translationVal.isNotEmpty) {
          final parts = translationVal.split(":");
          final String state =
              parts.isNotEmpty ? parts[0].trim() : record['condition_value'];
          final String explanation = parts.length > 1
              ? parts.sublist(1).join(":").trim()
              : translationVal;
          results.add({
            "state": state,
            "explanation": explanation,
            "attr": record['condition_attribute'],
            "val": record['condition_value']
          });
        }
      }
    }
    return results;
  }

  // Evaluate combination rules based on current user selections
  List<String> evaluateCombinations(Map<String, String> userSelections) {
    final List<String> results = [];

    for (var rule in _combinationRules) {
      final String op = rule['conditions']['operator'] ?? 'AND';
      final List<dynamic> subRules = rule['conditions']['rules'] ?? [];

      bool isMatch = op == 'AND'; // Start true for AND, false for OR
      if (op == 'OR') isMatch = false;

      for (var sub in subRules) {
        final String field = sub['field'];
        final String expectedVal = sub['value'];

        final String? actualVal = userSelections[field];
        final bool conditionPassed = (actualVal == expectedVal);

        if (op == 'AND') {
          isMatch = isMatch && conditionPassed;
        } else if (op == 'OR') {
          isMatch = isMatch || conditionPassed;
        }
      }

      if (isMatch) {
        final String resultKey = rule['result_translation_key'] ?? '';
        final String text = translate(resultKey);
        if (text.isNotEmpty) {
          results.add(text);
        }
      }
    }

    return results;
  }
}
