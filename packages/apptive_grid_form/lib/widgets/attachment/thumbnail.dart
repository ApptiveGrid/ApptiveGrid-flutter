import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:universal_file/universal_file.dart';

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
  });

  /// The Attachment to display a Thumbnail for
  final Attachment attachment;

  /// An AddAttachmentAction to allow to display a thumbnail from [AddAttachmentAction.path] or [AddAttachmentAction.byteData]
  final AddAttachmentAction? addAttachmentAction;

  @override
  Widget build(BuildContext context) {
    // svg Pictures
    if (attachment.type.contains('svg')) {
      late final PictureProvider pictureProvider;
      if (addAttachmentAction != null) {
        if (addAttachmentAction!.path != null) {
          pictureProvider = FilePicture(
            SvgPicture.svgByteDecoderBuilder,
            File(addAttachmentAction!.path!),
          );
        } else {
          pictureProvider = MemoryPicture(
            SvgPicture.svgByteDecoderBuilder,
            addAttachmentAction!.byteData!,
          );
        }
      } else {
        pictureProvider = NetworkPicture(
          SvgPicture.svgByteDecoderBuilder,
          (attachment.smallThumbnail ??
                  attachment.largeThumbnail ??
                  attachment.url)
              .toString(),
        );
      }
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

  static const _typeMap = {
    'application/vnd.lotus-1-2-3': '123',
    'text/vnd.in3d.3dml': '3dml',
    'video/3gpp2': '3g2',
    'video/3gpp': '3gp',
    'application/octet-stream': 'so',
    'application/x-authorware-bin': 'x32',
    'audio/x-aac': 'aac',
    'application/x-authorware-map': 'aam',
    'application/x-authorware-seg': 'aas',
    'application/x-abiword': 'abw',
    'application/vnd.americandynamics.acc': 'acc',
    'application/x-ace-compressed': 'ace',
    'application/vnd.acucobol': 'acu',
    'application/vnd.acucorp': 'atc',
    'audio/adpcm': 'adp',
    'application/vnd.audiograph': 'aep',
    'application/x-font-type1': 'pfm',
    'application/vnd.ibm.modcap': 'listafp',
    'application/postscript': 'ps',
    'audio/x-aiff': 'aiff',
    'application/vnd.adobe.air-application-installer-package+zip': 'air',
    'application/vnd.amiga.ami': 'ami',
    'application/vnd.android.package-archive': 'apk',
    'application/x-ms-application': 'application',
    'application/vnd.lotus-approach': 'apr',
    'application/pgp-signature': 'sig',
    'video/x-ms-asf': 'asx',
    'text/x-asm': 's',
    'application/vnd.accpac.simply.aso': 'aso',
    'application/atom+xml': 'atom',
    'application/atomcat+xml': 'atomcat',
    'application/atomsvc+xml': 'atomsvc',
    'application/vnd.antix.game-component': 'atx',
    'audio/basic': 'snd',
    'video/x-msvideo': 'avi',
    'application/applixware': 'aw',
    'application/vnd.airzip.filesecure.azf': 'azf',
    'application/vnd.airzip.filesecure.azs': 'azs',
    'application/vnd.amazon.ebook': 'azw',
    'application/x-msdownload': 'msi',
    'application/x-bcpio': 'bcpio',
    'application/x-font-bdf': 'bdf',
    'application/vnd.syncml.dm+wbxml': 'bdm',
    'application/vnd.fujitsu.oasysprs': 'bh2',
    'application/vnd.bmi': 'bmi',
    'image/bmp': 'bmp',
    'application/vnd.framemaker': 'maker',
    'application/vnd.previewsystems.box': 'box',
    'application/x-bzip2': 'bz2',
    'image/prs.btif': 'btif',
    'application/x-bzip': 'bz',
    'text/x-c': 'hh',
    'application/vnd.clonk.c4group': 'c4u',
    'application/vnd.ms-cab-compressed': 'cab',
    'application/vnd.curl.car': 'car',
    'application/vnd.ms-pki.seccat': 'cat',
    'application/x-director': 'w3d',
    'application/ccxml+xml': 'ccxml',
    'application/vnd.contact.cmsg': 'cdbcmsg',
    'application/x-netcdf': 'nc',
    'application/vnd.mediastation.cdkey': 'cdkey',
    'chemical/x-cdx': 'cdx',
    'application/vnd.chemdraw+xml': 'cdxml',
    'application/vnd.cinderella': 'cdy',
    'application/pkix-cert': 'cer',
    'image/cgm': 'cgm',
    'application/x-chat': 'chat',
    'application/vnd.ms-htmlhelp': 'chm',
    'application/vnd.kde.kchart': 'chrt',
    'chemical/x-cif': 'cif',
    'application/vnd.anser-web-certificate-issue-initiation': 'cii',
    'application/vnd.ms-artgalry': 'cil',
    'application/vnd.claymore': 'cla',
    'application/java-vm': 'class',
    'application/vnd.crick.clicker.keyboard': 'clkk',
    'application/vnd.crick.clicker.palette': 'clkp',
    'application/vnd.crick.clicker.template': 'clkt',
    'application/vnd.crick.clicker.wordbank': 'clkw',
    'application/vnd.crick.clicker': 'clkx',
    'application/x-msclip': 'clp',
    'application/vnd.cosmocaller': 'cmc',
    'chemical/x-cmdf': 'cmdf',
    'chemical/x-cml': 'cml',
    'application/vnd.yellowriver-custom-menu': 'cmp',
    'image/x-cmx': 'cmx',
    'application/vnd.rim.cod': 'cod',
    'text/plain': 'txt',
    'application/x-cpio': 'cpio',
    'application/mac-compactpro': 'cpt',
    'application/x-mscardfile': 'crd',
    'application/pkix-crl': 'crl',
    'application/x-x509-ca-cert': 'der',
    'application/x-csh': 'csh',
    'chemical/x-csml': 'csml',
    'application/vnd.commonspace': 'csp',
    'text/css': 'css',
    'text/csv': 'csv',
    'application/cu-seeme': 'cu',
    'text/vnd.curl': 'curl',
    'application/prs.cww': 'cww',
    'application/vnd.mobius.daf': 'daf',
    'application/vnd.fdsn.seed': 'seed',
    'application/davmount+xml': 'davmount',
    'text/vnd.curl.dcurl': 'dcurl',
    'application/vnd.oma.dd2+xml': 'dd2',
    'application/vnd.fujixerox.ddd': 'ddd',
    'application/x-debian-package': 'udeb',
    'application/vnd.dreamfactory': 'dfac',
    'application/vnd.mobius.dis': 'dis',
    'image/vnd.djvu': 'djvu',
    'application/vnd.dna': 'dna',
    'application/msword': 'wiz',
    'application/vnd.ms-word.document.macroenabled.12': 'docm',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
        'docx',
    'application/vnd.ms-word.template.macroenabled.12': 'dotm',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.template':
        'dotx',
    'application/vnd.osgi.dp': 'dp',
    'application/vnd.dpgraph': 'dpg',
    'text/prs.lines.tag': 'dsc',
    'application/x-dtbook+xml': 'dtb',
    'application/xml-dtd': 'dtd',
    'audio/vnd.dts': 'dts',
    'audio/vnd.dts.hd': 'dtshd',
    'application/x-dvi': 'dvi',
    'model/vnd.dwf': 'dwf',
    'image/vnd.dwg': 'dwg',
    'image/vnd.dxf': 'dxf',
    'application/vnd.spotfire.dxp': 'dxp',
    'audio/vnd.nuera.ecelp4800': 'ecelp4800',
    'audio/vnd.nuera.ecelp7470': 'ecelp7470',
    'audio/vnd.nuera.ecelp9600': 'ecelp9600',
    'application/ecmascript': 'ecma',
    'application/vnd.novadigm.edm': 'edm',
    'application/vnd.novadigm.edx': 'edx',
    'application/vnd.picsel': 'efif',
    'application/vnd.pg.osasli': 'ei6',
    'message/rfc822': 'nws',
    'application/emma+xml': 'emma',
    'audio/vnd.digital-winds': 'eol',
    'application/vnd.ms-fontobject': 'eot',
    'application/epub+zip': 'epub',
    'application/vnd.eszigno3+xml': 'et3',
    'application/vnd.epson.esf': 'esf',
    'text/x-setext': 'etx',
    'application/vnd.novadigm.ext': 'ext',
    'application/andrew-inset': 'ez',
    'application/vnd.ezpix-album': 'ez2',
    'application/vnd.ezpix-package': 'ez3',
    'text/x-fortran': 'for',
    'video/x-f4v': 'f4v',
    'image/vnd.fastbidsheet': 'fbs',
    'application/vnd.fdf': 'fdf',
    'application/vnd.denovo.fcselayout-link': 'fe_launch',
    'application/vnd.fujitsu.oasysgp': 'fg5',
    'image/x-freehand': 'fhc',
    'application/x-xfig': 'fig',
    'video/x-fli': 'fli',
    'application/vnd.micrografx.flo': 'flo',
    'video/x-flv': 'flv',
    'application/vnd.kde.kivio': 'flw',
    'text/vnd.fmi.flexstor': 'flx',
    'text/vnd.fly': 'fly',
    'application/vnd.frogans.fnc': 'fnc',
    'image/vnd.fpx': 'fpx',
    'application/vnd.fsc.weblaunch': 'fsc',
    'image/vnd.fst': 'fst',
    'application/vnd.fluxtime.clip': 'ftc',
    'application/vnd.anser-web-funds-transfer-initiation': 'fti',
    'video/vnd.fvt': 'fvt',
    'application/vnd.fuzzysheet': 'fzs',
    'image/g3fax': 'g3',
    'application/vnd.groove-account': 'gac',
    'model/vnd.gdl': 'gdl',
    'application/vnd.dynageo': 'geo',
    'application/vnd.geometry-explorer': 'gre',
    'application/vnd.geogebra.file': 'ggb',
    'application/vnd.geogebra.tool': 'ggt',
    'application/vnd.groove-help': 'ghf',
    'image/gif': 'gif',
    'application/vnd.groove-identity-message': 'gim',
    'application/vnd.gmx': 'gmx',
    'application/x-gnumeric': 'gnumeric',
    'application/vnd.flographit': 'gph',
    'application/vnd.grafeq': 'gqs',
    'application/srgs': 'gram',
    'application/vnd.groove-injector': 'grv',
    'application/srgs+xml': 'grxml',
    'application/x-font-ghostscript': 'gsf',
    'application/x-gtar': 'gtar',
    'application/vnd.groove-tool-message': 'gtm',
    'model/vnd.gtw': 'gtw',
    'text/vnd.graphviz': 'gv',
    'application/x-gzip': 'tgz',
    'video/h261': 'h261',
    'video/h263': 'h263',
    'video/h264': 'h264',
    'application/vnd.hbci': 'hbci',
    'application/x-hdf': 'hdf',
    'application/winhlp': 'hlp',
    'application/vnd.hp-hpgl': 'hpgl',
    'application/vnd.hp-hpid': 'hpid',
    'application/vnd.hp-hps': 'hps',
    'application/mac-binhex40': 'hqx',
    'application/vnd.kenameaapp': 'htke',
    'text/html': 'html',
    'application/vnd.yamaha.hv-dic': 'hvd',
    'application/vnd.yamaha.hv-voice': 'hvp',
    'application/vnd.yamaha.hv-script': 'hvs',
    'application/vnd.iccprofile': 'icm',
    'x-conference/x-cooltalk': 'ice',
    'image/x-icon': 'ico',
    'text/calendar': 'ifb',
    'image/ief': 'ief',
    'application/vnd.shana.informed.formdata': 'ifm',
    'model/iges': 'igs',
    'application/vnd.igloader': 'igl',
    'application/vnd.micrografx.igx': 'igx',
    'application/vnd.shana.informed.interchange': 'iif',
    'application/vnd.accpac.simply.imp': 'imp',
    'application/vnd.ms-ims': 'ims',
    'application/vnd.shana.informed.package': 'ipk',
    'application/vnd.ibm.rights-management': 'irm',
    'application/vnd.irepository.package+xml': 'irp',
    'application/vnd.shana.informed.formtemplate': 'itp',
    'application/vnd.immervision-ivp': 'ivp',
    'application/vnd.immervision-ivu': 'ivu',
    'text/vnd.sun.j2me.app-descriptor': 'jad',
    'application/vnd.jam': 'jam',
    'application/java-archive': 'jar',
    'text/x-java-source': 'java',
    'application/vnd.jisp': 'jisp',
    'application/vnd.hp-jlyt': 'jlt',
    'application/x-java-jnlp-file': 'jnlp',
    'application/vnd.joost.joda-archive': 'joda',
    'image/jpeg': 'jpg',
    'video/jpm': 'jpm',
    'video/jpeg': 'jpgv',
    'application/javascript': 'js',
    'application/json': 'json',
    'audio/midi': 'rmi',
    'application/vnd.kde.karbon': 'karbon',
    'application/vnd.kde.kformula': 'kfo',
    'application/vnd.kidspiration': 'kia',
    'application/x-killustrator': 'kil',
    'application/vnd.google-earth.kml+xml': 'kml',
    'application/vnd.google-earth.kmz': 'kmz',
    'application/vnd.kinar': 'knp',
    'application/vnd.kde.kontour': 'kon',
    'application/vnd.kde.kpresenter': 'kpt',
    'application/vnd.kde.kspread': 'ksp',
    'application/vnd.kahootz': 'ktz',
    'application/vnd.kde.kword': 'kwt',
    'application/x-latex': 'latex',
    'application/vnd.llamagraphics.life-balance.desktop': 'lbd',
    'application/vnd.llamagraphics.life-balance.exchange+xml': 'lbe',
    'application/vnd.hhe.lesson-player': 'les',
    'application/vnd.route66.link66+xml': 'link66',
    'application/lost+xml': 'lostxml',
    'application/vnd.ms-lrm': 'lrm',
    'application/vnd.frogans.ltf': 'ltf',
    'audio/vnd.lucent.voice': 'lvp',
    'application/vnd.lotus-wordpro': 'lwp',
    'application/x-msmediaview': 'mvb',
    'video/mpeg': 'mpg',
    'audio/mpeg': 'mpga',
    'audio/x-mpegurl': 'm3u',
    'video/vnd.mpegurl': 'mxu',
    'video/x-m4v': 'm4v',
    'application/mathematica': 'nb',
    'application/vnd.ecowin.chart': 'mag',
    'text/troff': 'tr',
    'application/mathml+xml': 'mathml',
    'application/vnd.mobius.mbk': 'mbk',
    'application/mbox': 'mbox',
    'application/vnd.medcalcdata': 'mc1',
    'application/vnd.mcd': 'mcd',
    'text/vnd.curl.mcurl': 'mcurl',
    'application/x-msaccess': 'mdb',
    'image/vnd.ms-modi': 'mdi',
    'model/mesh': 'silo',
    'application/vnd.mfmp': 'mfm',
    'application/vnd.proteus.magazine': 'mgz',
    'application/vnd.mif': 'mif',
    'video/mj2': 'mjp2',
    'application/vnd.dolby.mlp': 'mlp',
    'application/vnd.chipnuts.karaoke-mmd': 'mmd',
    'application/vnd.smaf': 'mmf',
    'image/vnd.fujixerox.edmics-mmr': 'mmr',
    'application/x-msmoney': 'mny',
    'application/x-mobipocket-ebook': 'prc',
    'video/quicktime': 'qt',
    'video/x-sgi-movie': 'movie',
    'video/mp4': 'mpg4',
    'audio/mp4': 'mp4a',
    'application/mp4': 'mp4s',
    'application/vnd.mophun.certificate': 'mpc',
    'application/vnd.apple.installer+xml': 'mpkg',
    'application/vnd.blueice.multipass': 'mpm',
    'application/vnd.mophun.application': 'mpn',
    'application/vnd.ms-project': 'mpt',
    'application/vnd.ibm.minipay': 'mpy',
    'application/vnd.mobius.mqy': 'mqy',
    'application/marc': 'mrc',
    'application/mediaservercontrol+xml': 'mscml',
    'application/vnd.fdsn.mseed': 'mseed',
    'application/vnd.mseq': 'mseq',
    'application/vnd.epson.msf': 'msf',
    'application/vnd.mobius.msl': 'msl',
    'application/vnd.muvee.style': 'msty',
    'model/vnd.mts': 'mts',
    'application/vnd.musician': 'mus',
    'application/vnd.recordare.musicxml+xml': 'musicxml',
    'application/vnd.mfer': 'mwf',
    'application/mxf': 'mxf',
    'application/vnd.recordare.musicxml': 'mxl',
    'application/xv+xml': 'xvml',
    'application/vnd.triscape.mxs': 'mxs',
    'application/vnd.nokia.n-gage.symbian.install': 'n-gage',
    'application/x-dtbncx+xml': 'ncx',
    'application/vnd.nokia.n-gage.data': 'ngdat',
    'application/vnd.neurolanguage.nlu': 'nlu',
    'application/vnd.enliven': 'nml',
    'application/vnd.noblenet-directory': 'nnd',
    'application/vnd.noblenet-sealer': 'nns',
    'application/vnd.noblenet-web': 'nnw',
    'image/vnd.net-fpx': 'npx',
    'application/vnd.lotus-notes': 'nsf',
    'application/vnd.fujitsu.oasys2': 'oa2',
    'application/vnd.fujitsu.oasys3': 'oa3',
    'application/vnd.fujitsu.oasys': 'oas',
    'application/x-msbinder': 'obd',
    'application/oda': 'oda',
    'application/vnd.oasis.opendocument.database': 'odb',
    'application/vnd.oasis.opendocument.chart': 'odc',
    'application/vnd.oasis.opendocument.formula': 'odf',
    'application/vnd.oasis.opendocument.formula-template': 'odft',
    'application/vnd.oasis.opendocument.graphics': 'odg',
    'application/vnd.oasis.opendocument.image': 'odi',
    'application/vnd.oasis.opendocument.presentation': 'odp',
    'application/vnd.oasis.opendocument.spreadsheet': 'ods',
    'application/vnd.oasis.opendocument.text': 'odt',
    'audio/ogg': 'spx',
    'video/ogg': 'ogv',
    'application/ogg': 'ogx',
    'application/onenote': 'onetoc2',
    'application/oebps-package+xml': 'opf',
    'application/vnd.palm': 'pqa',
    'application/vnd.lotus-organizer': 'org',
    'application/vnd.yamaha.openscoreformat': 'osf',
    'application/vnd.yamaha.openscoreformat.osfpvg+xml': 'osfpvg',
    'application/vnd.oasis.opendocument.chart-template': 'otc',
    'application/x-font-otf': 'otf',
    'application/vnd.oasis.opendocument.graphics-template': 'otg',
    'application/vnd.oasis.opendocument.text-web': 'oth',
    'application/vnd.oasis.opendocument.image-template': 'oti',
    'application/vnd.oasis.opendocument.text-master': 'otm',
    'application/vnd.oasis.opendocument.presentation-template': 'otp',
    'application/vnd.oasis.opendocument.spreadsheet-template': 'ots',
    'application/vnd.oasis.opendocument.text-template': 'ott',
    'application/vnd.openofficeorg.extension': 'oxt',
    'text/x-pascal': 'pas',
    'application/pkcs10': 'p10',
    'application/x-pkcs12': 'pfx',
    'application/x-pkcs7-certificates': 'spc',
    'application/pkcs7-mime': 'p7m',
    'application/x-pkcs7-certreqresp': 'p7r',
    'application/pkcs7-signature': 'p7s',
    'application/vnd.powerbuilder6': 'pbd',
    'image/x-portable-bitmap': 'pbm',
    'application/x-font-pcf': 'pcf',
    'application/vnd.hp-pcl': 'pcl',
    'application/vnd.hp-pclxl': 'pclxl',
    'image/x-pict': 'pic',
    'application/vnd.curl.pcurl': 'pcurl',
    'image/x-pcx': 'pcx',
    'application/pdf': 'pdf',
    'application/font-tdpfr': 'pfr',
    'image/x-portable-graymap': 'pgm',
    'application/x-chess-pgn': 'pgn',
    'application/pgp-encrypted': 'pgp',
    'application/pkixcmp': 'pki',
    'application/pkix-pkipath': 'pkipath',
    'application/vnd.3gpp.pic-bw-large': 'plb',
    'application/vnd.mobius.plc': 'plc',
    'application/vnd.pocketlearn': 'plf',
    'application/pls+xml': 'pls',
    'application/vnd.ctc-posml': 'pml',
    'image/png': 'png',
    'image/x-portable-anymap': 'pnm',
    'application/vnd.macports.portpkg': 'portpkg',
    'application/vnd.ms-powerpoint': 'pwz',
    'application/vnd.ms-powerpoint.template.macroenabled.12': 'potm',
    'application/vnd.openxmlformats-officedocument.presentationml.template':
        'potx',
    'application/vnd.ms-powerpoint.addin.macroenabled.12': 'ppam',
    'application/vnd.cups-ppd': 'ppd',
    'image/x-portable-pixmap': 'ppm',
    'application/vnd.ms-powerpoint.slideshow.macroenabled.12': 'ppsm',
    'application/vnd.openxmlformats-officedocument.presentationml.slideshow':
        'ppsx',
    'application/vnd.ms-powerpoint.presentation.macroenabled.12': 'pptm',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation':
        'pptx',
    'application/vnd.lotus-freelance': 'pre',
    'application/pics-rules': 'prf',
    'application/vnd.3gpp.pic-bw-small': 'psb',
    'image/vnd.adobe.photoshop': 'psd',
    'application/x-font-linux-psf': 'psf',
    'application/vnd.pvi.ptid1': 'ptid',
    'application/x-mspublisher': 'pub',
    'application/vnd.3gpp.pic-bw-var': 'pvb',
    'application/vnd.3m.post-it-notes': 'pwn',
    'text/x-python': 'py',
    'audio/vnd.ms-playready.media.pya': 'pya',
    'application/x-python-code': 'pyo',
    'video/vnd.ms-playready.media.pyv': 'pyv',
    'application/vnd.epson.quickanime': 'qam',
    'application/vnd.intu.qbo': 'qbo',
    'application/vnd.intu.qfx': 'qfx',
    'application/vnd.publishare-delta-tree': 'qps',
    'application/vnd.quark.quarkxpress': 'qxt',
    'audio/x-pn-realaudio': 'ram',
    'application/x-rar-compressed': 'rar',
    'image/x-cmu-raster': 'ras',
    'application/vnd.ipunplugged.rcprofile': 'rcprofile',
    'application/rdf+xml': 'rdf',
    'application/vnd.data-vision.rdz': 'rdz',
    'application/vnd.businessobjects': 'rep',
    'application/x-dtbresource+xml': 'res',
    'image/x-rgb': 'rgb',
    'application/reginfo+xml': 'rif',
    'application/resource-lists+xml': 'rl',
    'image/vnd.fujixerox.edmics-rlc': 'rlc',
    'application/resource-lists-diff+xml': 'rld',
    'application/vnd.rn-realmedia': 'rm',
    'audio/x-pn-realaudio-plugin': 'rmp',
    'application/vnd.jcp.javame.midlet-rms': 'rms',
    'application/relax-ng-compact-syntax': 'rnc',
    'application/x-rpm': 'rpm',
    'application/vnd.nokia.radio-presets': 'rpss',
    'application/vnd.nokia.radio-preset': 'rpst',
    'application/sparql-query': 'rq',
    'application/rls-services+xml': 'rs',
    'application/rsd+xml': 'rsd',
    'application/rss+xml': 'rss',
    'application/rtf': 'rtf',
    'text/richtext': 'rtx',
    'application/vnd.yamaha.smaf-audio': 'saf',
    'application/sbml+xml': 'sbml',
    'application/vnd.ibm.secure-container': 'sc',
    'application/x-msschedule': 'scd',
    'application/vnd.lotus-screencam': 'scm',
    'application/scvp-cv-request': 'scq',
    'application/scvp-cv-response': 'scs',
    'text/vnd.curl.scurl': 'scurl',
    'application/vnd.stardivision.draw': 'sda',
    'application/vnd.stardivision.calc': 'sdc',
    'application/vnd.stardivision.impress': 'sdd',
    'application/vnd.solent.sdkm+xml': 'sdkm',
    'application/sdp': 'sdp',
    'application/vnd.stardivision.writer': 'vor',
    'application/vnd.seemail': 'see',
    'application/vnd.sema': 'sema',
    'application/vnd.semd': 'semd',
    'application/vnd.semf': 'semf',
    'application/java-serialized-object': 'ser',
    'application/set-payment-initiation': 'setpay',
    'application/set-registration-initiation': 'setreg',
    'application/vnd.hydrostatix.sof-data': 'sfd-hdstx',
    'application/vnd.spotfire.sfs': 'sfs',
    'application/vnd.stardivision.writer-global': 'sgl',
    'text/sgml': 'sgml',
    'application/x-sh': 'sh',
    'application/x-shar': 'shar',
    'application/shf+xml': 'shf',
    'text/vnd.wap.si': 'si',
    'application/vnd.wap.sic': 'sic',
    'application/vnd.symbian.install': 'sisx',
    'application/x-stuffit': 'sit',
    'application/x-stuffitx': 'sitx',
    'application/vnd.koan': 'skt',
    'text/vnd.wap.sl': 'sl',
    'application/vnd.wap.slc': 'slc',
    'application/vnd.ms-powerpoint.slide.macroenabled.12': 'sldm',
    'application/vnd.openxmlformats-officedocument.presentationml.slide':
        'sldx',
    'application/vnd.epson.salt': 'slt',
    'application/vnd.stardivision.math': 'smf',
    'application/smil+xml': 'smil',
    'application/x-font-snf': 'snf',
    'application/vnd.yamaha.smaf-phrase': 'spf',
    'application/x-futuresplash': 'spl',
    'text/vnd.in3d.spot': 'spot',
    'application/scvp-vp-response': 'spp',
    'application/scvp-vp-request': 'spq',
    'application/x-wais-source': 'src',
    'application/sparql-results+xml': 'srx',
    'application/vnd.kodak-descriptor': 'sse',
    'application/vnd.epson.ssf': 'ssf',
    'application/ssml+xml': 'ssml',
    'application/vnd.sun.xml.calc.template': 'stc',
    'application/vnd.sun.xml.draw.template': 'std',
    'application/vnd.wt.stf': 'stf',
    'application/vnd.sun.xml.impress.template': 'sti',
    'application/hyperstudio': 'stk',
    'application/vnd.ms-pki.stl': 'stl',
    'application/vnd.pg.format': 'str',
    'application/vnd.sun.xml.writer.template': 'stw',
    'application/vnd.sus-calendar': 'susp',
    'application/x-sv4cpio': 'sv4cpio',
    'application/x-sv4crc': 'sv4crc',
    'application/vnd.svd': 'svd',
    'image/svg+xml': 'svgz',
    'application/x-shockwave-flash': 'swf',
    'application/vnd.arastra.swi': 'swi',
    'application/vnd.sun.xml.calc': 'sxc',
    'application/vnd.sun.xml.draw': 'sxd',
    'application/vnd.sun.xml.writer.global': 'sxg',
    'application/vnd.sun.xml.impress': 'sxi',
    'application/vnd.sun.xml.math': 'sxm',
    'application/vnd.sun.xml.writer': 'sxw',
    'application/vnd.tao.intent-module-archive': 'tao',
    'application/x-tar': 'tar',
    'application/vnd.3gpp2.tcap': 'tcap',
    'application/x-tcl': 'tcl',
    'application/vnd.smart.teacher': 'teacher',
    'application/x-tex': 'tex',
    'application/x-texinfo': 'texinfo',
    'application/x-tex-tfm': 'tfm',
    'image/tiff': 'tiff',
    'application/vnd.tmobile-livetv': 'tmo',
    'application/x-bittorrent': 'torrent',
    'application/vnd.groove-tool-template': 'tpl',
    'application/vnd.trid.tpt': 'tpt',
    'application/vnd.trueapp': 'tra',
    'application/x-msterminal': 'trm',
    'text/tab-separated-values': 'tsv',
    'application/x-font-ttf': 'ttf',
    'application/vnd.simtech-mindmapper': 'twds',
    'application/vnd.genomatix.tuxedo': 'txd',
    'application/vnd.mobius.txf': 'txf',
    'application/vnd.ufdl': 'ufdl',
    'application/vnd.umajin': 'umj',
    'application/vnd.unity': 'unityweb',
    'application/vnd.uoml+xml': 'uoml',
    'text/uri-list': 'urls',
    'application/x-ustar': 'ustar',
    'application/vnd.uiq.theme': 'utz',
    'text/x-uuencode': 'uu',
    'application/x-cdlink': 'vcd',
    'text/x-vcard': 'vcf',
    'application/vnd.groove-vcard': 'vcg',
    'text/x-vcalendar': 'vcs',
    'application/vnd.vcx': 'vcx',
    'application/vnd.visionary': 'vis',
    'video/vnd.vivo': 'viv',
    'model/vrml': 'wrl',
    'application/vnd.visio': 'vsw',
    'application/vnd.vsf': 'vsf',
    'model/vnd.vtu': 'vtu',
    'application/voicexml+xml': 'vxml',
    'application/x-doom': 'wad',
    'audio/x-wav': 'wav',
    'audio/x-ms-wax': 'wax',
    'image/vnd.wap.wbmp': 'wbmp',
    'application/vnd.criticaltools.wbs+xml': 'wbs',
    'application/vnd.wap.wbxml': 'wbxml',
    'application/vnd.ms-works': 'wps',
    'video/x-ms-wm': 'wm',
    'audio/x-ms-wma': 'wma',
    'application/x-ms-wmd': 'wmd',
    'application/x-msmetafile': 'wmf',
    'text/vnd.wap.wml': 'wml',
    'application/vnd.wap.wmlc': 'wmlc',
    'text/vnd.wap.wmlscript': 'wmls',
    'application/vnd.wap.wmlscriptc': 'wmlsc',
    'video/x-ms-wmv': 'wmv',
    'video/x-ms-wmx': 'wmx',
    'application/x-ms-wmz': 'wmz',
    'application/vnd.wordperfect': 'wpd',
    'application/vnd.ms-wpl': 'wpl',
    'application/vnd.wqd': 'wqd',
    'application/x-mswrite': 'wri',
    'application/wsdl+xml': 'wsdl',
    'application/wspolicy+xml': 'wspolicy',
    'application/vnd.webturbo': 'wtb',
    'video/x-ms-wvx': 'wvx',
    'application/vnd.hzn-3d-crossword': 'x3d',
    'application/x-silverlight-app': 'xap',
    'application/vnd.xara': 'xar',
    'application/x-ms-xbap': 'xbap',
    'application/vnd.fujixerox.docuworks.binder': 'xbd',
    'image/x-xbitmap': 'xbm',
    'application/vnd.syncml.dm+xml': 'xdm',
    'application/vnd.adobe.xdp+xml': 'xdp',
    'application/vnd.fujixerox.docuworks': 'xdw',
    'application/xenc+xml': 'xenc',
    'application/patch-ops-error+xml': 'xer',
    'application/vnd.adobe.xfdf': 'xfdf',
    'application/vnd.xfdl': 'xfdl',
    'application/xhtml+xml': 'xhtml',
    'image/vnd.xiff': 'xif',
    'application/vnd.ms-excel': 'xlw',
    'application/vnd.ms-excel.addin.macroenabled.12': 'xlam',
    'application/vnd.ms-excel.sheet.binary.macroenabled.12': 'xlsb',
    'application/vnd.ms-excel.sheet.macroenabled.12': 'xlsm',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': 'xlsx',
    'application/vnd.ms-excel.template.macroenabled.12': 'xltm',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.template':
        'xltx',
    'application/xml': 'xsl',
    'application/vnd.olpc-sugar': 'xo',
    'application/xop+xml': 'xop',
    'application/x-xpinstall': 'xpi',
    'image/x-xpixmap': 'xpm',
    'application/vnd.is-xpr': 'xpr',
    'application/vnd.ms-xpsdocument': 'xps',
    'application/vnd.intercon.formnet': 'xpx',
    'application/xslt+xml': 'xslt',
    'application/vnd.syncml+xml': 'xsm',
    'application/xspf+xml': 'xspf',
    'application/vnd.mozilla.xul+xml': 'xul',
    'image/x-xwindowdump': 'xwd',
    'chemical/x-xyz': 'xyz',
    'application/vnd.zzazz.deck+xml': 'zaz',
    'application/zip': 'zip',
    'application/vnd.zul': 'zirz',
    'application/vnd.handheld-entertainment+xml': 'zmm'
  };
}
