%this is ping using wiring pi
:- dynamic start_time/1,stop_time/1,distval/2,handler1/3.
setup_pi:-
	pinMode(1,1),	%trigger
	pinMode(5,0).
	%dist.	%echo

dist(Distance):-
	%writeln('Calculating dist'),
	digitalWrite(1,1),
	sleep(0.000001),
	digitalWrite(1,0),
	rec_start,
	%writeln('GEtting start'),
	start_time(Start),
	%writeln('Getting stop'),
	stop_time(Stop),
	Elapsed is Stop - Start,
	writeln('Start and Stop':Start:' ':Stop),
	writeln('Elapsed is ':Elapsed),
	Distance is (Elapsed*34300)/2,
	writeln(Distance).

rec_start:-
	digitalRead(5,X),
	(X=:=0,
	 get_time(Start),
	 retractall(start_time(_)),
	 assert(start_time(Start)),
	 rec_start
	);
	(rec_stop).

rec_stop:-
	digitalRead(5,X),
	(X=:=1, 
	 get_time(Stop),
	 retractall(stop_time(_)),
	 assert(stop_time(Stop)),
	 rec_stop
	);
	nothing.


init_platform:-
	start_tartarus(localhost,50000),
	create_mobile_agent(distagent,(localhost,50000),handler1),
	set_token(1111),
	add_token(distagent,[1111]),
	retractall(distval(_,_)),
	setup_pi,
	dist(Distance),
	writeln('Distance is ':Distance),
	assert(distval(guid,Distance)),
	add_payload(distagent,[(distval,2)]),
	distval(_,New),
	writeln('This is asserted ':New),
	move_agent(distagent,('192.168.137.3',50000)).

handler1(guid,(localhost,Port),main):-
	writeln('the current port is ':Port),
	distval(guid,RemoteDist),
	writeln('The distance is ':RemoteDist).
