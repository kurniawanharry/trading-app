import 'package:common/state/view_data_state.dart';
import 'package:commons_domain/data/models/markets/response/response.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/flutter_screenutil/flutter_screenutil.dart';
import 'package:dependencies/intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trade/ui/components/numpad_screen.dart';
import 'package:dependencies/auto_text_size/auto_text_size.dart';
import 'package:trade/ui/components/point_shape.dart';

import '../cubit/cubit.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({super.key});

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  String input = '0';
  FocusNode focus = FocusNode();

  TextEditingController priceController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  int _selectedSegment = 0;
  bool _isBuy = true;

  onKeyTap(String key) {
    setState(() {
      if (key == 'DEL') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }

        if (input.isEmpty) {
          input = '0';
        }
      } else {
        input += key;

        if (input.startsWith('0')) {
          input = input.replaceAll('0', '');
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          currentFocus.focusedChild!.unfocus();
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerHeight: 0,
              tabs: [
                Tab(
                  text: 'Spot',
                ),
                Tab(
                  text: 'Buy/Sell',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _spot(),
              _buySell(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _spot() {
    return MultiBlocListener(
      listeners: [
        BlocListener<TradeCubit, TradeState>(
          listenWhen: (previous, current) {
            return previous.selectedMarketState.data?.symbol !=
                    current.selectedMarketState.data?.symbol ||
                priceController.text.isEmpty;
          },
          listener: (context, state) async {
            context
                .read<TradeFormCubit>()
                .updatePrice(state.selectedMarketState.data?.lastPrice ?? 0);
            priceController.text =
                (state.selectedMarketState.data?.lastPrice ?? 0).toStringAsFixed(2);
          },
        ),
        BlocListener<TradeCubit, TradeState>(
          listenWhen: (previous, current) =>
              previous.coinGeckoCoin?.id != current.coinGeckoCoin?.id,
          listener: (context, state) async => context.read<TradeFormCubit>().reset(),
        ),
        BlocListener<TradeFormCubit, TradeFormState>(
          listenWhen: (previous, current) => previous.total != current.total,
          listener: (context, state) {
            if (state.total == 0) {
              totalController.text = '';
              return;
            }
            if (state.total != null) {
              totalController.text = state.total!.toStringAsFixed(2);
            }
          },
        ),
        BlocListener<TradeFormCubit, TradeFormState>(
          listenWhen: (previous, current) => previous.amount != current.amount,
          listener: (context, state) {
            if (state.amount == 0) {
              amountController.text = '';
              return;
            }
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<TradeCubit, TradeState>(
              builder: (context, state) {
                final selected = state.selectedMarketState.data;
                final symbol = state.coinGeckoCoin?.symbol.toUpperCase();
                if (selected == null) return Text('Loading');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return BlocProvider.value(
                                value: BlocProvider.of<TradeCubit>(context),
                                child: BlocBuilder<TradeCubit, TradeState>(
                                  builder: (context, state) {
                                    var list = state.coinList?.data ?? [];
                                    var currentCoin = state.coinGeckoCoin;
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: list.map(
                                        (coin) {
                                          return ListTile(
                                            title: Text(coin.name),
                                            subtitle: Text(coin.symbol),
                                            leading: Image.network(
                                              coin.image,
                                              height: 35,
                                              width: 35,
                                            ),
                                            trailing: Radio<CoinGeckoCoin>(
                                              value: coin,
                                              groupValue: currentCoin,
                                              onChanged: (_) {
                                                Navigator.pop(context, coin);
                                              },
                                            ),
                                            onTap: () => Navigator.pop(context, coin),
                                          );
                                        },
                                      ).toList(),
                                    );
                                  },
                                ),
                              );
                            },
                          ).then(
                            (value) {
                              if (value is CoinGeckoCoin) {
                                // ignore: use_build_context_synchronously
                                context.read<TradeCubit>().updateCoin(value);
                              }
                            },
                          ),
                          child: Row(
                            children: [
                              Text(
                                '$symbol/USDT',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                              )
                            ],
                          ),
                        ),
                        Text(selected.lastPrice.toStringAsFixed(2)),
                      ],
                    ),
                    Text(
                      '${selected.priceChangePercent >= 0 ? '+' : ''}${selected.priceChangePercent.toStringAsFixed(2)}％',
                      style: TextStyle(
                          color: selected.priceChangePercent >= 0
                              ? Colors.greenAccent.shade700
                              : Colors.pinkAccent.shade700),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 1,
                  color: Colors.grey.shade900,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isBuy = true;
                        });
                      },
                      child: Material(
                        color: _isBuy ? Colors.green : Colors.transparent,
                        shape: PointedRightShapeBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text('Buy')),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isBuy = false;
                        });
                      },
                      child: Material(
                        color: !_isBuy ? Colors.red : Colors.transparent,
                        shape: PointedLeftShapeBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text('Sell')),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Price (USDT)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5.h),
            BlocBuilder<TradeFormCubit, TradeFormState>(
              builder: (context, state) {
                return Container(
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      // IconButton(
                      //   visualDensity: VisualDensity.comfortable,
                      //   onPressed: () => context.read<TradeFormCubit>().decreasePrice(),
                      //   icon: Icon(
                      //     Icons.remove,
                      //   ),
                      // ),
                      BlocBuilder<TradeCubit, TradeState>(
                        builder: (context, state) {
                          return Flexible(
                            child: TextField(
                              key: PageStorageKey('priceTextField'),
                              controller: priceController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                PriceInputFormatter(
                                    decimalRange: getAssetPrecision(
                                        state.coinGeckoCoin?.symbol.toUpperCase() ?? '')),
                              ],
                              decoration: InputDecoration(
                                constraints: BoxConstraints(),
                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                                prefixIconConstraints: BoxConstraints(),
                                suffixIconConstraints: BoxConstraints(),
                                isDense: true,
                                border: InputBorder.none,
                                filled: false,
                                hintText: 'Price (USDT)',
                              ),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  context.read<TradeFormCubit>().updatePrice(0);
                                  return;
                                }
                                context.read<TradeFormCubit>().updatePrice(double.parse(value));
                              },
                            ),
                          );
                        },
                      ),
                      // IconButton(
                      //   visualDensity: VisualDensity.comfortable,
                      //   onPressed: () => context.read<TradeFormCubit>().increasePrice(),
                      //   icon: Icon(
                      //     Icons.add,
                      //   ),
                      // ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              'Amount',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5.h),
            BlocBuilder<TradeFormCubit, TradeFormState>(
              builder: (context, state) {
                return Container(
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      // IconButton(
                      //   visualDensity: VisualDensity.comfortable,
                      //   onPressed: () =>
                      //       context.read<TradeFormCubit>().decreaseAmount(step: 0.0001),
                      //   icon: Icon(
                      //     Icons.remove,
                      //   ),
                      // ),
                      BlocBuilder<TradeCubit, TradeState>(
                        builder: (context, state) {
                          final symbol = state.coinGeckoCoin?.symbol.toUpperCase();
                          return Flexible(
                            child: TextField(
                              controller: amountController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                constraints: BoxConstraints(),
                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                                prefixIconConstraints: BoxConstraints(),
                                suffixIconConstraints: BoxConstraints(),
                                isDense: true,
                                border: InputBorder.none,
                                filled: false,
                                hintText: "Amount ($symbol)",
                              ),
                              inputFormatters: [
                                AmountInputFormatter(
                                    decimalRange: getAssetPrecision(
                                        state.coinGeckoCoin?.symbol.toUpperCase() ?? '')),
                              ],
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  context.read<TradeFormCubit>().updateAmount(0);
                                  return;
                                }
                                context.read<TradeFormCubit>().updateAmount(double.parse(value));
                              },
                            ),
                          );
                        },
                      ),
                      // IconButton(
                      //   visualDensity: VisualDensity.comfortable,
                      //   onPressed: () =>
                      //       context.read<TradeFormCubit>().increaseAmount(step: 0.0001),
                      //   icon: Icon(
                      //     Icons.add,
                      //   ),
                      // ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              'Total (USDT)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(10),
              ),
              child: BlocBuilder<TradeCubit, TradeState>(
                builder: (context, state) {
                  return TextField(
                    controller: totalController,
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      DynamicInputFormatter(
                          decimalRange:
                              getAssetPrecision(state.coinGeckoCoin?.symbol.toUpperCase() ?? '')),
                    ],
                    decoration: InputDecoration(
                      constraints: BoxConstraints(),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      prefixIconConstraints: BoxConstraints(),
                      suffixIconConstraints: BoxConstraints(),
                      isDense: true,
                      border: InputBorder.none,
                      filled: false,
                      hintText: "Total (USDT)",
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        context.read<TradeFormCubit>().updateAmount(0);
                        context.read<TradeFormCubit>().updateTotal(0);
                        return;
                      }
                      context.read<TradeFormCubit>().updateTotal(double.parse(value));
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            BlocBuilder<TradeCubit, TradeState>(
              builder: (context, state) {
                final symbol = state.coinGeckoCoin?.symbol.toUpperCase();
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isBuy ? Colors.green : Colors.red,
                    foregroundColor: Colors.white,
                    fixedSize: Size(double.maxFinite, 44),
                  ),
                  onPressed: () => showConfirmationDialog(
                    context: context,
                    title: 'Beli $symbol',
                    content: 'ini itu',
                    onConfirmed: () => context.read<TradeCubit>().submit(
                          isBuy: _isBuy,
                          price: double.tryParse(priceController.text),
                          amount: double.tryParse(amountController.text),
                        ),
                  ).then(
                    (value) {
                      if (value is bool) {
                        if (value) {
                          showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Success"),
                              content: const Text("Your simulated trade has been submitted!"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                          // ignore: use_build_context_synchronously
                          context.read<TradeFormCubit>().reset();
                        }
                      }
                    },
                  ),
                  child: Text('${_isBuy ? 'Buy' : 'Sell'} $symbol'),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buySell() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: CupertinoSlidingSegmentedControl<int>(
            children: {
              0: Text(
                "Buy",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _selectedSegment == 0 ? Colors.black : Colors.white,
                ),
              ),
              1: Text(
                "Sell",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _selectedSegment == 1 ? Colors.black : Colors.white,
                ),
              ),
            },
            groupValue: _selectedSegment,
            onValueChanged: (int? value) {
              if (value != null) {
                setState(() {
                  _selectedSegment = value;
                });
              }
            },
            thumbColor: Color(0xFFFFD700),
            padding: EdgeInsetsGeometry.all(3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Flexible(
                child: AutoSizeText(
                  formatThousand(int.parse(input)),
                  style: TextStyle(fontSize: 50),
                  maxLines: 1,
                ),
              ),
              SizedBox(width: 10),
              Row(
                children: [
                  Text('IDR'),
                  Icon(Icons.arrow_drop_down_rounded),
                ],
              ),
            ],
          ),
        ),
        Spacer(),
        BlocBuilder<TradeCubit, TradeState>(
          builder: (context, state) {
            var loading = state.coinList?.status == ViewState.loading;
            if (loading) {
              return LinearProgressIndicator();
            }
            return Column(
              children: [
                ListTile(
                  leading: Image.network(
                    state.coinGeckoCoin?.image ?? '',
                    height: 40,
                    width: 40,
                  ),
                  title: Text(
                    _selectedSegment == 0 ? 'Buy' : 'Sell',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  subtitle: Text('${state.coinGeckoCoin?.symbol.toUpperCase()}'),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                  ),
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return BlocProvider.value(
                        value: BlocProvider.of<TradeCubit>(context),
                        child: BlocBuilder<TradeCubit, TradeState>(
                          builder: (context, state) {
                            var list = state.coinList?.data ?? [];
                            var currentCoin = state.coinGeckoCoin;
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: list.map(
                                (coin) {
                                  return ListTile(
                                    title: Text(coin.name),
                                    subtitle: Text(coin.symbol),
                                    leading: Image.network(
                                      coin.image,
                                      height: 35,
                                      width: 35,
                                    ),
                                    trailing: Radio(
                                      value: currentCoin,
                                      groupValue: coin,
                                      onChanged: (value) {},
                                    ),
                                  );
                                },
                              ).toList(),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  splashColor: Colors.transparent,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(double.maxFinite, 50),
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                    onPressed: () {},
                    child: Text('Preview Order'),
                  ),
                ),
              ],
            );
          },
        ),
        NumpadScreen(
          onKeyTap: (p0) => onKeyTap(p0),
        ),
      ],
    );
  }
}

String formatThousand(int amount) {
  return NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(amount);
}

Future showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onConfirmed,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap a button
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(), // Cancel
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Close dialog
              onConfirmed(); // Run confirmation logic
            },
            child: Text('Confirm'),
          ),
        ],
      );
    },
  );
}

class DynamicInputFormatter extends TextInputFormatter {
  final int decimalRange;
  DynamicInputFormatter({required this.decimalRange}) : assert(decimalRange >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    if (text == '.') {
      return TextEditingValue(
        text: '0.',
        selection: const TextSelection.collapsed(offset: 2),
      );
    }

    final sanitized = _sanitize(text);
    final regex = RegExp(r'^\d*\.?\d{0,' + decimalRange.toString() + r'}$');
    if (!regex.hasMatch(sanitized)) {
      return oldValue;
    }

    final stripped = _stripLeadingZeros(sanitized);
    return TextEditingValue(
      text: stripped,
      selection: TextSelection.collapsed(offset: stripped.length),
    );
  }

  String _sanitize(String input) {
    final parts = input.split('.');
    final before = parts[0].replaceAll(RegExp(r'[^0-9]'), '');
    final after = parts.length > 1 ? parts[1].replaceAll(RegExp(r'[^0-9]'), '') : '';
    return after.isEmpty ? before : '$before.$after';
  }

  String _stripLeadingZeros(String input) {
    if (input.startsWith('0') && input.length > 1 && !input.startsWith('0.')) {
      return input.replaceFirst(RegExp(r'^0+'), '');
    }
    return input;
  }
}

class PriceInputFormatter extends TextInputFormatter {
  final int decimalRange;

  PriceInputFormatter({this.decimalRange = 8}) : assert(decimalRange >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    // Empty or just "." → allow "0."
    if (newText == '.') {
      return TextEditingValue(
        text: '0.',
        selection: TextSelection.collapsed(offset: 2),
      );
    }

    // Regex to allow only valid decimal numbers
    final regex = RegExp(r'^\d*\.?\d{0,' + decimalRange.toString() + r'}$');

    // Reject input if it doesn't match valid pattern
    if (!regex.hasMatch(newText)) {
      return oldValue;
    }

    return newValue;
  }
}

class TotalInputFormatter extends TextInputFormatter {
  final int decimalRange;

  TotalInputFormatter({this.decimalRange = 2}) : assert(decimalRange >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;

    if (newText == '.') {
      return TextEditingValue(
        text: '0.',
        selection: const TextSelection.collapsed(offset: 2),
      );
    }

    final sanitized = _sanitizeInput(newText);

    final regex = RegExp(r'^\d*\.?\d{0,' + decimalRange.toString() + r'}$');
    if (!regex.hasMatch(sanitized)) {
      return oldValue;
    }

    final formatted = _stripLeadingZeros(sanitized);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _sanitizeInput(String input) {
    final dotIndex = input.indexOf('.');
    if (dotIndex >= 0) {
      final beforeDot = input.substring(0, dotIndex).replaceAll(RegExp(r'[^0-9]'), '');
      final afterDot = input.substring(dotIndex + 1).replaceAll(RegExp(r'[^0-9]'), '');
      return '$beforeDot.$afterDot';
    } else {
      return input.replaceAll(RegExp(r'[^0-9]'), '');
    }
  }

  String _stripLeadingZeros(String input) {
    if (input.startsWith('0') && input.length > 1 && !input.startsWith('0.')) {
      return input.replaceFirst(RegExp(r'^0+'), '');
    }
    return input;
  }
}

class AmountInputFormatter extends TextInputFormatter {
  final int decimalRange;

  AmountInputFormatter({this.decimalRange = 8}) : assert(decimalRange >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text;

    if (newText == '.') {
      return TextEditingValue(
        text: '0.',
        selection: const TextSelection.collapsed(offset: 2),
      );
    }

    // Allow only digits and one "."
    final sanitized = _sanitizeInput(newText);

    // Limit decimal places
    final regex = RegExp(r'^\d*\.?\d{0,' + decimalRange.toString() + r'}$');
    if (!regex.hasMatch(sanitized)) {
      return oldValue;
    }

    final formatted = _stripLeadingZeros(sanitized);
    final offset = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: offset),
    );
  }

  String _sanitizeInput(String input) {
    int dotIndex = input.indexOf('.');
    if (dotIndex >= 0) {
      final beforeDot = input.substring(0, dotIndex).replaceAll(RegExp(r'[^0-9]'), '');
      final afterDot = input.substring(dotIndex + 1).replaceAll(RegExp(r'[^0-9]'), '');
      return '$beforeDot.$afterDot';
    } else {
      return input.replaceAll(RegExp(r'[^0-9]'), '');
    }
  }

  String _stripLeadingZeros(String input) {
    if (input.startsWith('0') && input.length > 1 && !input.startsWith('0.')) {
      return input.replaceFirst(RegExp(r'^0+'), '');
    }
    return input;
  }
}

// TextInputFormatter getFormatterByAsset(String symbol) {
//   final map = {
//     'USDT': 2,
//     'BTC': 8,
//     'BNB': 4,
//     'ETH': 8,
//   };
//   final precision = map[symbol] ?? 8;
//   return TotalInputFormatter(decimalRange: precision);
// }

int getAssetPrecision(String symbol) {
  switch (symbol) {
    case 'BTC':
      return 6;
    case 'ETH':
      return 8;
    case 'SOL':
      return 8;
    case 'DOGE':
      return 8;
    case 'ADA':
      return 8;
    case 'TRX':
      return 6;
    default:
      return 8;
  }
}
