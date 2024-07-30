import 'package:flutter/material.dart';
import 'package:pixel_test/components/close_dialog.dart';
import 'package:pixel_test/provider/customer_provider.dart';
import 'package:provider/provider.dart';
import 'add_customer_screen.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        showCloseDialog(context, swipeDirection: 'left');
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Entities'),
          centerTitle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        body: Consumer<CustomerProvider>(
          builder: (context, customerProvider, child) {
            return customerProvider.customers.length == 0
                ? const Center(
                    child: Text('No Entity Found'),
                  )
                : ListView.builder(
                    itemCount: customerProvider.customers.length,
                    itemBuilder: (context, index) {
                      final customer = customerProvider.customers[index];

                      return Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFFDDDDDD).withOpacity(0.5),
                                blurRadius: 7)
                          ],
                          border: Border.all(
                              color: const Color(0xFFDDDDDD).withOpacity(0.7),
                              width: 0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          // contentPadding: EdgeInsets.all(15),
                          title: Text(customer.fullName),
                          subtitle: Text(customer.email),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  size: 17,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AddCustomerScreen(
                                        customer: customer,
                                        index: index,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  customerProvider.deleteCustomer(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddCustomerScreen()),
            );
          },
          child: const Icon(Icons.add,color: Colors.white,),
        ),
      ),
    );
  }
}
