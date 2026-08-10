#!/usr/bin/env swipl

:- initialization(main, main).

process_file(Fname, Result) :-
	setup_call_cleanup(open(Fname, read, Stream),
		process_data(Stream, Result),
		close(Stream)).

process_data(Stream, Result) :-
	stream_list(Stream, List),
	process_input(List, SL),
	maplist(colories, SL, RL),
	find_most(RL, Result).

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
colories_in([H|Tail], A, Lc) :- string_length(H, 0), !, colories_in(Tail, A, Lc).
colories_in([H|Tail], A, Lc) :- number_string(X, H), A1 is X + A, colories_in(Tail, A1, Lc).

find_most(L, R) :- find_most_in(L, 0, R).
find_most_in([], A, A) :- !.
find_most_in([H|Tail], A, R) :-  
	(H > A, !, find_most_in(Tail, H, R) 
	; find_most_in(Tail, A, R)).

main :-
	on_signal(int, _, default),
	current_prolog_flag(argv, Argv),
	(Argv = [Fname|_],
		process_file(Fname, Result),
		write(Fname),
		write(":"),
		write(Result);
		write("Provide input file\n")).

% vim: set filetype=prolog:
