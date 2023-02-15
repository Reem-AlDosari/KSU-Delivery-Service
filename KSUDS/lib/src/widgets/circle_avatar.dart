import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class AppCircleAvatar extends StatelessWidget {
  final bool? isFile;
  final bool? networkImage;
  final String image;
  final dynamic fileImage;
  final double radius;
  final Color borderColor;
  final String? assetImage;
  final double borderWidth;
  const AppCircleAvatar(
      {Key? key,
      this.isFile = false,
      this.networkImage = false,
      this.fileImage,
      required this.radius,
      required this.image,
      this.assetImage = "assets/images/userdummy.png",
      this.borderColor = Colors.grey,
      this.borderWidth = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProfileAvatar(
      image,
      child: isFile == true
          ? Image.file(fileImage!, fit: BoxFit.cover)
          : networkImage == true
              ? CachedNetworkImage(
                  imageUrl: image,
                  placeholder: (context, url) => const AspectRatio(
                    aspectRatio: 1.6,
                    child: BlurHash(hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
                  ),
                )
              : Image.asset(assetImage!, fit: BoxFit.cover),
      errorWidget: (context, url, error) => Image.asset(assetImage!),
      placeHolder: (context, url) => const AspectRatio(
        aspectRatio: 1.6,
        child: BlurHash(hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
      ),
      radius: radius,
      borderColor: borderColor,
      borderWidth: borderWidth,
      imageFit: BoxFit.fitHeight,
      elevation: 0,
      cacheImage: true,
      showInitialTextAbovePicture: false,
    );
  }
}
