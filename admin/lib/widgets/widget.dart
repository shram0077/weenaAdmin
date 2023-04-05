import 'package:admin/Constant/constant.dart';
import 'package:flutter/material.dart';

circularProgressIndicator() {
  return CircularProgressIndicator(
    color: moviePageColor,
    backgroundColor: whiteColor,
  );
}

isloadingComments(context) {
  double width = MediaQuery.of(context).size.width;

  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: unColor,
            ),
          ),
          GestureDetector(
            onLongPress: () {},
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Container(
                            width: 55,
                            height: 20,
                            decoration: BoxDecoration(
                                color: unColor,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 45,
                            height: 20,
                            decoration: BoxDecoration(
                                color: unColor,
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ],
                      )),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    color: const Color.fromARGB(255, 191, 191, 191)
                        .withOpacity(.3),
                    height: 0.5,
                    width: width / 1.5,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Container(
                    width: width / 1.5,
                    height: 28,
                    decoration: BoxDecoration(
                        color: unColor, borderRadius: BorderRadius.circular(5)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 35,
                        height: 20,
                        decoration: BoxDecoration(
                            color: unColor,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 35,
                        height: 20,
                        decoration: BoxDecoration(
                            color: unColor,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ));
}
