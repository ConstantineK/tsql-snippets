# coding a simple menu interface to run the powershell scripts
# simple example I am adapting from http://mspowershell.blogspot.co.uk/2009/02/cli-menu-in-powershell.html?m=1

function Draw {
	param (
		$items,
		$position,
		$title
	)
	$foreground = $Host.UI.RawUI.ForegroundColor 
	$background = $Host.UI.RawUI.BackgroundColor
	
	$menuWidth = $title.length + 10
	Write-Host "`t" -NoNewLine
    Write-Host ("*" * $menuwidth) 	-fore $foreground -back $background
    Write-Host "`t" -NoNewLine
    Write-Host "* $title *" 		-fore $foreground -back $background
    Write-Host "`t" -NoNewLine
    Write-Host ("*" * $menuwidth) 	-fore $foreground -back $background
    Write-Host ""
	
	$title
	# if you pass debug as a param it will show the following
	Write-Debug "Title: $title"
	Write-Debug "Length: $($title.length)"
	Write-Debug "Menu Width: $menuwidth"
}


draw(1,0,"Hello my lovelies")