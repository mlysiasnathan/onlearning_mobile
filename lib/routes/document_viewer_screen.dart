import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentViewerScreen extends StatelessWidget {
  const DocumentViewerScreen({Key? key}) : super(key: key);
  static const routeName = '/document-viewer';
  @override
  Widget build(BuildContext context) {
    final GlobalKey<SfPdfViewerState> _pdfViewerStateKey = GlobalKey();
    late PdfViewerController _pdfViewerColntroller = PdfViewerController();
    final String documentLink =
        ModalRoute.of(context)?.settings.arguments as String;
    double zoom = 1;
    return SafeArea(
      child: Scaffold(
        body: SfPdfViewer.network(
          documentLink,
          controller: _pdfViewerColntroller,
          key: _pdfViewerStateKey,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.blueAccent.withOpacity(0.7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                splashRadius: 40,
                splashColor: Colors.white,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                ),
              ),
              IconButton(
                splashRadius: 40,
                splashColor: Colors.white,
                onPressed: () => _pdfViewerColntroller.previousPage(),
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
              ),
              IconButton(
                splashRadius: 40,
                splashColor: Colors.white,
                onPressed: () => _pdfViewerColntroller.zoomLevel = zoom -= 0.25,
                icon: const Icon(
                  Icons.zoom_out,
                  color: Colors.white,
                ),
              ),
              IconButton(
                splashRadius: 40,
                splashColor: Colors.white,
                onPressed: () => _pdfViewerColntroller.zoomLevel = zoom += 0.25,
                icon: const Icon(
                  Icons.zoom_in,
                  color: Colors.white,
                ),
              ),
              IconButton(
                splashRadius: 40,
                splashColor: Colors.white,
                onPressed: () => _pdfViewerColntroller.nextPage(),
                icon: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ),
              IconButton(
                splashRadius: 40,
                splashColor: Colors.white,
                onPressed: () =>
                    _pdfViewerStateKey.currentState!.openBookmarkView(),
                icon: const Icon(
                  Icons.list_alt_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
