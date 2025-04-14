import 'package:flutter/material.dart';
import 'package:vant/vant.dart';

class VantVerticalVideoExample extends StatelessWidget {
  const VantVerticalVideoExample({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = VantRequestProvider<Map<String, String>>();
    provider.onQuery = (pageIndex) {
      Future.delayed(const Duration(seconds: 1), () {
        provider.complete(
          data: [
            {
              "getVideoSrc":
                  "https://vod.gbtjkj.top/3028e01210e971f0bfdd752281fc0102/592ce4b2eaca4e3593d174df831c6326-2d3f5df9679300c751a3460ae5bd15db-sd.m3u8?auth_key=1744662592-0-0-ab33a4c0c337c2e48466050c11db1f94"
            },
            {
              "getVideoSrc":
                  "https://vod.gbtjkj.top/a07854d7105471f0bf376eb3690d0102/6a6aebe619f6428fa0edaf2adbe92c6f-0a2dfeaba8e8c8dab4d34df40f86c3cf-sd.m3u8?auth_key=1744664384-0-0-1579ca46cd724e2c016238b46703872a"
            },
            {
              "getVideoSrc":
                  "https://vod.gbtjkj.top/e0e758d2102d71f0a5511776b3ce0102/661dc23302ca4909ae9af2f938d6bab8-eace9e816ad8dc81dc6d843d18100dd8-sd.m3u8?auth_key=1744664414-0-0-22793defa62bbe9b83016421379adda9"
            },
          ],
          totalRow: 1,
        );
      });
    };

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Vant Vertical Video Example"),
        ),
        body: VantRequest<Map<String, String>>(
          provider: provider,
          builder: (context, data) => VantVerticalVideo(
            data: data,
            itemBuilder: (item, index, currentIndex) =>
                VantVerticalVideoItem<Map<String, String>>(
              item: item,
              index: index,
              currentIndex: currentIndex,
              extractor: VantVerticalVideoDataExtractor(
                getVideoSrc: (item) => item["getVideoSrc"]!,
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
