#!/usr/bin/perl
# $Id$

use Image::Magick;
use Digest::MD5 qw(md5 md5_hex);
use File::Copy;

$debug=0;

# this variable stores if an equation has changed and thus the xslidy must be re-run
$eq_changed = 0;

# Make the .cache dir if not available
mkdir(".cache") if !(-e ".cache");


# Default configuration
$dpi = 300;
$res = 0.5;

$background="";
$transp=65535;


#   Command line option processing
while ($ARGV[0] =~ m/^-/) {
        $_ = shift(@ARGV);
	s/^--/-/;   	    	      # Allow GNU-style -- options
        if (m/^-dpi/) {                 # -dpi nnn
            $dpi = shift(@ARGV);
        } elsif (m/^-h/) {            # -help
	    &help();
	    exit(0);
        } elsif (m/^-r/) {            # -res nnn
            $res = shift(@ARGV);
        } elsif (m/^-d/) {            # -d
            $debug = 1;
        } elsif (m/^-v/) {            # -version
	    print("Version $version\n");
	    exit(0);
        }
    }


#
# Process all the images
#
open FILE,"tex.txt";
while($f=<FILE>) {
    chop($f);
    ($file,$pkg)=split(/ /,$f);
    $ext=substr($file,-3,3);    # determine the image extension
    $file = substr($file,0,-4); # remove the last 4 characters
    $pkg =~ s/[\[|\]]//g;

    print "$ext\n$file\n$pkg\n" if $debug;

    # read the tex-code
    $eq="";
    open(EQ,$file.".tex");
		while($s=<EQ>) {
		$eq="$eq$s";
    }
    close(EQ);

    # calculate the checksum of "pkg|tex-code"
    $checksum_eq=md5_hex($pkg.$eq.$ext);

    # read the checksum stored in the .sex file
    if(-e "$file.sex") {
		open(SEX,"$file.sex");
		($s,$b,$c)=split(/ /,<SEX>);
		close(SEX);
    }

    print "$checksum_eq vs. $c\n" if $debug;

    # go to next equation if they are equal
    next if($checksum_eq eq $c);

    # at this stage we have to regenerate an equation and thus XSLidy has to be re-run
    $eq_changed = 1;

    print "Generating $file\n";

    # check if the formula is readily available from .cache
    if(-e ".cache/$checksum_eq.$ext") {
	print ". copying cached version\n";
	copy(".cache/$checksum_eq.$ext","$file.$ext");
	copy(".cache/$checksum_eq.sex","$file.sex");
    } else { # render the latex formula
	$i=0;
	if($eq =~ /^\s*\\\[/) {
	    $i=index($eq,"\\\[")+2;
	} elsif($eq =~ /^\s*\\begin{displaymath}/) {
	    $i=index($eq,"\\begin{displaymath}")+19;
	} elsif($eq =~ /^\s*\\begin{equation}/) {
	    $i=index($eq,"\\begin{equation}")+16;
#	} elsif($eq =~ /\\begin{eqnarray\*}/) {
#	    $i=index($eq,"\\begin{eqnarray*}")+17;
#	} elsif($eq =~ /\\begin{align}/) {
#	    $i=index($eq,"\\begin{align}")+13;
	}
	substr($eq,$i,0)="\\rule{1ex}{1ex}\\ ";

	open(TEX,"> textex.tex") || die "Could not open the file";
	print TEX "\\documentclass[fleqn]{article}\n\\pagestyle{empty}\n\\usepackage{$pkg}\n\\begin{document}\n";
	print TEX "$eq";
	print TEX "\\end{document}";
	close(TEX);

	# convert the formula to a pgm 8bit bw-image
	print ". latex\n";
#	&syscmd("latex -interaction=nonstopmode textex.tex &> textex.out");
	&syscmd("latex -interaction=nonstopmode textex.tex");
	print ". dvips\n";
	&syscmd("dvips -E textex -o");
#	&syscmd("dvips -E textex -o &> /dev/null");
	print ". ghostscript\n";
	&syscmd("gs -q -dSAFTER -dBATCH -dNOPAUSE  -dEPSCrop -r".int($dpi/$res)." -sOutputFile=textex.png -sDEVICE=pngalpha textex.ps");

	$image = Image::Magick->new;
	$image->Read("textex.png");

	# Re-scale the image (aliasing effect to make the image appear nicer on firefox)
	($width, $height) = $image->Get('width','height');
	$image->Resize(width=>$res*$width,height=>$res*$height,filter=>'cubic');
	($width, $height) = $image->Get('width','height');

	# Crop the left margin of the image
	print ". crop the left margin\n";
	$x1=-1;
	for($x=0;$x<$width;$x++) {
	    for($y=0;$y<$height;$y++) {
		($r,$g,$b,$alpha)=split(/,/,$image->Get("pixel[$x,$y]"));
		print "$x/$y: $r,$g,$b,$alpha\n" if $debug;
		if($alpha ne 65535) {
		    $x1=max($x-1,0);
		    last;
		}
	    }
	    last if($x1>=0);
	}
	$image->Crop(width=>($width-$x1),height=>$height,x=>$x1,y=>0);
	$image->Set(page => '+0+0');
	($width, $height) = $image->Get('width','height');

	print "H:$height x W:$width\n" if $debug;

	# Check the baseline and height of 1ex size rulebox
	#   start from bottom and skip until $black -> baseline
	$x=1;
	for($y=$height;$y>=0;$y--) {
	    ($r,$g,$b,$alpha)=split(/,/,$image->Get("pixel[$x,$y]"));
	    if($debug) {
		$image->Set("pixel[$x,$y]"=>'green');
		print "$x/$y: $r,$g,$b,$alpha\n";
	    }
	    last if($alpha ne $transp);
	}
	$baseline=$y-1;

	for(;$y>=0;$y--) {
	    ($r,$g,$b,$alpha)=split(/,/,$image->Get("pixel[$x,$y]"));
	    if($debug) {
		$image->Set("pixel[$x,$y]"=>'white');
		print "$x/$y: $r,$g,$b,$alpha\n";
	    }
	    last if($alpha eq $transp);
	}
	$y++;
	$ex=$baseline-$y;
	print "Baseline:$baseline; Ex:$ex\n" if $debug;

	# Find the right end of the rule-box
	$x=1;
	$y=$baseline-$ex/2;
	do {
	    if($debug) {
		$image->Set("pixel[$x,$y]"=>'red');
		print "$x: $r,$g,$b,$alpha\n";
	    }
	    $x++;
	    ($r,$g,$b,$alpha)=split(/,/,$image->Get("pixel[$x,$y]"));
	} while($alpha ne $transp);
	print "Rulebox: x=$x\n" if $debug;

	# Crop/remove the rulebox
	$image->Crop(width=>$width-$x,height=>$height,x=>$x,y=>0);
	$image->Set(page => '+0+0');
	($width, $height) = $image->Get('width','height');

	# Get the boundingbox of the remaining equation
	print ". final cropping\n";
	($x1,$x2,$y1,$y2)=bbox($image);
	print "bbox: $x1 $x2 $y1 $y2\n" if $debug;
	$image->Crop(width=>($x2-$x1),height=>($y2-$y1),x=>$x1,y=>$y1);
	$image->Set(page => '+0+0');
	($width, $height) = $image->Get('width','height');

	# convert it to the target format (default gif)
	if($ext eq 'gif') {
	    # Before we write the gif image the half transparent black pixels have to be
            # replaced by gray values, this is due to only 1-bit alpha channel in gif
	    print ". manual alpha blending\n";
	    for($x=0;$x<$width;$x++) {
		for($y=0;$y<$height;$y++) {
		    $p=$image->Get("pixel[$x,$y]");
		    if($p ne '0,0,0,65535') {
			($r,$g,$b,$alpha)=split(/,/,$p);
			$a=$alpha/65535;
			$r=$r+65535*$a;
			$g=$g+65535*$a;
			$b=$b+65535*$a;
			$image->Set("pixel[$x,$y]"=>"$r,$g,$b,0");
		    }
		}
	    }
	    $image->Write("textex.gif");
	} elsif($ext eq 'png') {
	    $image->Write("textex.png");
	} else {
	    die "Unknown graphics extension\n";
	}

	undef $image;
	copy("textex.$ext","$file.$ext");

	open(SEX,"> $file.sex") || die "Could not open the file";
	printf SEX "%.2f -%.2f %s",$height/$ex,($height-($baseline-$y1))/$ex,$checksum_eq;
	close(SEX);

        # save a copy in the .cache
	copy("textex.$ext",".cache/$checksum_eq.$ext");
	copy("$file.sex",".cache/$checksum_eq.sex");
    }
}

close(FILE);

if(!$debug) {
    unlink 'textex.aux','textex.dvi','textex.log',"textex.$ext";
    unlink 'textex.out','textex.ps','textex.tex','textex.png';
}

exit($eq_changed);


########################################################################


sub syscmd {
    local ($cmd) = @_;

    print(STDERR "$cmd\n");
    system($cmd) == 0 || die("Error processing command:\n\t$cmd\n\t");
}


#	Print help text
sub help {
    	print <<"EOD"
usage: formulatex.pl [ options ]
    Options:
        -dpi n          Set rendering dots per inch to n (default 300)
        -help           Print this message
        -res n          Set oversampling ratio, smaller = finer (default 0.5)
        -version        Print version number
FormuLaTeX is part of the xslidy project (http://dret.net/projects/xslidy).
EOD
;
}


sub bbox {
    my $img=shift(@_);

    ($width, $height) = $img->Get('width','height');

    # first find the left margin
    $x1=-1;
    for($x=0;$x<$width;$x++) {
	for($y=0;$y<$height;$y++) {
	    $p=$image->Get("pixel[$x,$y]");
	    if($p ne '0,0,0,65535') {
		$x1=max($x-1,0);
		last;
	    }
	}
	last if($x1>=0);
    }

    # then find the top margin
    $y1=-1;
    for($y=0;$y<$height;$y++) {
	for($x=$x1;$x<$width;$x++) {
	    $p=$image->Get("pixel[$x,$y]");
	    if($p ne '0,0,0,65535') {
		$y1=max($y-1,0);
		last;
	    }
	}
	last if($y1>=0);
    }

    # then find the bottom margin
    $y2=-1;
    for($y=$height-1;$y>=0;$y--) {
	for($x=$x1;$x<$width;$x++) {
	    $p=$image->Get("pixel[$x,$y]");
	    if($p ne '0,0,0,65535') {
		$y2=min($y+1,$height);
		last;
	    }
	}
	last if($y2>=0);
    }
    
    # and finally the right margin
    $x2=-1;
    for($x=$width-1;$x>=0;$x--) {
	for($y=$y1;$y<$y2;$y++) {
	    $p=$image->Get("pixel[$x,$y]");
	    if($p ne '0,0,0,65535') {
		$x2=min($x+1,$width);
		last;
	    }
	}
	last if($x2>=0);
    }
    return($x1,$x2,$y1,$y2);
}


sub min {
    my ($a,$b) = @_;
    return ($a < $b) ? ($a) : ($b);
}

sub max {
    my ($a,$b) = @_;
    return ($a > $b) ? ($a) : ($b);
}
