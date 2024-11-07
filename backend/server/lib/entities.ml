open Ppx_yojson_conv_lib.Yojson_conv

module Book = struct
  type t = {
    id : int; [@default -1]
    title : string;
    description : string;
    authors : string list;
    published_year : int;
    publisher : string;
    pages : int;  (** Общее количество экземпляров  *)
    quantity : int;  (** Количество экземпляров в наличии *)
    instances : int;
  }
  [@@deriving yojson]
end

module Account = struct
  type t = {
    first_name : string;
    second_name : string;
    email : string;
    password : string;
    role : role; [@default Reader]
  }

  and role = Reader | Librarian
end


