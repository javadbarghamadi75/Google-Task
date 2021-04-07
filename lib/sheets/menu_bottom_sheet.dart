import 'package:flutter/material.dart';
import 'package:google_task/helpers/database_helper.dart';
import 'package:google_task/models/lists_model.dart';
import 'package:google_task/pages/creat_list_page.dart';
import 'package:google_task/pages/home_page.dart';
import 'package:google_task/res.dart';

class MenuBottomSheet extends StatefulWidget {
  // final Lists newCreatedList;

  // MenuBottomSheet({this.newCreatedList});

  @override
  _MenuBottomSheetState createState() => _MenuBottomSheetState();
}

class _MenuBottomSheetState extends State<MenuBottomSheet> {
  ImageProvider<Object> _userProfileImage;
  Future<List<Lists>> _listsList;
  static Lists selectedList;
  static int selectedListId;
  static String selectedListName;
  static int _listIsSelected = 0;
  static int newCreatedList;
  static int lastIndex;
  List<Lists> lists = [];
  // static var selectedIndex;
  int listLength = 0;
  bool defaultListIsSelected = false;

  @override
  void initState() {
    print('initState');
    // _selectList(listToSelect: lastIndex);
    // setState(() {
    // selectedList = widget.newCreatedList == null ? null : widget.newCreatedList;
    // });
    _updateListsList();
    super.initState();
  }

  bool _selectList({int listToSelect}) {
    if (selectedListId == lastIndex) return true;
  }

  _updateListsList() {
    // setState(() {
    _listsList = DatabaseHelper.instance.getListsList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('pop Scope');
        print('popscope print : $selectedList');
        // selectedList;
        Navigator.pop(context, selectedList);
        return true;
      },
      child: Container(
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
          listLength = snapshot.data?.length;
          if (listLength == 1) {
            defaultListIsSelected = true;
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data.length > 0) {
              lists.addAll(
                snapshot.data.where((element) => element.listStatus == true),
              );
              // selectedList =
              // lists.singleWhere((element) => element.listStatus == true);
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext buildContext, int index) {
                  print('${snapshot.data[index].listId}');
                  // lastIndex = snapshot.data.last;
                  return _list(snapshot.data[index]);
                },
              );
            } else {
              Lists defaultFirstList = Lists(
                listName: 'My Tasks',
                listStatus: true,
              );
              DatabaseHelper.instance.insertList(defaultFirstList);
              // selectedList = defaultFirstList;
              DatabaseHelper.instance.getListsList();

              // selectedListId = defaultFirstList.listId;
              _updateListsList();
              return _list(defaultFirstList);
            }
          }
          return Text('Connection State : not Done!');
        });
  }

  Widget _list(Lists theList) {
    // selectedListId = theList.listId;
    // theList.listStatus = 0;
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
              // // (theList.listStatus == false)
              // //     ? theList.listStatus = true
              // //     : theList.listStatus = false;
              // selectedListId = theList.listId;
              // selectedList = theList;
              selectedListId = theList.listId;
              // lastIndex = theList.listId;
            });
            // HomePage(_selectedListName);
            // Navigator.pop(context, _selectedListName);
            print('ontap print : $selectedList');
            // if (selectedListId == theList.listId) {
            //   return null;
            // } else
            Navigator.pop(context, selectedList);
            // Navigator.pop(context, selectedList);
          },
          // selected: _selectList(),
          selected: (defaultListIsSelected)
              ? true
              : (theList.listId == lastIndex)
                  ? true
                  : selectedListId == theList.listId,
          // selected: (selectedList.listStatus == 1)?true:,
          // selected: (theList.listId == selectedList.listId),
          // selected: selectedListId == theList.listId,
          // selected: selectedList?.listStatus,
          // selected: selectedListId == theList.listId,
          selectedTileColor: saveButtonColor.withOpacity(0.1),
        ),
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
      onTap: () async {
        Navigator.pop(context);
        await Navigator.push(
          context,
          MaterialPageRoute<int>(
            builder: (_) {
              return CreatListPage(
                updateListsList: _updateListsList,
              );
            },
          ),
        ).then(
          (value) => {
            print('creatListPage value : $value'),
            // newCreatedList = value.listId,
            // selectedListId = newCreatedList,
            lastIndex = value,
            lastIndex = lastIndex - 1,
            print('lastIndex : $lastIndex'),
            // _list(value),
          },
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
