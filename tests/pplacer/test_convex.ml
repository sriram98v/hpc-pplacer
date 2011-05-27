open OUnit
open Test_util

open Convex

let suite = List.map
  (fun (s, omega) ->
    let gt = Newick_gtree.of_string s in
    let st = gt.Gtree.stree
    and bm = gt.Gtree.bark_map in
    let colors = MapsSets.IntMap.fold
      (fun key value map ->
        let name = value#get_name in
        if name = "" then
          map
        else
          MapsSets.IntMap.add key name map)
      bm
      MapsSets.IntMap.empty
    in
    let _, calculated_omega = solve (colors, st) in
    let testfunc () =
      (Printf.sprintf "%d expected; got %d" omega calculated_omega) @? (omega = calculated_omega)
    in
    s >:: testfunc)
  [
    "((A,A),(B,B))", 4;
    "((A,B),(A,B))", 3;
    "(((A,B),(A,B)),(C,C))", 5;
    "(((A,B),B),(A,A))", 4;
    "(A,(A,(B,C)))", 4;
  ]
