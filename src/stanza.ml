open Stdune

type t = ..

module Parser = struct
  type nonrec t = string * t list Sexp.Of_sexp.t
end

let syntax =
  Syntax.create ~name:"dune" ~desc:"the dune language"
    [ (0, 0) (* Jbuild syntax *)
    ; (1, 0)
    ]

module File_kind = struct
  type t = Jbuild | Dune
end

let file_kind () =
  let open Sexp.Of_sexp in
  Syntax.get_exn syntax >>| fun ver ->
  if ver < (1, 0) then File_kind.Jbuild else Dune

module Of_sexp = struct
  include Sexp.Of_sexp

  let record parse =
    Syntax.get_exn syntax >>= fun ver ->
    if ver < (1, 0) then
      record parse
    else
      fields parse

  let list parse =
    Syntax.get_exn syntax >>= fun ver ->
    if ver < (1, 0) then
      list parse
    else
      repeat parse
end
