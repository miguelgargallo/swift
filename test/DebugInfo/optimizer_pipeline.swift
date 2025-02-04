// RUN: %target-swift-frontend %s -emit-sil -g -Osize -parse-stdlib -parse-as-library -enable-ossa-modules -o - | %FileCheck %s

// REQUIRES: asserts

import Swift

// Test that DCE correctly preserves debug locations.
// SR-15300: Compiler crash when using Builtin.unreachable in initializers
//
// CHECK: sil_scope [[S1:[0-9]+]] { {{.*}} parent @$s18optimizer_pipeline1AVyACs13KeyValuePairsVyypypGcfC
// CHECK: sil_scope [[S2:[0-9]+]] { {{.*}} parent [[S1]] }
//
// CHECK-LABEL: sil {{.*}}@$s18optimizer_pipeline1AVyACs13KeyValuePairsVyypypGcfC : $@convention(method) (@owned KeyValuePairs<Any, Any>, @thin A.Type) -> A {
// CHECK: bb0(%0 : $KeyValuePairs<Any, Any>, %1 : $@thin A.Type):
// CHECK: unreachable , scope [[S2]]
// CHECK-LABEL: } // end sil function '$s18optimizer_pipeline1AVyACs13KeyValuePairsVyypypGcfC'
public struct A {
  public init(_ pairs: KeyValuePairs<Any, Any>) {
    Builtin.unreachable()
  }
}
