#!/usr/bin/perl

foreach $x (1 .. 100) {
	system('qsub qsub-1-core-1-hour.sh');
}
