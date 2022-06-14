
import 'package:flutter_uploader/flutter_uploader.dart';
enum MediaType { Image, Video }
class UploadItem {
  final String id;
  final String tag;
  final MediaType type;
  final int progress;
  final UploadTaskStatus status;

  final String caption;
  final String file;

  UploadItem({
    this.id,
    this.tag,
    this.type,
    this.progress = 0,
    this.status = UploadTaskStatus.undefined,this.caption,this.file
  });

  UploadItem copyWith({UploadTaskStatus status, int progress}) => UploadItem(
      id: this.id,
      tag: this.tag,
      type: this.type,
      status: status ?? this.status,
      progress: progress ?? this.progress);


  Map<String, dynamic> toDb() {
    var map = new Map<String, dynamic>();
    map['idd'] = id;
    map['tag'] = tag;
    map['type'] = type;
    map['caption'] = caption;
    map['file'] = file;
    return map;
  }


  bool isCompleted() =>
      this.status == UploadTaskStatus.canceled ||
          this.status == UploadTaskStatus.complete ||
          this.status == UploadTaskStatus.failed;
}
