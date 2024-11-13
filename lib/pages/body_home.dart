import 'package:flutter/material.dart';
import 'package:phan_mem_giao_nhac_viec/components/my_doughnutchart.dart';

class BodyHome extends StatelessWidget {
  const BodyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // search box
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.black38),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Column(
            children: [
              // today task
              Container(
                padding: EdgeInsets.only(top: 8, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    // date today will display here
                    Row(
                      children: [Text("Today - 13 Nov")],
                    ),
                    //divider
                    Divider(
                      thickness: 1,
                      color: Colors.black54,
                    ),
                    Text("Your today task will be display here"),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              // Overview
              Container(
                padding:
                    EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Overview"),
                      ],
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    // doughno
                    MyDoughnutchart(),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
