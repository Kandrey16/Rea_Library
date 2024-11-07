open Entities

module type S = sig
  (* Books *)
  val find_book_by_id : int -> Book.t option Lwt.t
  val get_recent_books : unit -> Book.t list Lwt.t
  val add_book : Book.t -> unit Lwt.t

  (* Users *)
  val find_account_by_id : int -> Account.t option Lwt.t
  val create_account : Account.t -> unit Lwt.t
end

module Make_mock () : S = struct
  module Book_table = Hashtbl.Make (Int)
  module Account_table = Hashtbl.Make (Int)

  let book_table : Book.t Book_table.t = Book_table.create 100
  and book_id_counter = ref 0
  and recent_added = ref []

  let account_table : Account.t Account_table.t = Account_table.create 100
  and account_id_counter = ref 0

  (* Books *)

  let add_book book =
    incr book_id_counter;
    Book_table.add book_table !book_id_counter book;
    recent_added := book :: !recent_added;
    Lwt.return_unit

  let find_book_by_id id = Lwt.return @@ Book_table.find_opt book_table id
  let get_recent_books () = Lwt.return !recent_added

  (* Users *)
  let find_account_by_id id =
    Lwt.return @@ Account_table.find_opt account_table id

  let create_account account =
    incr account_id_counter;
    Account_table.add account_table !account_id_counter account;
    Lwt.return_unit
end
