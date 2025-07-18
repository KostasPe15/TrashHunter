//ValueNotifier : holds data
//ValueListenableBuilder: listen to the data (no need setstate)

import 'package:flutter/cupertino.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);
const String google_api_key = 'AIzaSyDEtvIEGZCyUmlFaFuft0H5_2M8wiFxCHA';
//api_key replace to AndroidManifest.xml + AppDelegate.swift
