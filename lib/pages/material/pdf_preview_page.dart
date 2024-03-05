import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:pdf/src/widgets/document.dart';
import 'package:printing/printing.dart';
class PdfPreviewPage extends StatefulWidget {
  final Document? args;
  const PdfPreviewPage({Key? key, this.args}) : super(key: key);

  @override
  _PdfPreviewPageState createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  Document? args;
  @override
  void initState() {
    args=widget.args;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: PdfPreview(
        useActions: true,
          canChangeOrientation:true,
        build: (format) => args!.save(),
      ),
    );
  }
}
