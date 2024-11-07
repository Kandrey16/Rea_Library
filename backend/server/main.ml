open Server

module Routes (Repo : Repository.S) = struct
  let index _ = Dream.html "Добро пожаловать на сайт REA Library!"

  let book_by_id req =
    let book_id = Dream.param req "id" |> int_of_string in

    match%lwt Repo.find_book_by_id book_id with
    | None -> Dream.json ~status:`Not_Found "\"Не найдена такая книжка!\""
    | Some book ->
        Entities.Book.yojson_of_t book |> Yojson.Safe.to_string |> Dream.json

  let recent_books _ =
    let%lwt books = Repo.get_recent_books () in
    Ppx_yojson_conv_lib.Yojson_conv.yojson_of_list Entities.Book.yojson_of_t
      books
    |> Yojson.Safe.to_string |> Dream.json

  let account_by_id req =
    let account_id = Dream.param req "id" |> int_of_string in

    match%lwt Repo.find_account_by_id account_id with
    | None -> Dream.json ~status:`Not_Found "\"Не найдена такой пользователь!\""
    | Some account_id ->
        Entities.Account.yojson_of_t account_id
        |> Yojson.Safe.to_string |> Dream.json
end

let () =
  let open Dream in
  let module Repo = Repository.Make_mock () in
  let module Routes = Routes (Repo) in
  Lwt_main.run
    (Repo.add_book
       Entities.Book.
         {
           title = "";
           instances = 201;
           quantity = 10;
           pages = 200;
           publisher = "";
           published_year = 2012;
           authors = [];
           description = "";
           id = 100;
         };%lwt

     serve @@ logger
     @@ router
          [
            get "/" Routes.index;
            get "/books/:id" Routes.book_by_id;
            get "/books/recent" Routes.recent_books;
            get "/accounts/:id" Routes.account_by_id;
          ])
