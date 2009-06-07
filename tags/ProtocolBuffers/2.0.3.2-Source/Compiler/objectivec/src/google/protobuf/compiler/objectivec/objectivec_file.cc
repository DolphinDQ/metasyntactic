// Protocol Buffers - Google's data interchange format
// Copyright 2008 Google Inc.
// http://code.google.com/p/protobuf/
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Author: kenton@google.com (Kenton Varda)
//  Based on original Protocol Buffers design by
//  Sanjay Ghemawat, Jeff Dean, and others.

#include <google/protobuf/compiler/objectivec/objectivec_file.h>
#include <google/protobuf/compiler/objectivec/objectivec_enum.h>
#include <google/protobuf/compiler/objectivec/objectivec_service.h>
#include <google/protobuf/compiler/objectivec/objectivec_extension.h>
#include <google/protobuf/compiler/objectivec/objectivec_helpers.h>
#include <google/protobuf/compiler/objectivec/objectivec_message.h>
#include <google/protobuf/compiler/code_generator.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/io/zero_copy_stream.h>
#include <google/protobuf/descriptor.pb.h>
#include <google/protobuf/stubs/strutil.h>
#include <sstream>

namespace google { namespace protobuf { namespace compiler {namespace objectivec {

  FileGenerator::FileGenerator(const FileDescriptor* file)
    : file_(file),
    classname_(FileClassName(file)) {
  }


  FileGenerator::~FileGenerator() {
  }


  void FileGenerator::GenerateHeader(io::Printer* printer) {
    printer->Print(
      "// Generated by the protocol buffer compiler.  DO NOT EDIT!\n\n");

    // hacky.  but this is how other generators determine if we're generating
    // the core ProtocolBuffers library
    if (file_->name() != "google/protobuf/descriptor.proto") {
      printer->Print("#import \"ProtocolBuffers.h\"\n\n");
    }

    if (file_->dependency_count() > 0) {
      for (int i = 0; i < file_->dependency_count(); i++) {
        printer->Print(
          "#import \"$header$.pb.h\"\n",
          "header", FilePath(file_->dependency(i)));
      }
      printer->Print("\n");
    }

    printer->Print(
      "@class PBExtendableMessage_Builder;\n"
      "@class PBGeneratedMessage_Builder;\n");

    set<string> dependencies;
    DetermineDependencies(&dependencies);
    for (set<string>::const_iterator i(dependencies.begin()); i != dependencies.end(); ++i) {
      printer->Print(
        "$value$;\n",
        "value", *i);
    }

    // need to write out all enums first
    for (int i = 0; i < file_->enum_type_count(); i++) {
      EnumGenerator(file_->enum_type(i)).GenerateHeader(printer);
    }
    for (int i = 0; i < file_->message_type_count(); i++) {
      MessageGenerator(file_->message_type(i)).GenerateEnumHeader(printer);
    }

    printer->Print(
      "\n@interface $classname$ : NSObject {\n",
      "classname", classname_);

    printer->Print(
      "}\n");

    for (int i = 0; i < file_->extension_count(); i++) {
      ExtensionGenerator(classname_, file_->extension(i)).GenerateMembersHeader(printer);
    }

    printer->Print("@end\n\n");

    for (int i = 0; i < file_->message_type_count(); i++) {
      MessageGenerator(file_->message_type(i)).GenerateMessageHeader(printer);
    }
  }


  void DetermineDependenciesWorker(set<string>* dependencies, set<string>* seen_files, const FileDescriptor* file) {
    if (seen_files->find(file->name()) != seen_files->end()) {
      // don't infinitely recurse
      return;
    }

    seen_files->insert(file->name());

    for (int i = 0; i < file->dependency_count(); i++) {
      DetermineDependenciesWorker(dependencies, seen_files, file->dependency(i));
    }
    for (int i = 0; i < file->message_type_count(); i++) {
      MessageGenerator(file->message_type(i)).DetermineDependencies(dependencies);
    }
  }


  void FileGenerator::DetermineDependencies(set<string>* dependencies) {
    set<string> seen_files;
    DetermineDependenciesWorker(dependencies, &seen_files, file_);
  }


  void FileGenerator::GenerateSource(io::Printer* printer) {
    FileGenerator file_generator(file_);
    string header_file = FileName(file_) + ".pb.h";

    printer->Print(
      "// Generated by the protocol buffer compiler.  DO NOT EDIT!\n\n"
      "#import \"$header_file$\"\n\n",
      "header_file", header_file);

    printer->Print(
      "@implementation $classname$\n",
      "classname", classname_);

    for (int i = 0; i < file_->extension_count(); i++) {
      ExtensionGenerator(classname_, file_->extension(i)).GenerateFieldsSource(printer);
    }

    for (int i = 0; i < file_->message_type_count(); i++) {
      MessageGenerator(file_->message_type(i)).GenerateStaticVariablesSource(printer);
    }

    printer->Print(
      "+ (void) initialize {\n"
      "  if (self == [$classname$ class]) {\n",
      "classname", classname_);

    printer->Indent();
    printer->Indent();

    for (int i = 0; i < file_->extension_count(); i++) {
      ExtensionGenerator(classname_, file_->extension(i)).GenerateInitializationSource(printer);
    }

    for (int i = 0; i < file_->message_type_count(); i++) {
      MessageGenerator(file_->message_type(i)).GenerateStaticVariablesInitialization(printer);
    }

    printer->Outdent();
    printer->Outdent();

    printer->Print(
      "  }\n"
      "}\n");

    for (int i = 0; i < file_->extension_count(); i++) {
      ExtensionGenerator(classname_, file_->extension(i)).GenerateMembersSource(printer);
    }

    printer->Print(
      "@end\n\n");

    for (int i = 0; i < file_->enum_type_count(); i++) {
      EnumGenerator(file_->enum_type(i)).GenerateSource(printer);
    }
    for (int i = 0; i < file_->message_type_count(); i++) {
      MessageGenerator(file_->message_type(i)).GenerateSource(printer);
    }
  }
}  // namespace objectivec
}  // namespace compiler
}  // namespace protobuf
}  // namespace google