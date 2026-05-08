import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// 這個 Provider 只存一個整數 (樓層)，預設為 null (沒有待辦事項)
final pendingNfcProvider = StateProvider<int?>((ref) => null);
