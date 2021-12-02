# sendmail-image
Subroutine to send a multi-part email via sendmail that includes text
and an image attachment. Uses Email::MIME

NOTE: As provided, this code prints out the entire email message so
that you can grab it and look at it. I doubt you'd want to do this
in a real application. To turn this off, comment out this line:

print $email->as_string;

This example code also invokes sendmail with the -v command line 
option, which prompts sendmail to dump out the entire conversation
with the mail server. This is handy for deveopment and debugging 
but, again, probably not something you want all the time. To calm
down sendmail and stop dumping the conversation details, just remove
the -v option.

Change this: open(MAIL, "|/usr/lib/sendmail -v -t");
to this: open(MAIL, "|/usr/lib/sendmail -t");
First push of this sequence: Wed Dec  1 20:47:01 EST 2021
