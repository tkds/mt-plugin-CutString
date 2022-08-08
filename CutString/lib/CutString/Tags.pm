package CutString::Tags;
use strict;

sub _hdlr_cutbefore {
  my ($text, $arg, $ctx) = @_;
  return $text if $arg eq '';

  $text = $1 if($text =~ m/$arg(.*)/);
  return $text;
}

sub _hdlr_cutnext {
  my ($text, $arg, $ctx) = @_;
  return $text if $arg eq '';

  $text = $1 if($text =~ m/(.*?)$arg/);
  return $text;
}

sub _hdlr_cutstring {
  my ($text, $arg, $ctx) = @_;
  return $text if $arg eq '';

	my $max_length = $arg*2;
	$text =~ s/\r|\n|\t//g;
	my @str = split(/<[^<>]+?>/,$text);
	my @tags = $text =~ m/<([^<>]+?)>/g;
	
	my $length = 0;
	my $str = '<p>';
	my $str_length;
	my $temp;
	
  for (my $i=0; $i<scalar(@tags); $i++ ) {
		if($str[$i] ne '') {
			$str_length = MT::I18N::length_text($str[$i]) * 2;
			if ($length > $max_length) {
				$str .= "<" . $tags[$i] . ">";
			} elsif ($max_length - $length - $str_length > 0) {
				$str .= $str[$i] . "<" . $tags[$i] . ">";
				$length += $str_length;
			} else {
				$temp = MT::I18N::substr_text($str[$i],0,int(($max_length - $length)/2)) . '...';
				$str .= $temp;
				$str .= "<" . $tags[$i] . ">";
				$length += MT::I18N::length_text($temp) + 50;
			}
		}
	}
	return $str;
}

sub _hdlr_cuttag {
	my ($text, $arg, $ctx) = @_;
	return $text if $arg eq '';
		
	my @tags = split(',',$arg);
	foreach (@tags) {
		$text =~ s/<\/?$_.*?>//igs;
	}
	return $text;
}

sub _hdlr_getstring {
  my ($text, $arg, $ctx) = @_;
  return $text if $arg eq '';
  return substr($text, 0, $arg);
}

1;