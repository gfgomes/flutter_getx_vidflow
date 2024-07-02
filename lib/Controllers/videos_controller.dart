import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidflow/model/video.dart';
import 'package:vidflow/screens/dashboard.dart';
import 'package:vidflow/services/videos_api.dart';
import 'package:vidflow/utils/snackbars.dart';

class VideosController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getAllFromUser();
  }

  final videoLoading = true.obs;
  final RxList<Video> videos = <Video>[].obs;
  final VideosApi videosApi = Get.put(VideosApi());

  final TextEditingController textVideoTitleController =
      TextEditingController();

  final TextEditingController textVideoThumbNailController =
      TextEditingController();

  Future<void> getAllFromUser() async {
    try {
      videoLoading(true);
      Response<List<Video>> response = await videosApi.getAllFromUser(2);
      if (response.statusCode == 200) {
        videos(response.body);
      }
    } finally {
      videoLoading(false);
    }
  }

  Future<void> create() async {
    final Video video = Video(
        thumbURL: textVideoThumbNailController.text,
        title: textVideoTitleController.text,
        userId: 2);
    try {
      Response<void> response = await videosApi.create(video,
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImdhYnJpZWxAdGVzdGUuY29tIiwiaWF0IjoxNzE5OTI5NzQ4LCJleHAiOjE3MTk5MzMzNDgsInN1YiI6IjIifQ._nEOA3Y2Kla8dtWFs0CVonE10_v9Y8l1ZMJV_2q7T2U");
      if (response.statusCode == 201) {
        AppSnacks.getSuccessUpload();
        Get.offAll(() => Dashboard());
        getAllFromUser();
      } else {
        AppSnacks.getErrorUpload();
        throw response.statusText!;
      }
    } catch (e) {
      print(e);
    }
  }
}
