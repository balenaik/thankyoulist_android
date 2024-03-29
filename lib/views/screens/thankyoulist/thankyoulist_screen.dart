import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thankyoulist/app_colors.dart';
import 'package:thankyoulist/gen/assets.gen.dart';
import 'package:thankyoulist/extensions/list_extension.dart';
import 'package:thankyoulist/models/thankyou_list_view_ui_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/thankyou_repiository.dart';
import 'package:thankyoulist/repositories/thankyoulist_repository.dart';
import 'package:thankyoulist/status.dart';
import 'package:thankyoulist/viewmodels/thankyoulist_view_model.dart';
import 'package:thankyoulist/views/common/default_dialog.dart';
import 'package:thankyoulist/views/common/remove_glowingover_scrollindicator_behavior.dart';
import 'package:thankyoulist/views/common/thankyou_item.dart';
import 'package:thankyoulist/views/screens/edit_thankyou/edit_thankyou_screen.dart';
import 'package:thankyoulist/views/screens/my_page/my_page_screen.dart';

class ThankYouListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThankYouListViewModel>.value(
        value: ThankYouListViewModel(
          Provider.of<ThankYouListRepositoryImpl>(context, listen: false),
          Provider.of<ThankYouRepositoryImpl>(context, listen: false),
          Provider.of<AuthRepositoryImpl>(context, listen: false),
        ),
        child: Scaffold(
            body: Stack(
              children: [
                ThankYouListWithAppBar(),
                ThankYouListStatusHandler()
              ],
            )
        )
    );
  }
}

class ThankYouListWithAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
        behavior: RemoveGlowingOverScrollIndicatorBehavior(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                    'Thank You List',
                    style: TextStyle(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.bold
                    )
                ),
                centerTitle: true,
              ),
              shape: Border(bottom: BorderSide(color: AppColors.appBarBottomBorderColor)),
              elevation: 0,
              actions: [
                IconButton(
                  icon: Assets.icons.accountCircle20.image(color: AppColors.textColor),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyPageScreen(),
                          fullscreenDialog: true
                      ),
                    );
                  },
                )
              ],
              backgroundColor: Colors.white,
              floating: true,
            ),
            ThankYouListView()
          ],
        )
    );
  }
}

class ThankYouListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThankYouListViewModel viewModel = Provider.of<ThankYouListViewModel>(context, listen: true);
    if (viewModel.thankYouListWithDate.isEmpty) {
      return ThankYouListEmptyView();
    }
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          final uiModel = viewModel.thankYouListWithDate.get(index);
          if (uiModel == null) {
            return Container();
          }
          final sectionMonthYear = uiModel.sectionMonthYear;
          if (sectionMonthYear != null) {
            return _sectionMonthYearView(sectionMonthYear);
          }
          final thankYou = uiModel.thankYou;
          if (thankYou != null) {
            return ThankYouItem(
              thankYou: thankYou,
              onEditButtonPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => EditThankYouScreen(thankYou.id),
                      fullscreenDialog: true
                  ),
                );
                },
              onDeleteButtonPressed: () => _showDeleteDialog(context, thankYou.id),
            );
          }
          },
          childCount: viewModel.thankYouListWithDate.length
        )
    );
  }
  
  Widget _sectionMonthYearView(SectionMonthYearModel monthYear) {
    DateTime dateTime = DateTime.utc(monthYear.year, monthYear.month);
    DateFormat formatter = DateFormat('MMMM yyyy');
    String formatted = formatter.format(dateTime);
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 24.0
      ),
      child: Text(formatted,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600
        ))
    );
  }

  void _showDeleteDialog(BuildContext context, String thankYouId) {
    ThankYouListViewModel viewModel = Provider.of<ThankYouListViewModel>(context, listen: false);
    showDialog<DefaultDialog>(
        context: context,
        builder: (context) => DefaultDialog(
          'Delete Thank You',
          'Are you sure you want to delete this thank you?',
          positiveButtonTitle: 'Delete',
          onPositiveButtonPressed: () => viewModel.deleteThankYou(thankYouId),
          onNegativeButtonPressed: () {},
        )
    );
  }
}

class ThankYouListEmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 160,
                height: 160,
                child: Assets.images.listEmpty.image()
            ),
            SizedBox(height: 28),
            Text(
              'Welcome Aboard',
              style: TextStyle(
                  fontSize: 20,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This is your Thank You List.\nLet\'s start adding grateful thoughts!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textColor
              ),
            ),
          ]
      ),
    );
  }
}

class ThankYouListStatusHandler extends StatelessWidget {
  Widget? _showErrorDialog(BuildContext context, String title, String message) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      showDialog<DefaultDialog>(
          context: context,
          builder: (context) => DefaultDialog(
            title,
            message,
            onPositiveButtonPressed: () {},
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ThankYouListViewModel, Status>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        switch (status) {
          case ThankYouListStatus.deleteThankYouDeleting:
            return Container(
                decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.3)),
                child: Center(
                  child: CircularProgressIndicator(),
                )
            );
          case ThankYouListStatus.deleteThankYouFailed:
            _showErrorDialog(context, 'Error', 'Could not delete Thank You');
            break;
        }
        return Container();
      },
    );
  }
}