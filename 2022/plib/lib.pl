:- module(lib, [process_file/2]).

process_file(Fname, String) :- 
	catch(process_file_in(Fname, String), Ex, err(Ex)).

process_file_in(Fname, String) :-
	setup_call_cleanup(open(Fname, read, Stream),
		read_string(Stream, "", "\n", _, String),
		close(Stream)).

err(error(E, C)) :- !,
	E =.. [ErrorReason, _, FileName], C =.. [_, _, Message],
	format(user_error, "~s: ~s: (~s)~n", [ErrorReason, FileName, Message]),
	halt.
err(Ex) :-
	format(user_error, "Exception unknown: ~@~n", [Ex]),
	halt.

% vim: set filetype=prolog:
