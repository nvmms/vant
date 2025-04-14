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
                  "https://vod.gbtjkj.top/customerTrans/28cb9b1d024990f6caba1e2f915b77ea/66985986-195fe219201-0007-0d19-47f-e8a1d.mp4?auth_key=1744598377-12e5e1fe7f1c46f7ad8199d04c53b178-0-036a3c4e0c74fb4867e19db8e148e27f"
            },
            {
              "getVideoSrc":
                  "https://vod.gbtjkj.top/customerTrans/28cb9b1d024990f6caba1e2f915b77ea/37775ad0-195fa561cf6-0007-0d19-47f-e8a1d.mp4?auth_key=1744600281-7bc2948a4b934d75adfa500e4f1aab9b-0-e93103e67febf82e724defdc24413795"
            },
            {
              "getVideoSrc":
                  "https://vod.gbtjkj.top/customerTrans/28cb9b1d024990f6caba1e2f915b77ea/43052309-195f9566535-0007-0d19-47f-e8a1d.mp4?auth_key=1744600292-7b4c4279064145be95df069ab04c5b4f-0-acc3f81db6c98901fd2327b88d8f7bad"
            },
            {
              "getVideoSrc":
                  "https://vod.gbtjkj.top/customerTrans/28cb9b1d024990f6caba1e2f915b77ea/449278b3-195f9543c4d-0007-0d19-47f-e8a1d.mp4?auth_key=1744601603-52e39ce011c34bd38530a7ced3424e25-0-00687596cf32526248b8ff426bccf9f9"
            },
            {
              "getVideoSrc":
                  "https://vod.gbtjkj.top/customerTrans/28cb9b1d024990f6caba1e2f915b77ea/288d6d99-195e64a3aec-0007-0d19-47f-e8a1d.mp4?auth_key=1744601634-859d963df2054962ae9e5635f3fdad43-0-c47f86358f2c99ba09574301112c40a3"
            },
            {
              "getVideoSrc":
                  "https://vod.gbtjkj.top/customerTrans/28cb9b1d024990f6caba1e2f915b77ea/27eab052-195a9366fe6-0007-0d19-47f-e8a1d.mp4?auth_key=1744601653-e346ffba1ceb42aba3abe406c2366153-0-daabe67c33125711b7e59a22802cbf09"
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
