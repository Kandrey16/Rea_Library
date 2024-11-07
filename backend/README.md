# realibrary-server

### API

```http

# Получить книгу по её ID
GET /books/:id

# Получить недавно добавленные книги
GET /books/recent

# Получить инфу о юзере по ID
GET /accounts/:id
```

### Как собрать?

Требуется:
- Установленный [OCaml] (версии >= 4.14)
- Система сборки Dune и пакетный менеджер OPAM

Создание локального свитча:
```console
$ opam switch create . --deps-only
```

### Запустить

```console
$ dune exec realibrary-server
```

[OCaml]: https://ocaml.org/install