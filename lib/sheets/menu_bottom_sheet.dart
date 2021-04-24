import 'package:flutter/material.dart';
import 'package:google_task/helpers/database_helper.dart';
import 'package:google_task/models/lists_model.dart';
import 'package:google_task/pages/creat_list_page.dart';
import 'package:google_task/pages/home_page.dart';
import 'package:google_task/res.dart';

class MenuBottomSheet extends StatefulWidget {
  // final Future<dynamic> updateHome;

  // MenuBottomSheet({this.updateHome});

  @override
  _MenuBottomSheetState createState() => _MenuBottomSheetState();
}

class _MenuBottomSheetState extends State<MenuBottomSheet> {
  ImageProvider<Object> _userProfileImage;
  Future<List<Lists>> _listsList;
  Lists selectedList;
  int selectedListId;
  String selectedListName;
  static int _listIsSelected = 0;
  static int newCreatedList;
  static int lastIndex;
  List<Lists> lists = [];
  // static var selectedIndex;
  int listLength = 0;
  bool defaultListIsSelected = false;
  int defaultFirstListId;
  Lists defaultCreatedFirstList;
  int aListIdWithSelectedStatus;
  Lists defaultName;

  @override
  void initState() {
    print('initState');

    ///`hamin avval k id nadare!!! bayad bere to database baad!`
    _updateListsList();
    _getSelectedListId();
    super.initState();
  }

  _getSelectedListId() async {
    Future<int> result =
        DatabaseHelper.instance.getListsList().then((value) => value.length);
    int listsListLength = await result;
    if (listsListLength > 0 || listsListLength != null) {
      DatabaseHelper.instance.getListsList();
      Future<Lists> aListWithSelectedStatus = DatabaseHelper.instance
          .getListsList()
          .then((value) => value.singleWhere(
                (element) => element.listStatus == 1,
              ));
      selectedList = await aListWithSelectedStatus.then((value) => value);
      setState(() {
        selectedList = selectedList;
        selectedListId = selectedList.listId;
        selectedListName = selectedList.listName;
      });
      print('selectedListName in initState : $selectedListName');
    }
    // else {
    //   Future<Lists> defaultListName =
    //       DatabaseHelper.instance.getListsList().then((value) => value.first);
    //   defaultName = await defaultListName;
    // }
  }

  // Future<Lists> _kireKhar() async {
  //   Future<Lists> defaultListName =
  //       DatabaseHelper.instance.getListsList().then((value) => value.first);
  //   defaultName = await defaultListName;
  //   print('defaultName 1 : $defaultName');
  //   return defaultName;
  // }

  // _buildDefaultList() async {
  //   Lists defaultList = Lists(
  //     listName: 'My Tasks',
  //   ); // TODO : check needed or not!
  //   DatabaseHelper.instance.insertList(defaultList);
  //   print('defaultFirstList.listId : ${defaultList.listId}');
  //   await _getDefaultFirstListId();
  //   selectedListId = defaultFirstListId;
  //   print('defaultFirstListId : $defaultFirstListId');
  //   _updateListsList();
  // }

  // _getDefaultFirstListId() async {
  //   Future<int> defaultCreatedListId = DatabaseHelper.instance
  //       .getListsList()
  //       .then((value) => value.first.listId);
  //   defaultFirstListId = await defaultCreatedListId;
  //   Future<Lists> defaultCreatedListName =
  //       DatabaseHelper.instance.getListsList().then((value) => value.first);
  //   defaultCreatedFirstList = await defaultCreatedListName;
  // }

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
        print('pop Scoped!');
        print('popscope print : $selectedListId');
        // Navigator.pop(context, widget.updateHome);
        Navigator.pop(context, selectedListName);
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
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext buildContext, int index) {
                  print('${snapshot.data[index].listId}');
                  // DatabaseHelper.instance.updateAllList();
                  return _list(snapshot.data[index]);
                },
              );
            } else {
              // _kireKhar();
              // print('defaultName : $defaultName');
              // setState(() {
              //   selectedListId = defaultName.listId;
              // });
              // return _list(defaultName);
            }
          }
          return Text('Connection State : not Done!');
        });
  }

  Widget _list(Lists theList) {
    // _updateListsList();
    return Padding(
      /// `The getter 'listId' was called on null` => this is because im reading data from database. (in last senario I was passing the name to this widget)
      /// Now I can 1: pass the name from here or 2: build the default list in Home `(That's better!)`
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
              selectedListId = theList.listId;
              print(theList.listId);
            });
            DatabaseHelper.instance.updateAllList();
            theList.listStatus = 1;
            DatabaseHelper.instance.updateList(theList);
            print('ontap print : $selectedList');
            // Navigator.pop(context, widget.updateHome);
            Navigator.pop(context, selectedListName);
          },
          selected: selectedListId == theList.listId,
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
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
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
            // print('creatListPage value : $value'),
            // selectedListId = value,
            // print('lastIndex : $value'),
            // // _list(value),
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
