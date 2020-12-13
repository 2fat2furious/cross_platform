import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cross_platform/data/constants.dart';
import 'package:cross_platform/domain/models/auth_state.dart';
import 'package:cross_platform/domain/models/user.dart';
import 'package:cross_platform/pages/home/home_bloc.dart';

class HomeUserProfile extends StatelessWidget {
  const HomeUserProfile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);

    return Card(
      color: Colors.black.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RxStreamBuilder<AuthenticationState>(
          stream: homeBloc.authState$,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final user = snapshot.data.userAndToken?.user;
            return user == null
                ? _buildUnauthenticated(context)
                : _buildProfile(user, homeBloc);
          },
        ),
      ),
    );
  }

  Widget _buildProfile(User user, HomeBloc homeBloc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: Text(
              "User: "+ user.login,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnauthenticated(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              strokeWidth: 2,
            ),
          ),
          Expanded(
            child: Text(
              'Loging out...',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _pickAndUploadImage(HomeBloc homeBloc) async {
    final imageFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 720.0,
      maxHeight: 720.0,
    );
    if (imageFile == null) {
      return;
    }
    homeBloc.changeAvatar(File(imageFile.path));
  }
}
