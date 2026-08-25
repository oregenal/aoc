#!/usr/bin/env swipl

:- initialization(main, main).

:- use_module('../plib/lib').

get_result(Fname) :-
	process_file(Fname, String),
	split_string(String, "\n", "", Strings),
	maplist(result1, Strings, Scores),
	sum_list(Scores, Score),
	% format("~q~n~q~n", [Strings, Scores]),
	format("~q~n", [Score]).

result1(String, Score) :-
	string_codes(String, List),
	split_on_half(List, Lst1, Lst2),
	sort(Lst1, Res1), sort(Lst2, Res2),
	find_dup(Res1, Res2, Dup),
	get_score(Dup, Score).

split_on_half(List, Lst1, Lst2) :-
	append(Lst1, Lst2, List),
	length(Lst1, N),
	length(Lst2, N), !.

find_dup(Lst1, Lst2, Res) :- find_dup_in(Lst1, Lst2, Lst2, Res).
find_dup_in([H|_], [H|_], _, H) :- !.
find_dup_in([_|Tail], [], Lst2, Res) :- !, find_dup_in(Tail, Lst2, Lst2, Res).
find_dup_in(Lst1, [_|Tail2], Lst2, Res) :- find_dup_in(Lst1, Tail2, Lst2, Res).

get_score(Code, Score) :-
	Code >= 97, Score is Code - 96;
	Score is Code - 38.

main :-
	on_signal(int, _, default),
	current_prolog_flag(argv, Argv),
	Argv \= [], 
	maplist(get_result, Argv);
	write("Provide input file\n").

% vim: set filetype=prolog:
