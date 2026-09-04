import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Loads the image at [path] from the device's file system.
ImageProvider fileImageProvider(String path) => FileImage(File(path));

/// Loads the SVG at [path] from the device's file system.
BytesLoader svgFileLoader(String path) => SvgFileLoader(File(path));
