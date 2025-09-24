import 'package:flutter/material.dart';
import 'quote.dart';
import 'quote_card.dart';

void main() {
  runApp(MaterialApp(home: const QuoteList()));
}

class QuoteList extends StatefulWidget {
  const QuoteList({super.key});

  @override
  State<QuoteList> createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  List<Quote> quotes = [
    Quote(
      text: 'Be yourself everyone else is already taken',
      author: 'Oscar Wild',
    ),
    Quote(
      text: 'I have nothing to declare except my genius',
      author: 'Oscar Wild',
    ),
    Quote(
      text: 'The truth is rarely pure and never simple',
      author: 'Oscar Wild',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Awesome Quotes'),
        centerTitle: true,
        backgroundColor: Colors.grey[400],
      ),
      body: Column(
        children: quotes.map((quote) => QuoteCard(quote: quote)).toList(),
      ),
    );
  }
}
