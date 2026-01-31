import 'package:url_launcher/url_launcher.dart';

class DownloadHelper{

  static Future<void> downloadPDf(Uri url) async{
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}