import 'package:common/state/view_data_state.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:dependencies/flutter_screenutil/flutter_screenutil.dart';
import 'package:dependencies/intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:market/cubit/market_cubit.dart';

final priceFormatter = NumberFormat("#,##0.00", "en_US");

String formattedPrice(double price) {
  return priceFormatter.format(price);
}

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<MarketCubit, MarketState>(
          builder: (context, state) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    titleSpacing: 16.w,
                    title: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: 'Search Coin Pairs',
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 10.w, right: 5.w),
                                child: Icon(
                                  Icons.search,
                                ),
                              ),
                              prefixIconConstraints: BoxConstraints.loose(Size.infinite),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
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
                    toolbarHeight: MediaQuery.of(context).size.width > 600
                        ? MediaQuery.of(context).size.height / 3
                        : 120.h,
                    title: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Market',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey, thickness: 0.5),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Crypto',
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(6.r),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  'All',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Last Price',
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40.w,
                                  ),
                                  Text(
                                    '24h Chg%',
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
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
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
                                        Image.network(ticker.imageUrl, width: 23.w),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ticker.symbol.replaceAll('USDT', ''),
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              ticker.name,
                                              style: TextStyle(
                                                fontSize: 10.sp,
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
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '\$${formattedPrice(ticker.price)}',
                                              style: TextStyle(
                                                fontSize: 10.sp,
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
                                            padding: EdgeInsets.symmetric(vertical: 6.h),
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
