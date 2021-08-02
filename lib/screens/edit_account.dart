// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class EditUserInfo extends StatefulWidget {
  static const routeName = "edit-user-info";

  @override
  _EditUserInfoState createState() => _EditUserInfoState();
}

class _EditUserInfoState extends State<EditUserInfo> {
  String name, area, oldName, oldArea;
  bool isChanged = false;

  @override
  Widget build(BuildContext context) {
    var _initialValues = {
      "name": Provider.of<Auth>(context, listen: false).nameUser,
      "area": Provider.of<Auth>(context, listen: false).areaUser,
    };

    return Consumer<Auth>(
      builder: (ctx, data, _) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(' تغيير المعلومات '),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Wrap(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(right: 10, left: 5, bottom: 2, top: 4),
                  child: SizedBox(
                    height: 43,
                    width: 230,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'أدخل تفاصيل اكثر لإعلانك';
                        }
                        return null;
                      },
                      initialValue: _initialValues['name'].toString(),
                      onSaved: (value) {},
                      onChanged: (val) {
                        name = val;
                        isChanged =true;

                      },
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'ضع اسمك هنا',
                        hintStyle: Theme.of(context).textTheme.headline3,
                        fillColor: Colors.grey,
                        hoverColor: Colors.grey,
                      ),
                      cursorRadius: Radius.circular(5),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Text(
                    'الاسم',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat-Arabic Regular',
                        height: 1.8),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 5,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ],
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
            ),
            Wrap(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(right: 10, left: 5, bottom: 2, top: 4),
                  child: SizedBox(
                    height: 43,
                    width: 230,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'ضع منطقة';
                        }
                        return null;
                      },
                      initialValue: _initialValues['area'].toString(),
                      onChanged: (val) {
                        area = val;
                        isChanged =true;
                      },
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'ضع منطقتك هنا',
                        hintStyle: Theme.of(context).textTheme.headline3,
                        fillColor: Colors.grey,
                        hoverColor: Colors.grey,
                      ),
                      cursorRadius: Radius.circular(5),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Text(
                    'المنطقة',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat-Arabic Regular',
                        height: 1.8),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 5,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ],
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.start,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            oldArea = data.areaUser;
            oldName = data.nameUser;
            name = isChanged ? name : oldName;
            area = isChanged ? area : oldArea;
            Provider.of<Auth>(context, listen: false)
                .updateUserInfo(name, area);
          },
          child: Icon(FontAwesomeIcons.save),
        ),
      ),
    );
  }
}
