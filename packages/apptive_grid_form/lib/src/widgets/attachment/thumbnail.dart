import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:universal_file/universal_file.dart';

part 'package:apptive_grid_form/src/widgets/attachment/type_map.dart';

/// A Thumbnail for an Attachment
class Thumbnail extends StatelessWidget {
  /// Creates a Thumbnail Widget for a given [attachment]
  /// If [addAttachmentAction] is not null it will be used to create Image Thumbnails from [AddAttachmentAction.path] or [AddAttachmentAction.byteData]
  ///
  /// If an image Thumbnail can not be loaded or the [Attachment.type] does not indicate that this is an image a File Icon with a file ending will be used to display
  const Thumbnail({
    super.key,
    required this.attachment,
    this.addAttachmentAction,
    this.svgLoader,
  });

  /// The Attachment to display a Thumbnail for
  final Attachment attachment;

  /// An AddAttachmentAction to allow to display a thumbnail from [AddAttachmentAction.path] or [AddAttachmentAction.byteData]
  final AddAttachmentAction? addAttachmentAction;

  /// An SvgLoader to use for loading SVGs. If provided, this loader will be used instead of creating a new one based on the attachment details.
  final SvgLoader? svgLoader; // Add this new property

  @override
  Widget build(BuildContext context) {
    // svg Pictures
    if (attachment.type.contains('svg')) {
      final BytesLoader pictureProvider = SvgLoaderFactory.getLoader(
        attachment: attachment,
        addAttachmentAction: addAttachmentAction,
        svgLoader: svgLoader,
      );
      return SvgPicture(
        pictureProvider,
        fit: BoxFit.cover,
        placeholderBuilder: (_) {
          return _FileIcon(type: attachment.type);
        },
      );
    }

    // Images
    if (attachment.type.startsWith('image/')) {
      late final ImageProvider imageProvider;
      if (addAttachmentAction != null) {
        if (addAttachmentAction!.path != null) {
          imageProvider = FileImage(File(addAttachmentAction!.path!));
        } else {
          imageProvider = MemoryImage(addAttachmentAction!.byteData!);
        }
      } else {
        imageProvider = NetworkImage(
          (attachment.smallThumbnail ??
                  attachment.largeThumbnail ??
                  attachment.url)
              .toString(),
        );
      }
      return Image(
        image: imageProvider,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (frame == null) {
            return _FileIcon(type: attachment.type);
          } else {
            return child;
          }
        },
      );
    }

    // Other Files
    return _FileIcon(type: attachment.type);
  }
}

/// A factory class for creating instances of [BytesLoader] to handle SVG loading.
///
/// This class provides a static method to obtain the appropriate [BytesLoader]
/// based on the given parameters. It can choose between a file loader, a byte loader,
/// or a network loader to fetch and render SVG images.
class SvgLoaderFactory {
  /// Returns an instance of [BytesLoader] based on the provided parameters.
  ///
  /// This method selects the appropriate SVG loader for a given attachment or action.
  /// If an explicit [svgLoader] is provided, it returns that loader directly.
  /// If [addAttachmentAction] is specified with a path, it returns a [SvgFileLoader].
  /// If [addAttachmentAction] is specified with byte data, it returns a [SvgBytesLoader].
  /// Otherwise, it falls back to creating a [SvgNetworkLoader] using the URL from the [attachment].
  ///
  static BytesLoader getLoader({
    Attachment? attachment,
    AddAttachmentAction? addAttachmentAction,
    SvgLoader? svgLoader,
  }) {
    if (svgLoader != null) {
      return svgLoader;
    } else if (addAttachmentAction != null) {
      if (addAttachmentAction.path != null) {
        return SvgFileLoader(File(addAttachmentAction.path!));
      } else {
        return SvgBytesLoader(addAttachmentAction.byteData!);
      }
    } else {
      return SvgNetworkLoader(
        (attachment!.smallThumbnail ??
                attachment.largeThumbnail ??
                attachment.url)
            .toString(),
      );
    }
  }
}

class _FileIcon extends StatelessWidget {
  const _FileIcon({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FileIconPainter(
        color: Theme.of(context).colorScheme.primary,
        type: type,
      ),
    );
  }
}

class _FileIconPainter extends CustomPainter {
  const _FileIconPainter({required this.color, required this.type});

  final Color color;
  final String type;

  @override
  void paint(Canvas canvas, Size size) {
    // Generated from https://fluttershapemaker.com/

    Path filePath = Path();
    filePath.moveTo(size.width * 0.1978720, size.height * 0.9648120);
    filePath.cubicTo(
      size.width * 0.1792800,
      size.height * 0.9648120,
      size.width * 0.1630120,
      size.height * 0.9578400,
      size.width * 0.1490680,
      size.height * 0.9438960,
    );
    filePath.cubicTo(
      size.width * 0.1351220,
      size.height * 0.9299520,
      size.width * 0.1281500,
      size.height * 0.9136820,
      size.width * 0.1281500,
      size.height * 0.8950880,
    );
    filePath.lineTo(size.width * 0.1281500, size.height * 0.1049100);
    filePath.cubicTo(
      size.width * 0.1281500,
      size.height * 0.08631800,
      size.width * 0.1351220,
      size.height * 0.07004800,
      size.width * 0.1490680,
      size.height * 0.05610400,
    );
    filePath.cubicTo(
      size.width * 0.1630120,
      size.height * 0.04216000,
      size.width * 0.1792800,
      size.height * 0.03518800,
      size.width * 0.1978720,
      size.height * 0.03518800,
    );
    filePath.lineTo(size.width * 0.6173660, size.height * 0.03518800);
    filePath.lineTo(size.width * 0.8718500, size.height * 0.2896720);
    filePath.lineTo(size.width * 0.8718500, size.height * 0.8950880);
    filePath.cubicTo(
      size.width * 0.8718500,
      size.height * 0.9136820,
      size.width * 0.8648780,
      size.height * 0.9299520,
      size.width * 0.8509300,
      size.height * 0.9438960,
    );
    filePath.cubicTo(
      size.width * 0.8369860,
      size.height * 0.9578400,
      size.width * 0.8207200,
      size.height * 0.9648120,
      size.width * 0.8021280,
      size.height * 0.9648120,
    );
    filePath.lineTo(size.width * 0.1978720, size.height * 0.9648120);
    filePath.close();
    filePath.moveTo(size.width * 0.5825040, size.height * 0.3210480);
    filePath.lineTo(size.width * 0.5825040, size.height * 0.1049100);
    filePath.lineTo(size.width * 0.1978720, size.height * 0.1049100);
    filePath.lineTo(size.width * 0.1978720, size.height * 0.8950880);
    filePath.lineTo(size.width * 0.8021280, size.height * 0.8950880);
    filePath.lineTo(size.width * 0.8021280, size.height * 0.3210480);
    filePath.lineTo(size.width * 0.5825040, size.height * 0.3210480);
    filePath.close();
    filePath.moveTo(size.width * 0.1978720, size.height * 0.1049100);
    filePath.lineTo(size.width * 0.1978720, size.height * 0.3210480);
    filePath.lineTo(size.width * 0.1978720, size.height * 0.1049100);
    filePath.lineTo(size.width * 0.1978720, size.height * 0.8950880);
    filePath.lineTo(size.width * 0.1978720, size.height * 0.1049100);
    filePath.close();

    Paint fileFill = Paint()..style = PaintingStyle.fill;
    fileFill.color = color;
    canvas.drawPath(filePath, fileFill);

    final textPainter = TextPainter(
      text: TextSpan(
        text: _fileAbbreviation,
        style: TextStyle(
          color: color,
          fontSize: (size.width / (_fileAbbreviation.length)) * 0.8,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        size.height - textPainter.height * 1.5,
      ),
    );
  }

  // coverage:ignore-start
  @override
  bool shouldRepaint(covariant _FileIconPainter oldDelegate) {
    return color != oldDelegate.color || type != oldDelegate.type;
  }
  // coverage:ignore-end

  String get _fileAbbreviation => _typeMap[type] ?? type.split('/').last;
}
