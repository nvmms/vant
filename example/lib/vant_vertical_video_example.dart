import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VantVerticalVideoExample extends StatelessWidget {
  const VantVerticalVideoExample({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = VantRequestProvider();
    provider.onQuery = (pageIndex) {
      Future.delayed(const Duration(seconds: 1), () {
        provider.complete(
          data: List.generate(1, (index) => index),
          totalRow: 1,
        );
      });
    };

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Vant Vertical Video Example"),
        ),
        body: VantRequest(
          provider: provider,
          builder: (context, data) => VantVerticalVideo(
            data: data,
            itemBuilder: (item, index, currentIndex) => VantVerticalVideoItem(
              item: item,
              index: index,
              currentIndex: currentIndex,
              extractor: VantVerticalVideoDataExtractor(
                getVideoSrc: (item) =>
                    "https://vod.gbtjkj.top/3028e01210e971f0bfdd752281fc0102/592ce4b2eaca4e3593d174df831c6326-2d3f5df9679300c751a3460ae5bd15db-sd.m3u8?auth_key=1744356522-47f9fcb59ca54a068c968d23ac0c11f1-0-092e0ec57ed9467a360ee46c63a12ae0",
                getCoverImage: (item) =>
                    "http://gips3.baidu.com/it/u=3886271102,3123389489&fm=3028&app=3028&f=JPEG&fmt=auto?w=1280&h=960",
                getTitle: (item) =>
                    "titletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitletitle",
                getTopic: (item) => "topic",
                getAuthorName: (item) =>
                    "authorNameauthorNameauthorNameauthorNameauthorNameauthorNameauthorNameauthorNameauthorNameauthorNameauthorNameauthorNameauthorNameauthorNameauthorNameauthorName",
                getAvatarUrl: (item) =>
                    "http://gips3.baidu.com/it/u=3886271102,3123389489&fm=3028&app=3028&f=JPEG&fmt=auto?w=1280&h=960",
                getLikeCount: (item) => 1,
                getFavoriteCount: (item) => 2,
                isLike: (item) => false,
                isCollect: (item) => false,
                getCommentCount: (item) => 3,
                getShareCount: (item) => 4,
                isFollow: (item) => false,
              ),
              onTap: (item, index, type) {
                print(item);
                print(index);
                print(type);
                return Future.value(true);
              },
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const VantVerticalVideoExample());
}
