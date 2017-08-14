// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

import 'dart:async';
import 'dart:io';

import 'package:grinder/grinder.dart';

//TODO: document public members

/// The dartdoc [Directory].
Directory dartDocDir = new Directory('doc');
Directory apiDocDir = new Directory('doc/api');

Future main(dynamic args) => grind(args);

@DefaultTask('Running Default Tasks...')
void myDefault() {
  log("Running Defaults...");
  test();
  format();
}

@Task('Testing Dart...')
void test() {
  new PubApp.local('test').run([]);
}

@Task('Cleaning...')
void clean() {
  log("Cleaning...");
  delete(buildDir);
  delete(apiDocDir);
}

@Task('Dry Run of Formating Source...')
void testformat() {
  log("Formatting Source...");
  log("Test Formatting bin/...");
  DartFmt.dryRun('bin', lineLength: 80);
  log("Test Formatting lib/...");
  DartFmt.dryRun('lib', lineLength: 80);
  // log("Test Formatting example/...");
  // DartFmt.dryRun('example', lineLength: 80);
  log("Test Formatting test/...");
  DartFmt.dryRun('test', lineLength: 80);
  log("Test Formatting tool/...");
  DartFmt.dryRun('tool', lineLength: 80);
}

@Task('Formating Source...')
void format() {
  log("Formatting Source...");
  log("Formatting bin/...");
  DartFmt.format('bin', lineLength: 80);
  log("Formatting lib/...");
  DartFmt.format('lib', lineLength: 80);
  // log("Formatting example/...");
  // DartFmt.format('example', lineLength: 80);
  log("Formatting test/...");
  DartFmt.format('test', lineLength: 80);
  log("Formatting tool/...");
  DartFmt.format('tool', lineLength: 80);
}

@Task('DartDoc')
void dartdoc() {
  log('Generating Documentation...');
  DartDoc.doc();
}

@Task('Build the project.')
void build() {
  log("Building...");
  Pub.get();
  Pub.build(mode: "debug");
}

@Task('Building release...')
void buildRelease() {
  log("Building release...");
  Pub.upgrade();
  Pub.build(mode: "release");
}

@Task('Compiling...')
//@Depends(init)
void compile() {
  log("Compiling...");
}

@Task('Testing JavaScript...')
@Depends(build)
void testJavaScript() {
  new PubApp.local('test').run([]);
}

@Task('Deploy...')
@Depends(clean, format, compile, buildRelease, test, testJavaScript)
void deploy() {
  log("Deploying...");
  log('Regenerating Documentationfrom scratch...');
  delete(dartDocDir);
  DartDoc.doc();
}
