/// Image and SVG loaders for attachments that live on the device's file
/// system.
///
/// `dart:io`'s `File` does not exist on the web, and the stub that stands in
/// for it there is not the type `FileImage`/`SvgFileLoader` expect — so the
/// loaders themselves, not just the `File` class, have to be swapped out per
/// platform.
export 'package:apptive_grid_form/src/widgets/attachment/file_loaders_io.dart'
    if (dart.library.html) 'package:apptive_grid_form/src/widgets/attachment/file_loaders_web.dart';
