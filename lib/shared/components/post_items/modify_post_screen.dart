import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_link/models/post_model.dart';
import '../../styles/icons_broken.dart';
import '../constants.dart';

Widget modifyPostItem(
    {context, required String text, required PostModel postModel}) {
  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 10.0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, right: 2, bottom: 4, top: 4),
          child: Row(
            children: [
              CircleAvatar(
                radius: 34.0,
                backgroundColor: Colors.deepPurple,
                child: CircleAvatar(
                  radius: 32.0,
                  backgroundImage: NetworkImage(postModel.profileImage),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      postModel.name,
                      style: GoogleFonts.aclonica(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(postModel.postDate)
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                child: IconButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(modifyPostTextNode);
                  },
                  icon: const Icon(
                    IconBroken.Edit,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        if (postModel.postImage != '')
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Image(
                image: NetworkImage(postModel.postImage!),
                fit: BoxFit.cover,
                height: 330,
                width: double.infinity,
              ),
              CircleAvatar(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    IconBroken.Edit,
                  ),
                ),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconBroken.Heart,
                  color: Colors.red,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconBroken.More_Square,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconBroken.Send,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
