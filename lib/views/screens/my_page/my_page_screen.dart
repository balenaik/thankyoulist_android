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
    return Scaffold(
        appBar: AppBar(
          title: Text('Account')
        ),
        backgroundColor: Colors.grey[200],
        body: Stack(
          children: <Widget>[
            ListView(
                children: <Widget>[
                  UserProfileWidget(),
                ]
            ),
          ],
        )
    );
  }
}

class UserProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyPageViewModel viewModel = Provider.of<MyPageViewModel>(context, listen: true);
    return Container(
      margin: EdgeInsets.fromLTRB(36.0, 28.0, 36.0, 20.0),
      child: Row(
          children: <Widget>[
            CircleAvatar(
                radius: 28,
                backgroundImage: viewModel.authUser != null
                    ? NetworkImage(viewModel.authUser.photoUrl)
                    : AssetImage("assets/icons/account_circle_20.png")
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                child: Column(
                  children: [
                    Text(
                        viewModel.authUser != null ? viewModel.authUser.displayName : "",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.left
                    ),
                    Text(
                        viewModel.authUser != null ? viewModel.authUser.email : "",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black54
                        ),
                        textAlign: TextAlign.left
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                )
            )
          ]),
    );
  }
}