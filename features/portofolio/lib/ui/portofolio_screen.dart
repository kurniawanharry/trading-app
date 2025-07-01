import 'package:common/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/flutter_screenutil/flutter_screenutil.dart';
import 'package:dependencies/intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:portofolio/cubit/porto_cubit.dart';
import 'package:portofolio/ui/components/portofolio_tile.dart';
import 'package:trade/cubit/cubit.dart';

class PortofolioScreen extends StatelessWidget {
  const PortofolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TradeCubit, TradeState>(
          listenWhen: (previous, current) {
            return current.tradeSubmit.data == true;
          },
          listener: (context, state) {
            context.read<PortoCubit>().loadPortfolio();
            context.read<TradeCubit>().reset();
          },
        ),
        BlocListener<PortoCubit, PortoState>(
          listenWhen: (previous, current) => current.marketState.status == ViewState.noData,
          listener: (context, state) async {
            context.read<PortoCubit>().loadPortfolio();
          },
        ),
      ],
      child: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerHeight: 0,
              tabs: [
                Text('Overview'),
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Est. Total Value',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    BlocBuilder<PortoCubit, PortoState>(
                      builder: (context, state) {
                        var total = state.totalPortfolioValue;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatNumber(total),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Row(
                              children: [
                                Text('IDR'),
                                Icon(Icons.arrow_drop_down_rounded),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(double.maxFinite, 44),
                  ),
                  onPressed: null,
                  child: Text('Add Funds'),
                ),
              ),
              Expanded(
                child: BlocBuilder<PortoCubit, PortoState>(
                  builder: (context, state) {
                    var list = state.marketState.data;
                    if (state.marketState.status == ViewState.loading) {
                      return Center(child: Text('Loading...'));
                    }
                    if (list?.isEmpty ?? true) {
                      return Center(child: Text('Belum ada data!'));
                    }
                    return ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(height: 10),
                      itemCount: list?.length ?? 0,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      itemBuilder: (context, index) {
                        var data = list?[index];
                        return PortfolioTile(
                          todayPnl: data?.todayPnL ?? 0,
                          avgPrice: data?.avgBuyPrice ?? 0,
                          imageUrl: data?.image ?? '',
                          name: data?.name ?? '',
                          symbol: data?.symbol ?? '',
                          quantity: data?.totalQuantity ?? 0,
                          value: data?.totalValue ?? 0,
                          pnl: data?.unrealizedPnL ?? 0,
                          lastPrice: data?.currentPrice ?? 0,
                        );
                      },
                    );
                  },
                ),
              ),
              // BlocBuilder<MarketCubit, MarketState>(
              //   builder: (context, state) {
              //     return Column(
              //       children: [
              //         ...state.marketState.data!.values.map(
              //           (ticker) => Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Row(
              //                 children: [
              //                   Image.network(ticker.imageUrl, width: 32),
              //                   SizedBox(width: 10),
              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         ticker.symbol.replaceAll('USDT', ''),
              //                         style: TextStyle(
              //                           fontSize: 14.sp,
              //                           fontWeight: FontWeight.bold,
              //                         ),
              //                       ),
              //                       Text(
              //                         ticker.name,
              //                         style: TextStyle(
              //                           fontSize: 12.sp,
              //                           color: Colors.grey,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ],
              //               ),
              //               Row(
              //                 children: [
              //                   Column(
              //                     children: [
              //                       Text(
              //                         formattedPrice(ticker.price),
              //                         style: TextStyle(
              //                           fontSize: 14.sp,
              //                           fontWeight: FontWeight.bold,
              //                         ),
              //                       ),
              //                       Text(
              //                         '\$${formattedPrice(ticker.price)}',
              //                         style: TextStyle(
              //                           fontSize: 12.sp,
              //                           color: Colors.grey,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                   SizedBox(width: 10),
              //                   IntrinsicWidth(
              //                     child: Container(
              //                       alignment: Alignment.center,
              //                       width: MediaQuery.of(context).size.width * 0.2,
              //                       padding: EdgeInsets.symmetric(vertical: 6),
              //                       decoration: BoxDecoration(
              //                         color: ticker.priceChangePercentage24h >= 0
              //                             ? Colors.greenAccent.shade700
              //                             : Colors.pinkAccent.shade700,
              //                         borderRadius: BorderRadius.circular(8),
              //                       ),
              //                       child: Text(
              //                         '${ticker.priceChangePercentage24h >= 0 ? '+' : ''}${ticker.priceChangePercentage24h.toStringAsFixed(2)}％',
              //                         style: TextStyle(
              //                           color: Colors.white,
              //                           fontSize: 12.sp,
              //                           fontWeight: FontWeight.w500,
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     );
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}

String formatNumber(double value) {
  final formatter = NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2);
  return formatter.format(value);
}
