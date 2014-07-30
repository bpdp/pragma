
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/json)).

read_config(Result) :-
  open('app/conf/turgo.json',read,X),
  json_read_dict(X, Result),
  close(X).

get_handlers(Handlers, Start) :-
  proper_length(Handlers,Jumlah),
  (Start < Jumlah -> (nth0(Start,Handlers,X), atom_string(P,X.path), atom_string(C,X.closure), atomic_list_concat(O, ',',X.options), http_handler(P,C,O), Newstart is Start + 1, get_handlers(Handlers,Newstart));!).

say_home(_Request) :-
  format('Content-type: text/plain~n~n'),
  format('Hello home!~n').

say_merdeka(_Request) :-
  format('Content-type: text/plain~n~n'),
  format('Hello and merdeka!~n').

turgo_server :-
  read_config(Conf),
  write('Start Turgo server at port '),
  write(Conf.server.port), nl,
  write('asemiks1'),
  get_handlers(Conf.handlers,0),
  write('asemiks2'),
  http_server(http_dispatch, [port(Conf.server.port)]).

%:- turgo_server.