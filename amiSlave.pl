#!/usr/bin/perl

# EC2 slave management script
# Andrew Melo <andrew.m.melo@vanderbilt.edu>

# Keep the heathens out!
use strict;   # Glory!
use warnings; # Hallelujah!

# imports
use Getopt::Long;
use MIME::Base64 qw( encode_base64 );

# get the command line
my ($start, $stop, $status,
    $ami, $amk, $proxyhost,
	$startupTarball,
	$targetPool);
$ami = 'ami-42e8022b';
$amk = 'aki-9800e5f1';

my $result = GetOptions("start"            => \$start,
						"stop"             => \$stop,
						"status"           => \$status,
						"ami=s"            => \$ami,
						"amk=s"            => \$amk,
						"proxyHostUrl=s"      => \$proxyhost,
						"startupTarball=s" => \$startupTarball,
						"targetPool=s"     => \$targetPool);

if ( (not $start) &&
	 (not $stop)  &&
	 (not $status) ) {
	die "You must use the -start -stop or -status options\n";
}

if ($start) {
	if ((not $ami) || (not $amk)) {
		die "You must provide --ami and --amk to tell what to run\n";
	}
	if (not $startupTarball) {
		$startupTarball = 'http://vpac00.phy.vanderbilt.edu/~meloam/sandbox.tar';
	}
	if (not $targetPool) {
		$targetPool = 'se2.accre.vanderbilt.edu'
	}
	if (not $proxyhost) {
		die "You need to provide a proxyhost for conditions and CVMFS\n".
		    "otherwise, there will be a LOT of external traffic. \n\n".
			"This bootstrap script automagically starts a proxy, so you need to start\n".
			"one slave then provide the INTERNAL address here\n".
			"Format is http://<host>:<port> and semicolon separated\n".
			"By default, the port is 8213\n\n\n".
			"If you don't care, or this is your first host, provide NOPROXY here\n";
	}

	if (not $ENV{X509_USER_PROXY}) {
		die "You need to have an environment variable named X509_USER_PROXY\n".
		    "pointed to the user proxy this instance will use";
	}
	open my $fh, '<', $ENV{X509_USER_PROXY} or die "error opening $ENV{X509_USER_PROXY}: $!";
	my $proxy = do { local $/; <$fh> };
	my $amiContext  = qq{
#!/bin/bash

echo Done > /tmp/done
echo `ifconfig` >> /tmp/done
cd

cat <<"PROXY" > proxy.cert
$proxy
PROXY
export X509_USER_PROXY=$HOME/proxy.cert
export CMS_CERNVMPOOL=$targetPool
export CMS_CERNVM_PROXY_HOST=$proxyhost
curl -o sandbox.tar $startupTarball 2>&1 >> /tmp/done
tar -xvf sandbox.tar 1>&1 >> /tmp/done
cd Condor_glidein
./bootstrapEC2.sh
exit

[cernvm]
organisations = cms,grid
repositories = cms,grid
users = cms:cms:12345678
shell = /bin/bash
services = ntpd
environment = CMS_SITECONFIG=EC2,CMS_ROOT=/opt/cms,CMSCERNVM_PROXY_HOST=$proxyhost
};

	if ($proxyhost ne 'NOPROXY') {
		$amiContext = $amiContext . "\nproxy=$proxyhost;DIRECT";
	}

	print "Using the following as our amiContext script:\n";
	print $amiContext . "\n";
	my $encodedContext = MIME::Base64::encode_base64($amiContext, '');
	system("ec2-run-instances", $ami, "--kernel", $amk, "-d", $amiContext, "-k",
		   "melo-mbp2", "-t", "m1.large");
}


#system('ec2-run-instances ami-41a84728 --kernel aki-9b00e5f2 -k melo-mbp2 ' );
