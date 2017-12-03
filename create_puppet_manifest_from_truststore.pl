#!/usr/bin/perl -w

use strict;
use Getopt::Long;

my $TEMPLATE = 'puppet_template.pp';

my $PARAMS = <<EOS;
    String \$truststore,
    String \$password,
    String \$trusts_dir,
EOS

my $BODY = <<EOS;

    ensure_resource('file', "\${trusts_dir}/\${cert_name}.pem", {
      'ensure'  => 'file',
      'content' => \$pem_file
    })

    java_ks {"\${name}::\${cert_name}":
        ensure      => latest,
        name        => \$aliasname,
        certificate => "\${trusts_dir}/\${cert_name}.pem",
        target      => \$truststore,
        password    => \$password,
        require     => File["\${trusts_dir}/\${cert_name}.pem"],
    }

}
EOS

my $truststore;
my $password;
my $alias_name;
my $owner;
my $issuer;
my $valid_from;
my $serial_nummer;
my $cert_name;
my $md5;
my $sha1;
my $sha256;

GetOptions (
  "truststore=s" => \$truststore,
  "password=s"   => \$password)
  or die("Error in command line arguments\n");

my $command = "keytool -list -keystore $truststore -storepass $password | awk -F, '{print \$1}' | grep -v 'Certificate fingerprint' | grep -v '^Keystore' | grep -v 'Your keystore contains' | egrep -v '^\$'";

my @truststores = `$command`;
chomp(@truststores);

foreach my $t(@truststores) {

  my $pem = `keytool -exportcert -alias '$t' -storepass $password -keystore $truststore -rfc`;
  chomp($pem);
  $pem =~ s/\r//g;
  my @trust = `keytool -list -v -keystore $truststore -storepass $password -alias '$t'`;
  chomp(@trust);
  foreach my $tr(@trust) {
    if ($tr =~ /^Alias name:/) {
      $tr =~ s/Alias name\:\s//;
      $alias_name = $tr;
    } elsif ($tr =~ /^Owner/) {
      $owner = $tr;
      $tr =~ m/Owner: CN=(.*?),\s\S{1,2}(.*)\s+/;
      if (! $1) {
        next;
      }
      $cert_name = $1;
      $cert_name =~ s/\s+|\.|-/_/g if $1;
      $cert_name =~ s/\*/star/g;
      $cert_name =~ s/_+/_/g;
      $cert_name = lc $cert_name;
    } elsif ($tr =~ /^Issuer/) {
      $issuer = $tr;
    } elsif ($tr =~ /^Serial number/) {
      $serial_nummer = $tr;
    } elsif ($tr =~ /^Valid from:/) {
      $valid_from = $tr;
    } elsif ($tr =~ /^\s+MD5:/) {
      $md5 = $tr;
    } elsif ($tr =~ /^\s+SHA1:/) {
      $sha1 = $tr;
    } elsif ($tr =~ /^\s+SHA256:/) {
      $sha256 = $tr;
    }
  }

  open(my $pp, ">", "${cert_name}.pp") or die "Could not open ${cert_name}: $!";
  print $pp "# $owner\n";
  print $pp "# $issuer\n";
  print $pp "# $serial_nummer\n" if $serial_nummer;
  print $pp "# $valid_from\n";
  print $pp "# Certificate fingerprints:\n";
  print $pp "# $md5\n";
  print $pp "# $sha1\n";
  print $pp "# $sha256\n";
  print $pp "define rtjp::certs::${cert_name} (\n";
  print $pp $PARAMS;
  if ($alias_name =~ /\*/) {
    print $pp "    String \$aliasname = '$alias_name'\n) {\n\n";
  } else {
    print $pp "    String \$aliasname = '${cert_name}'\n) {\n\n"; }
  print $pp "    \$cert_name = '${cert_name}'\n\n";
  print $pp '    $pem_file = @(END)' . "\n";
  print $pp "$pem\n";
  print $pp "    END\n";
  print $pp "$BODY\n";
  close $pp;

}


