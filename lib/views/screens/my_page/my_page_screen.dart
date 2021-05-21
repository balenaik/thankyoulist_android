import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/viewmodels/my_page_view_model.dart';

class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyPageViewModel>.value(
        value: MyPageViewModel(
          Provider.of<AuthRepositoryImpl>(context, listen: false),
        ),
        child: MyPageScreenContent()
    );
  }
}

class MyPageScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyPageViewModel viewModel = Provider.of<MyPageViewModel>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Account')
        ),
        backgroundColor: Colors.grey[200],
        body: Stack(
          children: <Widget>[
            ListView(
                children: <Widget>[
                ]
            ),
          ],
        )
    );
  }
}
