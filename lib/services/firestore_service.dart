import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/farm.dart';
import '../models/crop.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Farm operations
  Future<void> createFarm(Farm farm) async {
    try {
      await _firestore.collection('farms').doc(farm.id).set(farm.toJson());
    } catch (e) {
      throw Exception('Failed to create farm: ${e.toString()}');
    }
  }

  Future<Farm?> getFarm(String farmId) async {
    try {
      final doc = await _firestore.collection('farms').doc(farmId).get();
      if (doc.exists && doc.data() != null) {
        return Farm.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get farm: ${e.toString()}');
    }
  }

  Stream<List<Farm>> getFarmsByOwner(String ownerId) {
    return _firestore
        .collection('farms')
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Farm.fromJson(doc.data()))
            .toList());
  }

  Future<void> updateFarm(Farm farm) async {
    try {
      await _firestore.collection('farms').doc(farm.id).update(farm.toJson());
    } catch (e) {
      throw Exception('Failed to update farm: ${e.toString()}');
    }
  }

  Future<void> deleteFarm(String farmId) async {
    try {
      await _firestore.collection('farms').doc(farmId).delete();
    } catch (e) {
      throw Exception('Failed to delete farm: ${e.toString()}');
    }
  }

  // Crop operations
  Future<void> createCrop(Crop crop) async {
    try {
      await _firestore.collection('crops').doc(crop.id).set(crop.toJson());
    } catch (e) {
      throw Exception('Failed to create crop: ${e.toString()}');
    }
  }

  Future<Crop?> getCrop(String cropId) async {
    try {
      final doc = await _firestore.collection('crops').doc(cropId).get();
      if (doc.exists && doc.data() != null) {
        return Crop.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get crop: ${e.toString()}');
    }
  }

  Stream<List<Crop>> getCropsByFarm(String farmId) {
    return _firestore
        .collection('crops')
        .where('farmId', isEqualTo: farmId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Crop.fromJson(doc.data()))
            .toList());
  }

  Future<void> updateCrop(Crop crop) async {
    try {
      await _firestore.collection('crops').doc(crop.id).update(crop.toJson());
    } catch (e) {
      throw Exception('Failed to update crop: ${e.toString()}');
    }
  }

  Future<void> deleteCrop(String cropId) async {
    try {
      await _firestore.collection('crops').doc(cropId).delete();
    } catch (e) {
      throw Exception('Failed to delete crop: ${e.toString()}');
    }
  }

  // Generic operations
  Future<List<T>> getCollection<T>(
    String collectionName,
    T Function(Map<String, dynamic>) fromJson, {
    Query Function(Query)? queryBuilder,
    int? limit,
  }) async {
    try {
      Query query = _firestore.collection(collectionName);
      
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get collection: ${e.toString()}');
    }
  }

  Stream<List<T>> getCollectionStream<T>(
    String collectionName,
    T Function(Map<String, dynamic>) fromJson, {
    Query Function(Query)? queryBuilder,
    int? limit,
  }) {
    try {
      Query query = _firestore.collection(collectionName);
      
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }

      return query.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => fromJson(doc.data() as Map<String, dynamic>))
          .toList());
    } catch (e) {
      throw Exception('Failed to get collection stream: ${e.toString()}');
    }
  }

  Future<void> addDocument(String collectionName, String documentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).set(data);
    } catch (e) {
      throw Exception('Failed to add document: ${e.toString()}');
    }
  }

  Future<void> updateDocument(String collectionName, String documentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).update(data);
    } catch (e) {
      throw Exception('Failed to update document: ${e.toString()}');
    }
  }

  Future<void> deleteDocument(String collectionName, String documentId) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>?> getDocument(String collectionName, String documentId) async {
    try {
      final doc = await _firestore.collection(collectionName).doc(documentId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      throw Exception('Failed to get document: ${e.toString()}');
    }
  }
}

