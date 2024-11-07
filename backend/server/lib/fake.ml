let generate_fake_data (module Repo : Repository.S) =
  Repo.add_book
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

  Repo.create_account
    Entities.Account.
      {
        first_name = "Pizda";
        second_name = "lox";
        email = "";
        password = "efewfwe";
        role = Librarian;
      };%lwt

  Repo.create_account
    Entities.Account.
      {
        first_name = "Pizd2a";
        second_name = "lo2x";
        email = "";
        password = "efe2wfwe";
        role = Reader;
      };%lwt

  Lwt.return_unit
