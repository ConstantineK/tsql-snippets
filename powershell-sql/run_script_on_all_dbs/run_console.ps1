# coding a simple menu interface to run the powershell scripts
# simple example I am adapting from http://mspowershell.blogspot.co.uk/2009/02/cli-menu-in-powershell.html?m=1
param (
	$folder = "$home\Dropbox\github\tsql-snippets\powershell-sql\run_script_on_all_dbs\"
)



function Draw {
param (
		$items,
		$position,
		$title
	)	
	cls
	$foreground = $Host.UI.RawUI.ForegroundColor 
	$background = $Host.UI.RawUI.BackgroundColor
	
	$numItems = $items.length
	$sideWidth = $title.length + 3
	$menuwidth = ($sideWidth*2)+$title.length+2
	
	Write-Host "`t" -NoNewLine
    Write-Host ("*" * $menuwidth) 	-fore $foreground -back $background
    Write-Host "`t" -NoNewLine
    Write-Host "$("*" * $sidewidth) $title $("*" * $sidewidth)" 		-fore $foreground -back $background
    Write-Host "`t" -NoNewLine
    Write-Host ("*" * $menuwidth) 	-fore $foreground -back $background
    Write-Host ""
	for ($i=0;$i -lt $numItems;$i++)
	{
		Write-Host "`t" -NoNewline
		if($i -eq $position){
				Write-Host "$($i+1) $($items[$i])" -fore $background -back $foreground
	        } else {
	            Write-Host "$($i+1) $($items[$i])" -fore $foreground -back $background
	        }
		
	}
	

	# if you pass debug as a param it will show the following
	Write-Debug "Title: $title"
	Write-Debug "Length: $($title.length)"
	Write-Debug "Menu Width: $menuwidth"
}

function Menu {
	param (
		[array]$items,
		$title = "Select Items"
	)
	$keycode = 0
	$pos = 0
	Draw $items $pos $title
	
	while ($keycode -ne 13)
	{
		$press = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
		$keycode = $press.virtualkeycode
		Write-Host "$($press.character)" -NoNewline
		If ($keycode -eq 38) {$pos--}
        If ($keycode -eq 40) {$pos++}
		if ($pos -lt 0) {$pos = 0}
        if ($pos -ge $Items.length) {$pos = $Items.length -1}
		
        Draw $items $pos $title
	}	    
    Write-Output $($items[$pos])
}
$selection = Menu $(gci $folder -Filter "*.ps1") "Make Your Choice"
Write-Host "Running $selection"
$exec = '.\'+$selection
iex $exec