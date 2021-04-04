import 'package:flutter/material.dart';
import 'package:google_task/helpers/database_helper.dart';
import 'package:google_task/models/lists_model.dart';
import 'package:google_task/pages/creat_list_page.dart';
import 'package:google_task/pages/home_page.dart';
import 'package:google_task/res.dart';

class MenuBottomSheet extends StatefulWidget {
  @override
  _MenuBottomSheetState createState() => _MenuBottomSheetState();
}

class _MenuBottomSheetState extends State<MenuBottomSheet> {
  ImageProvider<Object> _userProfileImage;
  Future<List<Lists>> _listsList;
  static int _selectedListId;
  Lists selectedList;
  static int _listIsSelected = 0;
  // static var selectedIndex;

  @override
  void initState() {
    _updateListsList();
    super.initState();
  }

  _updateListsList() {
    // setState(() {
    _listsList = DatabaseHelper.instance.getListsList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(smallCornerRadius),
          topLeft: Radius.circular(smallCornerRadius),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _userInfoRow(), //TODO : how about login with Google Account
            _divider(),
            _listOfLists(), //TODO : must be a ListView.builder
            _divider(),
            _createNewList(), //TODO : check some added new list (modalbottomsheet height/scroll/etc)
            _divider(),
            _helpAndFeedback(), //TODO : must be a link
            _divider(),
            _opensourceLicenses(), //TODO : must be a link
            _divider(),
            _privacyPolicy(), //TODO : must be a link
          ],
        ),
      ),
    );
  }

  _divider() {
    return Divider(
      color: chipBorderColor,
      height: 0,
    );
  }

  _userInfoRow() {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: (_userProfileImage == null)
            ? AssetImage(
                'assets/images/profile_icon.png',
              )
            : _userProfileImage,
        backgroundColor: saveButtonColor,
      ),
      title: Text(
        'Javad Barghamadi',
        style: TextStyle(
          fontFamily: 'Product Sans',
          fontSize: textSize16,
          color: myTaskTextColor,
        ),
      ),
      subtitle: Text(
        'javadbarghamadi75@gmail.com',
        style: TextStyle(
          fontSize: textSize14,
          color: newTaskTextColor,
        ),
      ),
    );
  }

  _listOfLists() {
    return FutureBuilder<List<Lists>>(
        future: DatabaseHelper.instance.getListsList(),
        builder: (BuildContext context, AsyncSnapshot<List<Lists>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data.length > 0) {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext buildContext, int index) {
                  print('${snapshot.data[index].listId}');
                  return _list(snapshot.data[index]);
                },
              );
            } else {
              Lists newList = Lists(
                listName: 'My Tasks',
                listStatus: _listIsSelected,
              );
              DatabaseHelper.instance.insertList(newList);
              _updateListsList();
              return _list(newList);
            }
          }
          return Text('Connection State : not Done!');
        });
  }

  Widget _list(Lists theList) {
    return Padding(
      padding: (theList.listId == 1)
          ? EdgeInsets.only(
              top: padding16,
              right: padding16,
              bottom: padding16,
            )
          : EdgeInsets.only(
              right: padding16,
              bottom: padding16,
            ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(bigCornerRadius),
          bottomRight: Radius.circular(bigCornerRadius),
        ),
        child: ListTile(
            title: Text(
              theList.listName,
              style: TextStyle(
                fontFamily: 'Product Sans',
                fontSize: textSize16,
                color: saveButtonColor,
              ),
            ),
            leading: CircleAvatar(
              backgroundImage: null,
              backgroundColor: transparentColor,
            ),
            onTap: () {
              setState(() {
                theList.listStatus = 1;
                _selectedListId = theList.listId;
                selectedList = theList;
              });
              // HomePage(_selectedListName);
              // Navigator.pop(context, _selectedListName);
              Navigator.pop(context, selectedList);
            },
            selected: _selectedListId == theList.listId,
            selectedTileColor: saveButtonColor.withOpacity(0.1)),
      ),
    );
  }

  _createNewList() {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(
          Icons.add,
          color: myTaskTextColor,
        ),
        backgroundImage: null,
        backgroundColor: transparentColor,
      ),
      title: Text(
        'Create new list',
        style: TextStyle(
          fontFamily: 'Product Sans',
          fontSize: textSize16,
          color: myTaskTextColor,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return CreatListPage(
                updateListsList: _updateListsList,
              );
            },
          ),
        );
      },
    );
  }

  _helpAndFeedback() {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(
          Icons.feedback_outlined,
          color: myTaskTextColor,
        ),
        backgroundImage: null,
        backgroundColor: transparentColor,
      ),
      title: Text(
        'Help & feedback',
        style: TextStyle(
          fontFamily: 'Product Sans',
          fontSize: textSize16,
          color: myTaskTextColor,
        ),
      ),
    );
  }

  _opensourceLicenses() {
    return ListTile(
      title: Text(
        'Open-source licenses',
        style: TextStyle(
          fontFamily: 'Product Sans',
          fontSize: textSize16,
          color: myTaskTextColor,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: padding24),
    );
  }

  _privacyPolicy() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(padding14),
        child: Text(
          'Privacy Policy   |   Terms of Service',
          style: TextStyle(
            fontFamily: 'Product Sans',
            fontSize: textSize14,
            color: myTaskTextColor,
          ),
        ),
      ),
    );
  }
}
