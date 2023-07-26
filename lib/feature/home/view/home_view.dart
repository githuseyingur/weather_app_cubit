import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/feature/home/viewmodel/home_cubit.dart';
import 'package:weather_app/feature/home/widget/home_app_bar.dart';
import 'package:weather_app/product/extension/responsive/responsive.dart';
import 'package:weather_app/product/utility/loading/loading_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      if (state is HomeInitial || state is HomeLoading) {
        return const LoadingView();
      } else if (state is HomeItemLoaded) {
        return NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
              final notificationContext = notification.context;
              if (notificationContext != null && !context.read<HomeCubit>().isPagingDone) {
                notificationContext.read<HomeCubit>().fetchItem();
              }
            }
            return true;
          },
          child: Scaffold(
            appBar: HomeAppBar(
              context: context,
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                height: context.dynamicHeight(0.85),
                child: ListView.builder(
                  itemCount: context.read<HomeCubit>().allItems.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: context.extremeAllPadding,
                      padding: context.extremeAllPadding,
                      decoration: const BoxDecoration(color: AppColors.button, borderRadius: BorderRadi.lowCircular),
                      height: context.dynamicHeight(0.3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            index.toString(),
                            style: const TextStyle(color: AppColors.mainPrimary, fontSize: 35),
                          ),
                          Text(
                            currentUser!.username.toString(),
                            style: const TextStyle(color: AppColors.mainPrimary, fontSize: 12),
                          ),
                          Text(
                            context.read<HomeCubit>().allItems[index].price.toString(),
                            style: const TextStyle(color: AppColors.mainPrimary, fontSize: 16),
                          ),
                          Text(
                            context.read<HomeCubit>().allItems[index].name.toString(),
                            style: const TextStyle(color: AppColors.mainPrimary, fontSize: 25),
                          )
                          // Text(
                          //   context
                          //       .read<HomeCubit>()
                          //       .allItems[index]
                          //       .tourData
                          //       .tourFeatures[0]
                          //       .toString(),
                          //   style: TextStyle(
                          //       color: AppColors.mainPrimary, fontSize: 35),
                          //),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }
    });
  }
}
