module Routes = struct
  let index _ = Dream.html "Добро пожаловать на сайт REA Library!"
end

let () =
  let open Dream in
  run @@ logger @@ router [ get "/" Routes.index ]
