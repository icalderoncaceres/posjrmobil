import 'package:six_pos/features/counter/domain/models/counter.dart';

class CounterModel {
  int? _total;
  int? _limit;
  int? _offset;
  List<Counter>? _counter;

  CounterModel(
      {int? total, int? limit, int? offset, List<Counter>? counter}) {
    if (total != null) {
      _total = total;
    }
    if (limit != null) {
      _limit = limit;
    }
    if (offset != null) {
      _offset = offset;
    }
    if (counter != null) {
      _counter = counter;
    }
  }

  int? get total => _total;
  set total(int? total) => _total = total;
  int? get limit => _limit;
  set limit(int? limit) => _limit = limit;
  int? get offset => _offset;
  set offset(int? offset) => _offset = offset;
  List<Counter>? get counter => _counter;
  set counter(List<Counter>? counter) => _counter = counter;

  CounterModel.fromJson(Map<String, dynamic> json) {
    _total = json['total'];
    _limit = json['limit'];
    _offset = int.tryParse(json['offset'].toString());
    if (json['counters'] != null) {
      _counter = <Counter>[];
      json['counters'].forEach((v) {
        _counter!.add(new Counter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = _total;
    data['limit'] = _limit;
    data['offset'] = _offset;
    if (_counter != null) {
      data['counters'] = _counter!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

