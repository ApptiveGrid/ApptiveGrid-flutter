import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// There is no file system to read from on the web, so an attachment picked
/// there always carries its `byteData` instead of a `path`. This is only here
/// so the conditional import type checks; reaching it means the caller failed
/// to prefer `byteData`.
ImageProvider fileImageProvider(String path) => MemoryImage(Uint8List(0));

/// See [fileImageProvider] — unreachable on the web, kept for type checking.
BytesLoader svgFileLoader(String path) =>
    SvgStringLoader('<svg xmlns="http://www.w3.org/2000/svg"/>');
