// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Bar chart example
// EXCLUDE_FROM_GALLERY_DOCS_START
import 'dart:math';
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arduino/bloc/api_bloc.dart';
import 'package:flutter_arduino/pages/pin_chart_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinStatusPage extends StatefulWidget {
  const PinStatusPage({Key? key}) : super(key: key);

  @override
  _PinStatusPageState createState() => _PinStatusPageState();
}

class _PinStatusPageState extends State<PinStatusPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ApiBloc()..add(SetPinsValue()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Wemos Mini D1 Lite'),
          actions: [
            BlocBuilder<ApiBloc, ApiState>(
              builder: (context, state) {
                return IconButton(
                    onPressed: () {
                      BlocProvider.of<ApiBloc>(context)..add(SetPinsValue());
                    },
                    icon: Icon(Icons.refresh));
              },
            ),
          ],
        ),
        body: BlocBuilder<ApiBloc, ApiState>(
          builder: (context, state) {
            if (state is PinsValueLoaded) {
              return Center(
                  child: PinChart(
                data: state.data,
              ));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
