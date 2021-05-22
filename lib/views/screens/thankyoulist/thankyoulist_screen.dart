import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thankyoulist/models/thankyou_list_view_ui_model.dart';

import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/thankyoulist_repository.dart';
import 'package:thankyoulist/viewmodels/thankyoulist_view_model.dart';
import 'package:thankyoulist/views/common/thankyou_item.dart';
import 'package:thankyoulist/views/screens/edit_thankyou/edit_thankyou_screen.dart';
import 'package:thankyoulist/views/screens/my_page/my_page_screen.dart';

class ThankYouListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThankYouListViewModel>.value(
        value: ThankYouListViewModel(
          Provider.of<ThankYouListRepositoryImpl>(context, listen: false),
          Provider.of<AuthRepositoryImpl>(context, listen: false),
        ),
        child: Scaffold(
            appBar: AppBar(
              title: Text('Thank You List'),
              actions: [
                IconButton(
                  icon: Image.asset("assets/icons/account_circle_20.png"),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyPageScreen(),
                          fullscreenDialog: true
                      ),
                    );
                  },
                )
              ],
            ),
            body: ThankYouListView()
        )
    );
  }
}

class ThankYouListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThankYouListViewModel viewModel = Provider.of<ThankYouListViewModel>(context, listen: true);
    return ListView(
      children: viewModel.thankYouListWithDate.map((uiModel) {
        if (uiModel.sectionMonthYear != null) {
          return _sectionMonthYearView(uiModel.sectionMonthYear);
        }
        if (uiModel.thankYou != null) {
          return ThankYouItem(
            thankYou: uiModel.thankYou,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditThankYouScreen(uiModel.thankYou.id),
                    fullscreenDialog: true
                ),
              );
            },
          );
        }
      }).toList()
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
          fontSize: 16
        ))
    );
  }
}

