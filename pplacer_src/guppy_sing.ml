open Subcommand
open Guppy_cmdobjs
open MapsSets
open Fam_batteries
open Visualization

let sing_tree weighting criterion mass_width ref_tree pquery =
  let pqname = String.concat "_" pquery.Pquery.namel in
  match weighting with
  | Mass_map.Weighted ->
    Gtree.add_subtrees_by_map
      ref_tree
      (IntMapFuns.of_pairlist_listly
        (ListFuns.mapi
          (fun num p ->
            let mass = criterion p in
            (Placement.location p,
              (Placement.distal_bl p,
              make_zero_leaf
                ([ Decor.red] @
                  (widthl_of_mass 0. mass_width mass))
                (Placement.pendant_bl p)
                (Printf.sprintf
                  "%s_#%d_M=%g"
                  pqname
                  num
                  mass),
              decor_bark_of_bl)))
          (Pquery.place_list pquery)))
  | Mass_map.Unweighted ->
      let p = Pquery.best_place criterion pquery in
      Gtree.add_subtrees_by_map
        ref_tree
        (IntMapFuns.of_pairlist_listly
          [Placement.location p,
            (Placement.distal_bl p,
            make_zero_leaf
              [ Decor.red; ]
              (Placement.pendant_bl p)
              (Printf.sprintf "%s" pqname),
              decor_bark_of_bl)])

let write_sing_file weighting criterion mass_width tree_fmt fname_base ref_tree
    placed_pquery_list =
  trees_to_file
    tree_fmt
    (fname_base^".sing")
    (List.map
      (sing_tree weighting criterion mass_width ref_tree)
      placed_pquery_list)

class cmd () =
object (self)
  inherit subcommand () as super
  inherit out_prefix_cmd () as super_out_prefix
  inherit mass_cmd () as super_mass
  inherit placefile_cmd () as super_placefile
  inherit viz_command () as super_viz

  method specl =
    super_mass#specl
    @ super_out_prefix#specl
    @ super_viz#specl

  method desc = "single placement: make one tree for each placement"
  method usage = "usage: sing [options] placefile[s]"

  method private placefile_action prl =
    let _, weighting, criterion = self#mass_opts in
    let unit_width = fv unit_width in
    List.iter
      (fun pr ->
        let fname_base =
          (fv out_prefix) ^ (Placerun.get_name pr)
        in
        write_sing_file
          weighting
          criterion
          unit_width
          self#fmt
          fname_base
          (self#decor_ref_tree pr)
          (List.filter Pquery.is_placed (Placerun.get_pqueries pr)))
      prl
end