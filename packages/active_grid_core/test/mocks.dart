import 'package:active_grid_core/active_grid_core.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements Client {}

class MockActiveGridClient extends Mock implements ActiveGridClient {}
