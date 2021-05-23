import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foody_delivery_boy_app/constant/const.dart';
import 'package:foody_delivery_boy_app/helper/order_services.dart';
import 'package:foody_delivery_boy_app/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  OrderServices _OrderServices = OrderServices();
  User user = FirebaseAuth.instance.currentUser;

  int tag = 0;
  List<String> options = [
    'All',
    'Accepted',
    'Picked Up',
    'On the way',
    'Delivered',
  ];
  @override
  Widget build(BuildContext context) {
    var _orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: kcolor2,
        title: Text(
          'My Orders',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: ChipsChoice<int>.single(
              choiceActiveStyle: C2ChoiceStyle(
                color: Colors.teal,
              ),
              choiceStyle: C2ChoiceStyle(
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
              value: tag,
              onChanged: (val) => setState(() {
                if (val == 0) {
                  setState(() {
                    _orderProvider.status = null;
                  });
                }
                setState(() {
                  tag = val;
                  _orderProvider.filterOrder(options[val]);
                });
              }),
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _OrderServices.orders
                  .where('orderStatus',
                      isEqualTo: tag > 0 ? _orderProvider.status : null)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data.size == 0) {
                  //TODO no order screen
                  return Center(
                    child: Text(tag > 0
                        ? 'No ${options[tag]} orders'
                        : 'No Orders. Continue Shopping'),
                  );
                }

                return Expanded(
                  child: new ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return new Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            ListTile(
                              horizontalTitleGap: 0,
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 14,
                                child: _OrderServices.statusIcon(document),
                              ),
                              title: Text(
                                document.data()['orderStatus'],
                                style: TextStyle(
                                    fontSize: 12,
                                    color: _OrderServices.statusColor(document),
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'On ${DateFormat.yMMMd().format(
                                  DateTime.parse(document.data()['timestamp']),
                                )}',
                                style: TextStyle(fontSize: 12),
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Payment : ${document.data()['cod']}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Amount : PKR ${document.data()['total'].toStringAsFixed(0)}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            document.data()['orderStatus'] == 'Ordered'
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 3, right: 3),
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          Text(
                                            'Customer: ',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            document.data()['username'],
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        document.data()['userAddress'],
                                        style: TextStyle(fontSize: 12),
                                        maxLines: 2,
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          document.data()['orderStatus'] ==
                                                  'On the way'
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: IconButton(
                                                    icon: Icon(Icons.map),
                                                    color: Colors.green,
                                                    onPressed: () {
                                                      GeoPoint location =
                                                          document.data()[
                                                              'userLocation'];
                                                      _OrderServices.launchMap(
                                                          location,
                                                          document.data()[
                                                              'username']);
                                                    },
                                                  ),
                                                )
                                              : Container(),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: IconButton(
                                              icon: Icon(Icons.phone),
                                              color: Colors.green,
                                              onPressed: () {
                                                _OrderServices.launchCall(
                                                    'tel:${document.data()['userPhone']}');
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            ExpansionTile(
                              title: Text(
                                'Order details',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              subtitle: Text(
                                'View order details',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        //radius: 20,
                                        backgroundColor: Colors.white,
                                        child: Image.network(
                                            document.data()['products'][index]
                                                ['productImage']),
                                      ),
                                      title: Text(
                                        document.data()['products'][index]
                                            ['productName'],
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      subtitle: Text(
                                        '${document.data()['products'][index]['quantity'].toString()} x PKR ${document.data()['products'][index]['productPrice'].toString()}',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    );
                                  },
                                  itemCount: document.data()['products'].length,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 8, bottom: 8),
                                  child: Card(
                                    //color: Colors.grey[200],
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Discount : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              ),
                                              Text(
                                                document
                                                    .data()['discount']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Delivery Fee : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              ),
                                              Text(
                                                document
                                                    .data()['deliverFee']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 13),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              height: 3,
                              color: Colors.grey,
                            ),
                            document.data()['orderStatus'] == 'Accepted'
                                ? Container(
                                    color: Colors.grey[300],
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 8, 40, 8),
                                      child: FlatButton(
                                        color: Colors.blueGrey,
                                        child: Text(
                                          'Update status to Picked Up',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          EasyLoading.show(
                                              status: 'Updating status');
                                          _OrderServices.updateOrderStatus(
                                                  document.id, 'Picked Up')
                                              .then((value) {
                                            EasyLoading.showSuccess(
                                                'Updated successfully');
                                          });
                                        },
                                      ),
                                    ),
                                  )
                                : document.data()['orderStatus'] == 'Picked Up'
                                    ? Container(
                                        color: Colors.grey[300],
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              40, 8, 40, 8),
                                          child: FlatButton(
                                            color: Colors.pink[900],
                                            child: Text(
                                              'Update status to on the way',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              EasyLoading.show(
                                                  status: 'Updating status');
                                              _OrderServices.updateOrderStatus(
                                                      document.id, 'On the way')
                                                  .then((value) {
                                                EasyLoading.showSuccess(
                                                    'Updated successfully');
                                              });
                                            },
                                          ),
                                        ),
                                      )
                                    : document.data()['orderStatus'] ==
                                            'On the way'
                                        ? Container(
                                            color: Colors.grey[300],
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      40, 8, 40, 8),
                                              child: FlatButton(
                                                color: Colors.orange,
                                                child: Text(
                                                  'Update status to Delivered',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  EasyLoading.show(
                                                      status:
                                                          'Updating status');
                                                  _OrderServices
                                                          .updateOrderStatus(
                                                              document.id,
                                                              'Delivered')
                                                      .then((value) {
                                                    EasyLoading.showSuccess(
                                                        'Updated successfully');
                                                  });
                                                },
                                              ),
                                            ),
                                          )
                                        : Container(),
                            Divider(
                              height: 3,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
