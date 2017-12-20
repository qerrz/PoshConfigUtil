#
# HelpFunctions.ps1
#

function Hide-Console {
	if ($HideConsole -eq $True) {
		Add-Type -Name Window -Namespace Console -MemberDefinition '[DllImport("Kernel32.dll")]public static extern IntPtr GetConsoleWindow();[DllImport("user32.dll")]public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);'
		$consolePtr = [Console.Window]::GetConsoleWindow()
		[Console.Window]::ShowWindow($consolePtr, 0)
	}
else{
}
}