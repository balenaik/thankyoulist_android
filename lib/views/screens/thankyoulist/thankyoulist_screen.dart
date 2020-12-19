import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/thankyoulist_repository.dart';
import 'package:thankyoulist/viewmodels/thankyoulist_view_model.dart';
import 'package:thankyoulist/views/common/thankyou_item.dart';

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
        if (uiModel.sectionDate != null) {
          return _dateSectionView(uiModel.sectionDate);
        }
        if (uiModel.thankYou != null) {
          return ThankYouItem(thankYou: uiModel.thankYou);
        }
      }).toList()
    );
  }
  
  Widget _dateSectionView(DateTime date) {
    return Text(date.toIso8601String());
  }
}

