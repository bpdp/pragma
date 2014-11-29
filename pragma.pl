/** <module>Pragma framework

  This module is used to develop Web application
  using SWI Prolog (devel 7.1.x)

  @author Bambang Purnomosidi
  @license Apache 2.0
 */

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/json)).
:- use_module(library(http/http_server_files)).

user:file_search_path(libs, 'libs').

:- use_module(libs(conf/static_resources)).

user:file_search_path(handlers, 'app/handlers').

read_config(Result) :-
  open('app/conf/pragma.json',read,X),
  json_read_dict(X, Result),
  close(X).

get_handlers(Handlers, Start) :-
  proper_length(Handlers,Jumlah),
  (Start < Jumlah -> (nth0(Start,Handlers,X),
                      atom_string(P,X.path),
                      atom_string(C,X.closure),
                      atomic_list_concat(O, ',',X.options),
                      http_handler(P,C,O),
                      atom_concat(handler_, C, Handlerfile),
                      consult(handlers(Handlerfile)),
                      Newstart is Start + 1,
                      get_handlers(Handlers,Newstart));!).

pragma_server :-
  read_config(Conf),
  write('Start Turgo server at port '),
  write(Conf.server.port), nl,
  get_handlers(Conf.handlers,0),
  set_assets_dir('assets'),
  http_server(http_dispatch, [port(Conf.server.port)]).

:- pragma_server.
