import 'package:common/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/flutter_screenutil/flutter_screenutil.dart';
import 'package:dependencies/intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:market/cubit/market_cubit.dart';

final priceFormatter = NumberFormat("#,##0.00", "en_US");

String formattedPrice(double price) {
  return priceFormatter.format(price); // Example: 101980.74 → "101,980.74"
}

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<MarketCubit, MarketState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    title: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: 'Search Coin Pairs',
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 5),
                                child: Icon(
                                  Icons.search,
                                ),
                              ),
                              prefixIconConstraints: BoxConstraints.loose(Size.infinite),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.more_horiz_outlined)
                      ],
                    ),
                    surfaceTintColor: Color(0xFF0c0e12),
                    pinned: false,
                    floating: true,
                  ),
                ];
              },
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    titleSpacing: 0,
                    surfaceTintColor: Color(0xFF0c0e12),
                    pinned: true,
                    toolbarHeight: 140,
                    title: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Market',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey, thickness: 0.5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Crypto',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'All',
                                  style:
                                      Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Name',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Last Price',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  Text(
                                    '24h Chg%',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  switch (state.marketState.status) {
                    ViewState.initial => SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: Text('Waiting for data...'),
                          ),
                        ),
                      ),
                    ViewState.loading => SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    ViewState.hasData => SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate.fixed(
                            [
                              ...state.marketState.data!.values
                                  .map(
                                (ticker) => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.network(ticker.imageUrl, width: 32),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ticker.symbol.replaceAll('USDT', ''),
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              ticker.name,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              formattedPrice(ticker.price),
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '\$${formattedPrice(ticker.price)}',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 10),
                                        IntrinsicWidth(
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context).size.width * 0.2,
                                            padding: EdgeInsets.symmetric(vertical: 6),
                                            decoration: BoxDecoration(
                                              color: ticker.priceChangePercentage24h >= 0
                                                  ? Colors.greenAccent.shade700
                                                  : Colors.pinkAccent.shade700,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '${ticker.priceChangePercentage24h >= 0 ? '+' : ''}${ticker.priceChangePercentage24h.toStringAsFixed(2)}％',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                                  .fold(
                                [],
                                (prev, element) => [
                                  ...prev,
                                  ...[
                                    if (prev.isNotEmpty)
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                    element
                                  ]
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ViewState.error => Text('Error: ${state.marketState.message}'),
                    _ => const Text('Unknown state')
                  },
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
