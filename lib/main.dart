import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const HalisahaApp());
}

class HalisahaApp extends StatelessWidget {
  const HalisahaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Halısaha Manager',
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.green,
        ),
      ),
      home: const AnaSayfa(),
    );
  }
}

class Oyuncu {
  String isim;
  String mevki;
  int puan;

  Oyuncu(this.isim, this.mevki, this.puan);
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  List<Oyuncu> oyuncular = [];

  void oyuncuEkle(String isim, String mevki, int puan) {
    setState(() {
      oyuncular.add(Oyuncu(isim, mevki, puan));
    });
  }

  void takimOlustur() {
    if (oyuncular.length < 2) return;

    List<Oyuncu> sirali = List.from(oyuncular);
    sirali.sort((a, b) => b.puan.compareTo(a.puan));

    List<Oyuncu> takimA = [];
    List<Oyuncu> takimB = [];

    for (int i = 0; i < sirali.length; i++) {
      if (i % 2 == 0) {
        takimA.add(sirali[i]);
      } else {
        takimB.add(sirali[i]);
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TakimEkrani(takimA: takimA, takimB: takimB),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Halısaha Manager"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => OyuncuDialog(onSave: oyuncuEkle),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: takimOlustur,
            child: const Text("Dengeli Takım Oluştur"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: oyuncular.length,
              itemBuilder: (context, index) {
                final o = oyuncular[index];
                return Card(
                  child: ListTile(
                    title: Text(o.isim),
                    subtitle: Text("${o.mevki} - Güç: ${o.puan}"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OyuncuDialog extends StatefulWidget {
  final Function(String, String, int) onSave;

  const OyuncuDialog({super.key, required this.onSave});

  @override
  State<OyuncuDialog> createState() => _OyuncuDialogState();
}

class _OyuncuDialogState extends State<OyuncuDialog> {
  final isimController = TextEditingController();
  String mevki = "Orta Saha";
  int puan = 50;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Oyuncu Ekle"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: isimController,
            decoration: const InputDecoration(labelText: "İsim"),
          ),
          DropdownButton<String>(
            value: mevki,
            items: const [
              DropdownMenuItem(value: "Kaleci", child: Text("Kaleci")),
              DropdownMenuItem(value: "Defans", child: Text("Defans")),
              DropdownMenuItem(value: "Orta Saha", child: Text("Orta Saha")),
              DropdownMenuItem(value: "Forvet", child: Text("Forvet")),
            ],
            onChanged: (value) {
              setState(() {
                mevki = value!;
              });
            },
          ),
          Slider(
            value: puan.toDouble(),
            min: 0,
            max: 100,
            divisions: 100,
            label: puan.toString(),
            onChanged: (value) {
              setState(() {
                puan = value.toInt();
              });
            },
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            widget.onSave(isimController.text, mevki, puan);
            Navigator.pop(context);
          },
          child: const Text("Kaydet"),
        ),
      ],
    );
  }
}

class TakimEkrani extends StatelessWidget {
  final List<Oyuncu> takimA;
  final List<Oyuncu> takimB;

  const TakimEkrani(
      {super.key, required this.takimA, required this.takimB});

  int toplamPuan(List<Oyuncu> takim) {
    return takim.fold(0, (toplam, o) => toplam + o.puan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Takımlar")),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text("Takım A"),
                Text("Toplam: ${toplamPuan(takimA)}"),
                ...takimA.map((o) => Text(o.isim)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text("Takım B"),
                Text("Toplam: ${toplamPuan(takimB)}"),
                ...takimB.map((o) => Text(o.isim)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
