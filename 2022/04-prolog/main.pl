:- initialization(main, main).

:- use_module('../plib/lib').

get_result(Fname) :-
	process_file(Fname, String),
	split_string(String, "\n", "", Pairs),
	maplist(list_of_ages, Pairs, Edges),
	maplist(fully_contain, Edges, Scores1),
	sumlist(Scores1, Result1),
	format("~s: Part 1: ~d~n", [Fname, Result1]),
	maplist(overlap_at_all, Edges, Scores2),
	sumlist(Scores2, Result2),
	format("~s: Part 2: ~d~n", [Fname, Result2]).

list_of_ages(Pair, Edges) :-
	split_string(Pair, ",", "", Segments),
	maplist(get_ages, Segments, Edges).

get_ages(Segment, Edges) :-
	split_string(Segment, "-", "", StrEdges),
	maplist(number_string, Edges, StrEdges).

% One segment fully contain the other if
% start of the fist >= start of the second
% and the end of the first =< end of the second
% or vice versa
fully_contain(Edges, Score) :-
	Edges = [[S1|[E1|_]],[S2|[E2|_]]], S1 >= S2, E1 =< E2, Score is 1;
	Edges = [[S1|[E1|_]],[S2|[E2|_]]], S2 >= S1, E2 =< E1, Score is 1;
	Score is 0.

% One segment overlap the other if
% start of the first >= start of the second and =< end of the second
% or vice versa
overlap_at_all(Edges, Score) :-
	Edges = [[S1|_],[S2|[E2|_]]], S1 >= S2, S1 =< E2, Score is 1;
	Edges = [[S1|[E1|_]],[S2|_]], S2 >= S1, S2 =< E1, Score is 1;
	Score is 0.

main :-
	on_signal(int, _, default),
	current_prolog_flag(argv, Argv),
	Argv \= [],
	maplist(get_result, Argv);
	write("Provide input file\n").

% vim: set filetype=prolog:
