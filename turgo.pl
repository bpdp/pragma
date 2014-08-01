/** <module>Turgo framework

  This module is used to develop Pragmatic Web application

  @author Bambang Purnomosidi
  @license Apache 2.0
 */

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/json)).
:- use_module(library(http/http_server_files)).

% Static resources - system wide
% ex: images will be served by /assets/images/file.jpg
%
:- use_module(library(http/http_path)).
:- multifile user:file_search_path/2.

http:location(assets, root(assets), []).

user:file_search_path(assets_root, 'assets').
user:file_search_path(assets, assets_root(.)).

:- http_handler(assets(.), serve_files_in_directory(assets), [prefix]).
% end of static resources definition

user:file_search_path(handlers, 'app/handlers').

read_config(Result) :-
  open('app/conf/turgo.json',read,X),
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

turgo_server :-
  read_config(Conf),
  write('Start Turgo server at port '),
  write(Conf.server.port), nl,
  get_handlers(Conf.handlers,0),
  http_server(http_dispatch, [port(Conf.server.port)]).

:- turgo_server.
