/** <module> static_resources.pl

This module processes static resources

@author Bambang Purnomosidi
@license Apache License 2.0
*/

:- module(static_resources,
	[ set_assets_dir/1
	]).

% Static resources - system wide
% ex: 
%	set_assets_dir('assets') from root app will
%	serve http://server/assets/images/file.jpg
%
:- use_module(library(http/http_path)).
:- use_module(library(http/http_server_files)).
:- use_module(library(http/http_dispatch)).
:- multifile user:file_search_path/2.

set_assets_dir(Directory) :-
	write('Setting '), write(Directory), write(' as assets dir'), nl,
	assertz(http:location(assets, root(assets), [])),
	assertz(file_search_path(assets_root, Directory)),
	assertz(file_search_path(assets, assets_root(.))),
	http_handler(assets(.), serve_files_in_directory(assets_root), [prefix]).
