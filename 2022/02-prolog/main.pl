#!/usr/bin/env swipl

:- initialization(main, main).

my_shape("X", 1).
my_shape("Y", 2).
my_shape("Z", 3).

shape_relations("A", "X", 3).
shape_relations("A", "Y", 6).
shape_relations("A", "Z", 0).
shape_relations("B", "X", 0).
shape_relations("B", "Y", 3).
shape_relations("B", "Z", 6).
shape_relations("C", "X", 6).
shape_relations("C", "Y", 0).
shape_relations("C", "Z", 3).

get_score(String, Score) :-
	split_string(String, " ", "", List),
	List = [His|[My|_]],
	shape_relations(His, My, Win),
	my_shape(My, ShScore),
	Score is ShScore + Win.

process_file(Fname, String) :-
	setup_call_cleanup(open(Fname, read, Stream),
		read_string(Stream, _, String),
		close(Stream)).

get_result(Fname) :-
	process_file(Fname, String),
	split_string(String, "\n", "", RawList),
	select("", RawList, List),
	maplist(get_score, List, Scores),
	sum_list(Scores, Score),
	format("~s:~w~n", [Fname, Score]).

main :-
	on_signal(int, _, default),
	current_prolog_flag(argv, Argv),
	Argv \= [], 
	maplist(get_result, Argv);
	write("Provide input file\n").

% vim: set filetype=prolog:
