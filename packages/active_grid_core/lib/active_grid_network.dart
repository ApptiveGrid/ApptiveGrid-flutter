library active_grid_network;

import 'dart:convert';

import 'package:active_grid_core/active_grid_model.dart';
import 'package:active_grid_core/active_grid_options.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client.dart';
import 'package:active_grid_core/network/io_authenticator.dart'
    if (dart.library.html) 'package:active_grid_core/network/web_authenticator.dart';

import 'package:url_launcher/url_launcher.dart';

export 'package:active_grid_core/web_auth_enabler/web_auth_enabler.dart';

part 'network/active_grid_client.dart';
part 'network/environment.dart';
part 'network/active_grid_authentication_options.dart';
part 'network/active_grid_authenticator.dart';
part 'network/constants.dart';
