# emailer script
param (
	$from,
	$to,
	$subject,
	$body,
	$smtpserver,
	$port,
	$password,
	$username = $from,
	$ssl = 0
	
)

if ($from -eq $null -or $to -eq $null -or $smtpserver -eq $null -or $password -eq $null -or $port -eq $null)
{
	Write-Host "Missing one of the parameters"
}
else {
	if ($from -notcontains '@' -or $to -notcontains '@'){
		Write-Host "$from or $to isn't an email address you dingus"
	}	
	$msg = new-object System.Net.Mail.MailMessage($from,$to)
	$msg.subject = $subject	
	$msg.body = $body
	$smtp = new-object System.Net.Mail.SmtpClient( $smtpserver , $port)
	$smtp.credentials = new-object System.Net.NetworkCredential($username,$password)
	if ($port -eq 587 -or $ssl -eq 1)
	{
		$smtp.enableSsl = $true
	}
	$smtp.send($msg)
	
}