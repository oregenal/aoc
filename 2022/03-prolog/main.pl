:- initialization(main, main).

:- use_module('../plib/lib').

get_result(Fname) :-
	process_file(Fname, String),
	split_string(String, "\n", "", Strings),
	maplist(string_codes, Strings, Lists),
	maplist(result1, Lists, Scores1),
	sum_list(Scores1, Score1),
	format("~s: Part 1: ~q~n", [Fname, Score1]),

	list_of_sets(Lists, Sets),
	maplist(result2, Sets, Scores2),
	sum_list(Scores2, Score2),
	format("~s: Part 2: ~q~n", [Fname, Score2]).

result1(List, Score) :-
	split_on_half(List, Lst1, Lst2),
	sort(Lst1, Res1), sort(Lst2, Res2),
	find_dup(Res1, Res2, Dup),
	get_score(Dup, Score).

result2(Sets, Score) :-
	Sets = [L1|[L2|[L3|_]]],
	find_trip(L1, L2, L3, Trip),
	get_score(Trip, Score).

split_on_half(List, Lst1, Lst2) :-
	append(Lst1, Lst2, List),
	length(Lst1, N),
	length(Lst2, N), !.

find_dup(Lst1, Lst2, Res) :- find_dup(Lst1, Lst2, Lst2, true, Res).
find_dup([H|_], [H|_], _, First, H) :- (First, !); true.
find_dup([_|Tail], [], Lst2, First, Res) :- 
	!, find_dup(Tail, Lst2, Lst2, First, Res).
find_dup(Lst1, [_|Tail2], Lst2, First, Res) :- 
	find_dup(Lst1, Tail2, Lst2, First, Res).

find_trip(Lst1, Lst2, Lst3, Res) :-
	find_dup(Lst1, Lst2, Lst2, fail, Res),
	member(Res, Lst3), !.

list_of_sets(List, Sets) :- list_of_sets(List, [], Sets).
list_of_sets([], Acc, Acc) :- !.
list_of_sets([H1,H2,H3|Tail], [], Res) :- !,
	list_of_sets(Tail, [[H1,H2,H3]], Res).
list_of_sets([H1, H2, H3|Tail], Acc, Res) :- 
	append(Acc, [[H1,H2,H3]], Llist),
	list_of_sets(Tail, Llist, Res).

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
