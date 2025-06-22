import 'package:common/state/view_data_state.dart';
import 'package:commons_domain/data/models/markets/enum/markets_enum.dart';
import 'package:dependencies/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:market/cubit/market_cubit.dart';

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
            switch (state.marketState.status) {
              case ViewState.initial:
                return Text('Waiting for data...');
              case ViewState.loading:
                return SafeArea(
                  child: Center(child: CircularProgressIndicator()),
                );
              case ViewState.hasData:
                return ListView(
                  children: state.marketState.data!.values
                      .map((ticker) => ListTile(
                            title: Text(ticker.name),
                            subtitle: Text(ticker.symbol),
                            trailing: Text('\$${ticker.price.toStringAsFixed(2)}'),
                            leading: Image.network(ticker.imageUrl, width: 32),
                          ))
                      .toList(),
                );
              case ViewState.error:
                return Text('Error: ${state.marketState.message}');
              default:
                return const Text('Unknown state');
            }
            // return CustomScrollView(
            //   slivers: [
            //     SliverAppBar(
            //       title: Row(
            //         children: [
            //           Flexible(
            //             child: TextField(
            //               enabled: false,
            //               decoration: InputDecoration(
            //                 hintText: 'Search Coin Pairs',
            //                 prefixIcon: Padding(
            //                   padding: const EdgeInsets.only(left: 10, right: 5),
            //                   child: Icon(
            //                     Icons.search,
            //                   ),
            //                 ),
            //                 prefixIconConstraints: BoxConstraints.loose(Size.infinite),
            //               ),
            //             ),
            //           ),
            //           SizedBox(width: 10),
            //           Icon(Icons.more_horiz_outlined)
            //         ],
            //       ),
            //       surfaceTintColor: Color(0xFF121212),
            //       pinned: false,
            //       floating: true,
            //     ),
            //     SliverList(delegate: SliverChildBuilderDelegate(
            //       (context, index) {
            //         return Container(
            //           child: Text('$index'),
            //         );
            //       },
            //     ))
            //   ],
            // );
          },
        ),
      ),
    );
  }
}
