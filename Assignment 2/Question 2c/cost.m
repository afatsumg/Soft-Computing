function j = cost(x)

global kd ke betha alfa

kd = x(1);
ke = x(2);
betha = x(3);
alfa = x(4);
sim('genetic.slx');
j = perf.Data(end);
