
//
// final input = new File('a/csv/file.txt').openRead();
// final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();

class Stock {

  const Stock({
    required this.name,
    required this.ticker,
  });

  final String name;
  final int ticker;

  @override
  String toString() {
    return '$name ($ticker)';
  }
}
const List<Stock> countryOptions = <Stock>[
  Stock(name: '삼성전자', ticker: 30370000),
  Stock(name: '동국산업', ticker: 44579000),
  Stock(name: '에스에이엠티', ticker: 8600000),

];

// void _loadCSV() async {
//   final _rawData = await rootBundle.loadString("assets/stockdata.csv");
//   List<List<dynamic>> _listData =
//   const CsvToListConverter().convert(_rawData);
//   setState(() {
//     _data = _listData;
//   });
// }
//
// final input = new File("flutter_application_1/lib/stockdata.csv").openRead();
// final fields =  input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
//
