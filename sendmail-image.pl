
use Email::MIME;


sub sendmail_an_image {

  my ($from, $to, $imagefile) = @_;  # passing by value; everything will be local here
  # note: $imagefile is a file name expected in the current working directory
  
  # get binary file contents into a scalar (third arg is file size - a neat trick)
  # this works on Unix/Linux as binary - have to do something special for Windows
  open (FH,"$imagefile"); # scope of FH is global - an irritating quirk
  read (FH,my $buffer,-s "$imagefile"); # number of bytes to read is just the file size
  close FH;
 
  # multipart message definition - create the two message parts to start with
  # and add them to the actual message later
  
  my @parts = ( 
    Email::MIME->create(
        attributes => { # this is the part that contains the file attachment
            filename     => "$imagefile",
            content_type => "application/octet-stream",
            encoding     => "base64",
            name         => "imagepart",    # name of the image part of the email
            file         => "$imagefile",
            Path         => "$imagefile",
        },
        body => $buffer,  # bang in the binary image - will be encoded base64 for you
        ), # end of MIME-create for first part (file)
    Email::MIME->create( # this is the part that contains a trivial text section
        attributes => {
            content_type => "text/plain",
            encoding     => "quoted-printable",
            disposition  => "attachment",
            charset      => "US-ASCII",
            name         => "textpart",    # name of the text part of the email
        },
        body_str => "Hello there!",
        ), # end of MIME-create for second part (text)
    ); # end of definition of both message parts in one operation

  # now, create the actual mail message object that will hold the two parts
  my $email = Email::MIME->create(
  header_str => [
      From => $from,
      To => $to,
  ],
  parts      => [ @parts ],
  ); # end of mail message object creation

  # diagnostic: this will print out the entire mail message
  print $email->as_string;

  # now you are ready to send the email message

  open(MAIL, "|/usr/lib/sendmail -v -t"); # scope of MAIL filehandle is global, also
  print MAIL $email->as_string;
  close(MAIL);

} # end of sendmail_an_image subroutine

