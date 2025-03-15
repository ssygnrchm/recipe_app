import 'package:food_delivery_app/domain/endpoint.dart';
import 'package:http/http.dart' as http;

Future<http.Response> fetchRecipePerCategoryAPI(String category) {
  final _category = category;
  print('${Endpoint.baseUrl}/filter.php?c=${_category}');
  return http.get(Uri.parse('${Endpoint.baseUrl}/filter.php?c=${_category}'));
}

Future<http.Response> fetchRandomRecipeAPI() {
  print('${Endpoint.baseUrl}/random.php');
  return http.get(Uri.parse('${Endpoint.baseUrl}/random.php'));
}
