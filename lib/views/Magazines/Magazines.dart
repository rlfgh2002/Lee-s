import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haegisa2/models/Magazines/Magazine.dart';
import 'package:haegisa2/models/statics/statics.dart';
import 'package:haegisa2/models/statics/strings.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class MagazineWidget extends StatelessWidget {
  String title = "";
  String fileURL = "";
  String serverFileName = "";
  bool isDownload = false;
  VoidCallback onTap;
  MagazineObject obj;

  MagazineWidget(
      {String title,
      bool isDownload,
      String fileURL,
      String serverFileName,
      VoidCallback onTap,
      MagazineObject obj}) {
    this.title = title;
    this.fileURL = fileURL;
    this.serverFileName = serverFileName;
    this.obj = obj;
    this.isDownload = isDownload;
    this.onTap = onTap;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        systemNavigationBarColor:
            Colors.black // Dark == white status bar -- for IOS.
        ));
    double paddingSize = 16;
    double buttonSize = 100;
    double buttonRealSize = buttonSize - 10;
    double buttonHeight = 40;
    double screenWidth = MediaQuery.of(context).size.width;

    Widget downloadButton = Container(
      child: Text(Strings.shared.controllers.magazines.downloadKeyword,
          style: TextStyle(
              color: Colors.white, fontSize: Statics.shared.fontSizes.content)),
      decoration: BoxDecoration(
          border:
              Border.all(width: 1.5, color: Statics.shared.colors.mainColor),
          color: Statics.shared.colors.mainColor),
      width: buttonRealSize,
      height: buttonHeight,
      alignment: Alignment.center,
    );
    Widget exampleButton = Container(
      child: Text(Strings.shared.controllers.magazines.exampleKeyword,
          style: TextStyle(
              color: Statics.shared.colors.mainColor,
              fontSize: Statics.shared.fontSizes.content)),
      decoration: BoxDecoration(
          border:
              Border.all(width: 1.5, color: Statics.shared.colors.mainColor)),
      width: buttonRealSize,
      height: buttonHeight,
      alignment: Alignment.center,
    );
    Widget selectedButton;
    if (this.isDownload) {
      selectedButton = downloadButton;
    } else {
      selectedButton = exampleButton;
    }

    return FlatButton(
      child: Container(
        child: Row(
          children: [
            Container(
              child: Text(this.title,
                  style: TextStyle(
                      color: Statics.shared.colors.titleTextColor,
                      fontSize: Statics.shared.fontSizes.content)),
              width: (screenWidth - (paddingSize * 2)) - buttonSize,
            ),
            Container(
              width: buttonSize,
              child: selectedButton,
              alignment: Alignment.center,
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Statics.shared.colors.lineColor)),
        ),
        height: 70,
        margin: const EdgeInsets.only(left: 16, right: 16),
      ),
      padding: const EdgeInsets.all(0),
      onPressed: () async {
        print(fileURL);

        Directory appDocDirectory = await getApplicationDocumentsDirectory();
        var _localPath = appDocDirectory.path + "/Magazines";
        final myDir = new Directory(_localPath);
        myDir.exists().then((dirExist) {
          if (dirExist) {
            print('exists');

            final myFile = File(_localPath + "/" + serverFileName);
            myFile.exists().then((fileExist) {
              if (fileExist) {
                print("파일이미 존재");
                isDownload = false;
              } else {
                print("없음");
              }
            });
          } else {
            print('non-existent');

            new Directory(_localPath).create(recursive: true)
                // The created directory is returned as a Future.
                .then((Directory directory) {
              print('Path of New Dir: ' + directory.path);
            });
          }
        });

        final taskId = await FlutterDownloader.enqueue(
          url: fileURL,
          savedDir: _localPath,
          showNotification:
              true, // show download progress in status bar (for Android)
          openFileFromNotification:
              true, // click on notification to open downloaded file (for Android)
        );

        FlutterDownloader.registerCallback((id, status, progress) {
          // code to update your UI
          if (status == DownloadTaskStatus.complete) {
            FlutterDownloader.open(taskId: taskId);
            print("다운완료");
          } else if (status == DownloadTaskStatus.failed) {
            print("다운실패");
          }
        });

        var file = Directory(_localPath).listSync();
        print(file);
      },
    );
  }
}
