import 'package:electra/core/configs/env.dart';

class ApiEndpoints {
  static String get baseUrl => Env.apiBaseUrl;

  // Auth endpoints
  static const login = "/auth/login";
  static const register = "/auth/register";
  static const refresh = "/auth/refresh";
  static const logout = "/auth/logout";
  static const voiceStream = "/voice/stream";

  // User endpoints
  static const getMe = "/users/me";
  static const updateUser = "/users/{id}";
  static const deleteUser = "/users/{id}";
  static const getSettings = "/users/{id}/settings";
  static const updateSettings = "/users/{id}/settings";

  // Purchase endpoints
  static const getAllPurchases = "/purchases";
  static const searchPurchases = "/purchases/search";
  static const createPurchase = "/purchases";
  static const getPurchase = "/purchases/{id}";
  static const updatePurchase = "/purchases/{id}";
  static const deletePurchase = "/purchases/{id}";

  // Purchase Items endpoints
  static const createPurchaseItem = "/purchase/{purchaseId}/items";
  static const updatePurchaseItem = "/purchase/{purchaseId}/items/{itemId}";
  static const deletePurchaseItem = "/purchase/{purchaseId}/items/{itemId}";
}
