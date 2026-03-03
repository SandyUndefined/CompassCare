import 'dart:convert';

import 'package:compasscare_flutter/core/network/api_client.dart';
import 'package:compasscare_flutter/features/documents/data/models/document_model.dart';

class DocumentRemoteDataSource {
  const DocumentRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<DocumentModel>> fetchDocuments() async {
    final response = await _apiClient.get('/api/documents');

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch documents (status: ${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List<dynamic>) {
      throw const FormatException('Unexpected documents response format');
    }

    return decoded
        .map((item) => DocumentModel.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }
}
