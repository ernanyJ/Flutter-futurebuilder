import 'package:flutter/material.dart';
import 'package:future_testing/repositories/post_repo.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  TextEditingController fieldController = TextEditingController();

  var repo = PostRepo();
  var tController = TextEditingController();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    RxInt number = 1.obs;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            height: 100,
            child: TextField(
              controller: tController,
            ),
          ),
          IconButton(
              onPressed: () {
                try {
                  number.value = int.parse(tController.text);
                } on FormatException {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Invalid number entered. Please enter an integer.'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.public_sharp)),
          infoCard(number)
        ],
      ),
    );
  }

  Card infoCard(RxInt number) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => FutureBuilder(
              future: repo.fetchPost(number.value),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Title: ${snapshot.data!.title}"),
                      Text("Post: ${snapshot.data!.body}"),
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const Text("error");
              })))),
    );
  }
}
