import 'package:flutter/material.dart';

class Bumbogo extends StatelessWidget {
  const Bumbogo({super.key});

  @override
  Widget build(BuildContext context) {
    var images = [
      'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Tom_Hanks_2014.jpg/200px-Tom_Hanks_2014.jpg', // Tom Hanks
      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Leonardo_DiCaprio_2014.jpg/200px-Leonardo_DiCaprio_2014.jpg', // Leonardo DiCaprio
      'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Taylor_Swift_2019_by_Glenn_Francis.jpg/200px-Taylor_Swift_2019_by_Glenn_Francis.jpg', // Taylor Swift
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Barack_Obama_2012.jpg/200px-Barack_Obama_2012.jpg', // Barack Obama
      'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Oprah_in_2014.jpg/200px-Oprah_in_2014.jpg', // Oprah Winfrey
      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/dc/Dwayne_Johnson_2014.jpg/200px-Dwayne_Johnson_2014.jpg', // Dwayne Johnson
      'https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Elon_Musk_Royal_Society.jpg/200px-Elon_Musk_Royal_Society.jpg', // Elon Musk
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Jennifer_Lawrence_2016.jpg/200px-Jennifer_Lawrence_2016.jpg', // Jennifer Lawrence
      'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Bill_Gates_2017.jpg/200px-Bill_Gates_2017.jpg', // Bill Gates
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Ryan_Reynolds_2016.jpg/200px-Ryan_Reynolds_2016.jpg', // Ryan Reynolds
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GRIDSCREEN',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: List.generate(10, (index) {
          return Image.network(images[index]);
        }),
      ),
    );
  }
}
