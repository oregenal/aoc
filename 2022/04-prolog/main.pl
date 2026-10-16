:- initialization(main, main).

:- use_module('../plib/lib').

get_result(Fname) :-
	process_file(Fname, String),
	split_string(String, "\n", "", Pairs),
	maplist(fully_contain, Pairs, Scores),
	sumlist(Scores, Result),
	format("~s: Part 1: ~d~n", [Fname, Result]).

% if start of the fist >= start of the second
% and end of the first =< end of the secodn
% Or vice versa

fully_contain(Pair, Score) :-
	split_string(Pair, ",", "", Segments),
	maplist(get_ages, Segments, Edges),
	get_score(Edges, Score).

get_ages(Segment, Edges) :-
	split_string(Segment, "-", "", StrEdges),
	maplist(number_string, Edges, StrEdges).

get_score(Edges, Score) :-
	Edges = [[S1|[E1|_]],[S2|[E2|_]]], S1 >= S2, E1 =< E2, Score is 1, !;
	Edges = [[S1|[E1|_]],[S2|[E2|_]]], S2 >= S1, E2 =< E1, Score is 1, !;
	Score is 0.

main :-
	on_signal(int, _, default),
	current_prolog_flag(argv, Argv),
	Argv \= [], 
	maplist(get_result, Argv);
	write("Provide input file\n").

% vim: set filetype=prolog:
