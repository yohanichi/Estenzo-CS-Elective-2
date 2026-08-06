import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const InstagramScreen(),
    );
  }
}

class InstagramScreen extends StatelessWidget {
  const InstagramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                  "Instagram",
                  style: TextStyle(
                    fontFamily: "Billabong",
                    fontSize: 36,
                    color: Colors.black,
                  ),
                ),

                  Row(
                    children: const [
                      Icon(Icons.favorite_border, size: 28),
                      SizedBox(width: 18),
                      Icon(Icons.send_outlined, size: 28),
                    ],
                  )
                ],
              ),
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [

                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.pink,
                        width: 2,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Text(
                    "yohan4ne",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  const Icon(Icons.more_vert),
                ],
              ),
            ),


            Expanded(
  child: Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/images/example.jpg"),
        fit: BoxFit.cover,
      ),
    ),
  ),
),


            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: const [

                  Icon(Icons.favorite_border, size: 28),

                  SizedBox(width: 15),

                  Icon(Icons.mode_comment_outlined, size: 28),

                  SizedBox(width: 15),

                  Icon(Icons.send_outlined, size: 28),

                  Spacer(),

                  Icon(Icons.bookmark_border, size: 28),
                ],
              ),
            ),


            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "3 Likes",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 5),


            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "yohan4ne ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                "My first post.",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "#First   #Post   #IG   #Insta",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

            const Divider(height: 20),

            Padding(
              padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  bottom: 10),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: const [

                  Icon(Icons.home, size: 30),

                  Icon(Icons.search, size: 30),

                  Icon(Icons.add_box_outlined, size: 30),

                  Icon(Icons.video_library_outlined,
                      size: 30),

                  Icon(Icons.person_outline,
                      size: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}