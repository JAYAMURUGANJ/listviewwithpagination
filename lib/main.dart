import 'package:flutter/material.dart';
import 'package:listviewwithpagination/model/nomination.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'service/nomination.dart';

void main() {
  runApp(MyAPP());
}

class MyAPP extends StatelessWidget {
  const MyAPP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: DataPagerWithListView()),
    );
  }
}

class DataPagerWithListView extends StatefulWidget {
  @override
  _DataPagerWithListView createState() => _DataPagerWithListView();
}

List<NominationDetails> _paginatedProductData = [];

List<NominationDetails> _products = [
  NominationDetails(
      nominationId: 0,
      examName: "LOADING...",
      categoryId: 0,
      departmentId: 0,
      postId: 0,
      effectToDate: "LOADING...")
];
final int rowsPerPage = 5;

class _DataPagerWithListView extends State<DataPagerWithListView> {
  static const double dataPagerHeight = 70.0;
  bool showLoadingIndicator = false;

  @override
  void initState() {
    super.initState();

    getNominationDetails().then((value) {
      setState(() {
        _products = value;
        print(_products.length);
        _products = List.from(_products);
      });
    });
  }

  void rebuildList() {
    setState(() {});
  }

  Widget loadListView(BoxConstraints constraints) {
    List<Widget> _getChildren() {
      final List<Widget> stackChildren = [];

      if (_products.isNotEmpty) {
        stackChildren.add(ListView.custom(
            childrenDelegate: CustomSliverChildBuilderDelegate(indexBuilder)));
      }

      if (showLoadingIndicator) {
        stackChildren.add(Container(
          color: Colors.black12,
          child: Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
        ));
      }
      return stackChildren;
    }

    return Stack(
      children: _getChildren(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _products.length > 0
        ? Container(
            height: 400,
            child: LayoutBuilder(builder: (context, constraint) {
              return Column(
                children: [
                  Container(
                    height: constraint.maxHeight - dataPagerHeight,
                    child: loadListView(constraint),
                  ),
                  Container(
                    height: dataPagerHeight,
                    child: SfDataPagerTheme(
                        data: SfDataPagerThemeData(
                            itemBorderRadius: BorderRadius.circular(5),
                            selectedItemColor: Colors.red),
                        child: SfDataPager(
                            pageCount:
                                (_products.length / rowsPerPage).ceilToDouble(),
                            onPageNavigationStart: (pageIndex) {
                              setState(() {
                                showLoadingIndicator = true;
                              });
                            },
                            onPageNavigationEnd: (pageIndex) {
                              setState(() {
                                showLoadingIndicator = false;
                              });
                            },
                            delegate:
                                CustomSliverChildBuilderDelegate(indexBuilder)
                                  ..addListener(rebuildList))),
                  )
                ],
              );
            }),
          )
        : Center(child: CircularProgressIndicator());
  }

  Widget indexBuilder(BuildContext context, int index) {
    final NominationDetails data = _paginatedProductData[index];
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: LayoutBuilder(
        builder: (context, constraint) {
          return Container(
              color: Colors.yellow,
              width: constraint.maxWidth,
              height: 100,
              child: Row(
                children: [
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: Container(
                  //     clipBehavior: Clip.antiAlias,
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: Image.asset(data.image!, width: 100, height: 100),
                  //   ),
                  // ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 5, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: constraint.maxWidth - 130,
                          child: Text(data.nominationId.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  fontSize: 15)),
                        ),
                        Container(
                          width: constraint.maxWidth - 130,
                          child: Text(data.examName!,
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 10)),
                        ),
                        Container(
                          width: constraint.maxWidth - 130,
                          child: Row(
                            children: [
                              Container(
                                color: Colors.green.shade900,
                                padding: EdgeInsets.all(3),
                                child: Row(
                                  children: [
                                    Text('${data.categoryId}',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 13)),
                                    SizedBox(width: 2),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 15,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
                              Text('${data.departmentId}',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 11))
                            ],
                          ),
                        ),
                        Container(
                          width: constraint.maxWidth - 130,
                          child: Row(
                            children: [
                              Container(
                                child: Text('\$${data.postId}',
                                    style: TextStyle(
                                        color: Colors.green.shade800,
                                        fontSize: 13)),
                              ),
                              SizedBox(width: 8),
                              Text('${data.effortFromDate}',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 10))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }
}

class CustomSliverChildBuilderDelegate extends SliverChildBuilderDelegate
    with DataPagerDelegate, ChangeNotifier {
  CustomSliverChildBuilderDelegate(builder) : super(builder);

  @override
  int get childCount => _paginatedProductData.length;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startRowIndex = newPageIndex * rowsPerPage;
    int endRowIndex = startRowIndex + rowsPerPage;

    if (endRowIndex > _products.length) {
      // endRowIndex = _products.length - 1;
      endRowIndex = _products.length;
    }

    await Future.delayed(Duration(milliseconds: 1000));
    _paginatedProductData =
        _products.getRange(startRowIndex, endRowIndex).toList(growable: false);
    notifyListeners();
    return true;
  }

  @override
  bool shouldRebuild(covariant CustomSliverChildBuilderDelegate oldDelegate) {
    return true;
  }
}
