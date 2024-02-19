import 'package:flutter/material.dart';

void showImageSheetViewer(context, String image) {
  showModalBottomSheet(
    showDragHandle: true,
    useSafeArea: true,
    //constraints: const BoxConstraints.expand(),
    backgroundColor: Colors.grey,
    context: context,
    enableDrag: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        side: BorderSide(
          color: Colors.cyan,
          width: 1,
        )),
    builder: (context) => ImageSheetViewer(image: image),
  );
}


class ImageSheetViewer extends StatelessWidget {
  const ImageSheetViewer({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                size: 30,
                //color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                size: 30,
                //color: Colors.white,
              ),
            ),
          ],
        ),
        Image(
          image: NetworkImage(image),
          // loadingBuilder: (context, child, loadingProgress) => const CircularProgressIndicator(),
          // errorBuilder: (context, error, stackTrace) => SvgPicture.asset(
          //   'error imag.svg',
          // ),
        ),
      ],
    );
  }
}

