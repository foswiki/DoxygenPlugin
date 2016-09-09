#!/usr/bin/perl
use Digest::MD5 qw(md5_hex);
#$str = "@ sglmsn::MSNEvent::RX_TIMERX_TIME";

sub getEnumAnchor {
    use Digest::MD5 qw(md5_hex);
    my ($enumType, $enumMember) = @_;
    die("getEnumAnchor called with undefined enumType")
        unless(defined($enumType));
    # According to Doxygen memberdef.cpp:
    # actually the method name is now included twice, which is silly,
    # but we keep it this way for backward compatibility.
    $enumType =~ s/(.*::(.*))/\1\2/;
    my $enumTypeAnchor = "a" . md5_hex($enumType);
    my $rv = "g" . $enumTypeAnchor;
    print "getEnumAnchor rv 1 = $rv\n";
    if (defined($enumMember)) {
        my $scope = $enumType;
        $scope =~ s/(.*)::.*/\1/;
        print "scope: $scope\n";
        my $enumName = $enumMember;
        $enumName =~ s/.*:://;
        print "enumName: $enumName\n";
        my $membName = "\@ $scope::$enumName$enumName";
        print "membName: $membName\n";
        my $enumMembAnchor = "a" . md5_hex($membName);
        $rv = "g" . $rv . $enumMembAnchor;
        print "getEnumAnchor rv 2 = $rv\n";
    }
    return $rv;
}

if ($#ARGV!=1) {
    print "usage: enumtest.pl enum-type enum-member\n";
    exit 1;
}
$typeName = $ARGV[0];
$membName = "\@ $ARGV[1]";
$name = $membName;
$name =~ s/^.*:://; # remove scope
#$pos = rindex($membName, "::");
#$scope = substr($membName, 0, $pos);
$anc = $membName . $name;
$membHash = md5_hex($anc);
$typeShort = $typeName;
$typeShort =~ s/^.*:://; # remove scope
$scopeanc = $typeName . $typeShort;
$scopeHash = md5_hex($scopeanc);

print("input: $membName\nname: $name\nscope: $scope\nanc: $anc\nscopeanc: $scopeanc\n");
print("member hash: $membHash\n");
print("scope hash:  $scopeHash\n");

my $typeAnc = getEnumAnchor($ARGV[0]);
my $membAnc = getEnumAnchor($ARGV[0], $ARGV[1]);
