import 'package:flutter/material.dart';

class Variables{

  ///This is the entire multi-level list displayed by this app
  static List<Entry> sideBarMenuList(){
    final List<Entry> data = <Entry>[
      Entry('Customer', <Entry>[
        Entry('All Customer'),
        Entry('Due Bill Customer'),
        Entry('Paid Bill Customer'),
        Entry('Customer Problem List'),
      ]),
      Entry('Bills', <Entry>[
        Entry('Billing Info'),
        Entry('Bill Request'),
      ]),
      Entry('Bill Man', <Entry>[
        Entry('Add Bill Man'),
        Entry('All Bill Man'),
      ]),
      // Entry('Head', <Entry>[
      //   Entry('Bank Book'),
      //   Entry('Cash Book'),
      //   Entry('Summary'),
      // ]),
    ];
    return data;
  }
}

class Entry {
  final String title;
  final List<Entry>children; //Since this is an expansion list...children can be another list of entries.

  Entry(this.title,[this.children = const <Entry>[]]);
}
