#!/usr/bin/env swipl

:- initialization(main, main).

process_file(Fname, Result) :-
	setup_call_cleanup(open(Fname, read, Stream),
		process_data(Stream, Result),
		close(Stream)).

process_data(Stream, Result) :-
	stream_list(Stream, List),
	process_input(List, SL),
	maplist(colories, SL, Result).

stream_list(Stream, List) :-
	read_string(Stream, _, Str),
	atomic_list_concat(List, '\n\n', Str).

process_input(Input, List) :- process_input_in(Input, [], List).
process_input_in([], Acc, Acc) :- !.
process_input_in([H|Tail], Acc, [SL|Ntail]) :- 
	split_string(H, "\n", "", SL),
	process_input_in(Tail, Acc, Ntail).

colories(List, Lc) :- colories_in(List, 0, Lc).
colories_in([], A, A) :- !.
colories_in([H|Tail], A, Lc) :- 
	string_length(H, 0), 
	!, colories_in(Tail, A, Lc).
colories_in([H|Tail], A, Lc) :- 
	number_string(X, H), 
	A1 is X + A, colories_in(Tail, A1, Lc).

find_most(L, R) :-
	sort(0, @>=, L, SortL), SortL = [R|_].

sum_3_most(L, R) :-
	sort(0, @>=, L, SortL), SortL =[A1|[A2|[A3|_]]], R is A1 + A2 + A3.

get_result(Fname) :-
	process_file(Fname, List),
	find_most(List, Result1),
	sum_3_most(List, Result2),
	format('~w, ~s:~w~n', [Fname, "Part1", Result1]),
	format('~w, ~s:~w~n', [Fname, "Part2", Result2]).

main :-
	on_signal(int, _, default),
	current_prolog_flag(argv, Argv),
	(Argv = [Sample|_],
		get_result(Sample);
		write("Provide input file\n")),
	(Argv = [_|[Input|_]],
		get_result(Input);
		write("Provide input file\n")).

% vim: set filetype=prolog:
