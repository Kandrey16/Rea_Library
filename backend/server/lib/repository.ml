open Entities

module type S = sig
  (* Books *)
  val find_book_by_id : int -> Book.t option Lwt.t
  val get_recent_books : unit -> Book.t list Lwt.t
  val add_book : Book.t -> unit Lwt.t

  (* Users *)
  val find_account_by_id : int -> Account.t option Lwt.t
  val create_account : Account.t -> unit Lwt.t

  (* Picked *)
  val pick_book : user_id:int -> book_id:int -> unit Lwt.t
end

module Make_mock () : S = struct
  module Table = Hashtbl.Make (Int)

  let book_table : Book.t Table.t = Table.create 100
  and book_id_counter = ref 0
  and recent_added = ref []

  let account_table : Account.t Table.t = Table.create 100
  and account_id_counter = ref 0

  let picked_table : int Table.t = Table.create 100

  (* Books *)

  let add_book book =
    incr book_id_counter;
    Table.add book_table !book_id_counter book;
    recent_added := book :: !recent_added;
    Lwt.return_unit

  let find_book_by_id id = Lwt.return @@ Table.find_opt book_table id
  let get_recent_books () = Lwt.return !recent_added

  (* Users *)

  let find_account_by_id id = Lwt.return @@ Table.find_opt account_table id

  let create_account account =
    incr account_id_counter;
    Table.add account_table !account_id_counter account;
    Lwt.return_unit

  (* Picked *)

  let pick_book ~user_id ~book_id =
    Table.add picked_table user_id book_id;
    Lwt.return_unit
end
