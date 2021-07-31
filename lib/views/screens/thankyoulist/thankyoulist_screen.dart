import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thankyoulist/app_colors.dart';
import 'package:thankyoulist/gen/assets.gen.dart';
import 'package:thankyoulist/extensions/list_extension.dart';
import 'package:thankyoulist/models/thankyou_list_view_ui_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/thankyoulist_repository.dart';
import 'package:thankyoulist/viewmodels/thankyoulist_view_model.dart';
import 'package:thankyoulist/views/common/remove_glowingover_scrollindicator_behavior.dart';
import 'package:thankyoulist/views/common/thankyou_item.dart';
import 'package:thankyoulist/views/screens/edit_thankyou/edit_thankyou_screen.dart';
import 'package:thankyoulist/views/screens/my_page/my_page_screen.dart';
import 'package:thankyoulist/views/themes/light_theme.dart';

class ThankYouListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThankYouListViewModel>.value(
        value: ThankYouListViewModel(
          Provider.of<ThankYouListRepositoryImpl>(context, listen: false),
          Provider.of<AuthRepositoryImpl>(context, listen: false),
        ),
        child: Scaffold(
            body: ThankYouListWithAppBar()
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
                        color: primaryColor[900],
                        fontWeight: FontWeight.bold
                    )
                ),
                centerTitle: true,
              ),
              shape: Border(bottom: BorderSide(color: AppColors.appBarBottomBorderColor)),
              elevation: 0,
              actions: [
                IconButton(
                  icon: Assets.icons.accountCircle20.image(color: Theme.of(context).primaryColor),
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
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => EditThankYouScreen(thankYou.id),
                      fullscreenDialog: true
                  ),
                );
                },
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
}

