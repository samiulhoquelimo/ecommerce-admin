import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/order_constants_model.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantsModel orderConstantsModel = OrderConstantsModel();
  List<OrderModel> orderList = [];

  Future<void> getOrderConstants() async {
    DbHelper.getOrderConstants().listen((snapshot) {
      if (snapshot.exists) {
        orderConstantsModel = OrderConstantsModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

/*Future<void> addOrderConstants(OrderConstantsModel model) =>
      DbHelper.addOrderConstants(model);

  void getAllOrders() {
    DbHelper.getAllOrders().listen((event) {
      orderList = List.generate(event.docs.length, (index) =>
          OrderModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  num getTotalOrderByDate(DateTime dateTime) {
    final filteredList = orderList.where((element) =>
    element.orderDate.day == dateTime.day &&
    element.orderDate.month == dateTime.month &&
    element.orderDate.year == dateTime.year)
        .toList();
    return filteredList.length;
  }

  num getTotalOrderByDateRange(DateTime dateTime) {
    final filteredList = orderList.where((element) =>
    element.orderDate.timestamp.toDate().isAfter(dateTime))
        .toList();

    return filteredList.length;
  }

  num getTotalSaleByDate(DateTime dateTime) {
    num total = 0;
    final filteredList = orderList.where((element) =>
    element.orderDate.day == dateTime.day &&
        element.orderDate.month == dateTime.month &&
        element.orderDate.year == dateTime.year)
        .toList();
    for(var order in filteredList) {
      total += order.grandTotal;
    }
    return total.round();
  }

  num getTotalSaleByDateRange(DateTime dateTime) {
    num total = 0;
    final filteredList = orderList.where((element) =>
        element.orderDate.timestamp.toDate().isAfter(dateTime))
        .toList();
    for(var order in filteredList) {
      total += order.grandTotal;
    }
    return total.round();
  }

  num getAllTimeTotalSale() {
    num total = 0;
    for(var order in orderList) {
      total += order.grandTotal;
    }
    return total.round();
  }

  List<OrderModel> getFilteredOrderList(OrderFilter filter) {
    var filteredList = <OrderModel>[];
    switch(filter) {
      case OrderFilter.TODAY:
        filteredList = orderList.where((element) =>
        element.orderDate.day == DateTime.now().day &&
            element.orderDate.month == DateTime.now().month &&
            element.orderDate.year == DateTime.now().year)
            .toList();
        break;
      case OrderFilter.YESTERDAY:

        break;
      case OrderFilter.SEVEN_DAYS:

        break;
      case OrderFilter.THIS_MONTH:

        break;
      case OrderFilter.ALL_TIME:

        break;
    }
    return filteredList;
  }*/
}
