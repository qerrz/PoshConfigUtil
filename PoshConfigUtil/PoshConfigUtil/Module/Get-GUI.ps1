#
# Get_GUI.ps1
#

function Setup-GUI {
$Form1 = New-Object system.Windows.Forms.Form
$Form1.Text = "Informacje o kliencie CMMS"
$Form1.AutoScroll = $True
$Form1.Width = 570
$Form1.Height = 350
$Form1.MinimizeBox = $True
$Form1.MaximizeBox = $False
$Form1.WindowState = "Normal"
$Form1.FormBorderStyle = "FixedSingle"
$Form1.SizeGripStyle = "Hide"
$Form1.ShowInTaskbar = $True
$Font = New-Object System.Drawing.Font("Calibri", 12)
$Form1.Font = $Font

$Form2 = New-Object System.Windows.Forms.Form
$Form2.Text = "List of config files to modify"
$Form2.Width = 450
$Form2.Height = 220
$Form2.MinimizeBox = $True
$Form2.MaximizeBox = $False
$Form2.WindowState = "Normal"
$Form2.FormBorderStyle = "FixedSingle"
$Form2.SizeGripStyle = "Hide"
$Form2.ShowInTaskbar = $False
$Form2.Font = $Font

$Form3 = New-Object System.Windows.Forms.Form
$Form3.Text = "Database operations"
$Form3.Width = 690
$Form3.Height = 360
$Form3.MinimizeBox = $True
$Form3.MaximizeBox = $False
$Form3.WindowState = "Normal"
$Form3.FormBorderStyle = "FixedSingle"
$Form3.SizeGripStyle = "Hide"
$Form3.ShowInTaskbar = $False
$Form3.Font = $Font

$Form4 = New-Object System.Windows.Forms.Form
$Form4.Text = "Build-an-Endpoint Workshop"
$Form4.Width = 1050
$Form4.Height = 250
$Form4.MinimizeBox = $True
$Form4.MaximizeBox = $False
$Form4.WindowState = "Normal"
$Form4.FormBorderStyle = "FixedSingle"
$Form4.SizeGripStyle = "Hide"
$Form4.ShowInTaskbar = $False
$Form4.Font = $Font

$Form5 = New-Object System.Windows.Forms.Form
$Form5.Text = "Choose an instance"
$Form5.Width = 520
$Form5.Height = 110
$Form5.MinimizeBox = $False
$Form5.MaximizeBox = $False
$Form5.WindowState = "Normal"
$Form5.FormBorderStyle = "FixedSingle"
$Form5.SizeGripStyle = "Hide"
$Form5.ShowInTaskbar = $False
$Form5.Font = $Font

$Form1TextBox1 = New-Object System.Windows.Forms.TextBox
$Form1TextBox1.ReadOnly = $true
$Form1TextBox1.BorderStyle = 2
$Form1TextBox1.TabStop = $false
$Form1TextBox1.TabIndex = 1
$Form1TextBox1.Text = $DBAddress
$Form1TextBox1.Location = New-Object System.Drawing.Point(100, 105)
$Form1TextBox1.Size = New-Object System.Drawing.Size(180, 12)

$Form1TextBox2 = New-Object System.Windows.Forms.TextBox
$Form1TextBox2.ReadOnly = $true
$Form1TextBox2.BorderStyle = 2
$Form1TextBox2.TabStop = $false
$Form1TextBox2.TabIndex = 2
$Form1TextBox2.Text = $DBName
$Form1TextBox2.Location = New-Object System.Drawing.Point(100, 135)
$Form1TextBox2.Size = New-Object System.Drawing.Size(180, 12)

$Form1TextBox3 = New-Object System.Windows.Forms.TextBox
$Form1TextBox3.ReadOnly = $true
$Form1TextBox3.BorderStyle = 2
$Form1TextBox3.TabStop = $false
$Form1TextBox3.TabIndex = 3
$Form1TextBox3.Text = $DBLogin
$Form1TextBox3.Location = New-Object System.Drawing.Point(100, 165)
$Form1TextBox3.Size = New-Object System.Drawing.Size(180, 12)

$Form1TextBox4 = New-Object System.Windows.Forms.TextBox
$Form1TextBox4.ReadOnly = $true
$Form1TextBox4.BorderStyle = 2
$Form1TextBox4.TabStop = $false
$Form1TextBox4.TabIndex = 4
$Form1TextBox4.Text = $DBPass
$Form1TextBox4.Location = New-Object System.Drawing.Point(100, 195)
$Form1TextBox4.Size = New-Object System.Drawing.Size(180, 12)

$Form1TextBox5 = New-Object System.Windows.Forms.TextBox
$Form1TextBox5.ReadOnly = $true
$Form1TextBox5.BorderStyle = 2
$Form1TextBox5.TabStop = $false
$Form1TextBox5.TabIndex = 5
$Form1TextBox5.Text = $ClientVersion
$Form1TextBox5.Location = New-Object System.Drawing.Point(100, 225)
$Form1TextBox5.Size = New-Object System.Drawing.Size(180, 12)

$Form3ListBox1 = New-Object System.Windows.Forms.Listbox
$Form3ListBox1.BorderStyle = 1
$Form3ListBox1.Location = New-Object System.Drawing.Point(700, 40)

$Form3ListBox2 = New-Object System.Windows.Forms.Listbox
$Form3ListBox2.BorderStyle = 1
$Form3ListBox2.Location = New-Object System.Drawing.Point(920, 40)

$Form3ListBox3 = New-Object System.Windows.Forms.ListBox
$Form3ListBox3.BorderStyle = 1
$Form3ListBox3.Location = New-Object System.Drawing.Point(1140, 40)

$Form4ListBox1 = New-Object System.Windows.Forms.ListBox
$Form4ListBox1.BorderStyle = 1
$Form4ListBox1.Location = New-Object System.Drawing.Point(50, 60)
$Form4ListBox1.Size = New-Object System.Drawing.Size(180, 100)

$Form4TextBox1 = New-Object System.Windows.Forms.TextBox
$Form4TextBox1.BorderStyle = 2
$Form4TextBox1.TabStop = $false
$Form4TextBox1.TabIndex = 1
$Form4TextBox1.Location = New-Object System.Drawing.Point(270, 60)
$Form4TextBox1.Size = New-Object System.Drawing.Size(60, 12)

$Form1Label1 = New-Object System.Windows.Forms.Label
$Form1Label1.Text = "App configs:"
$Form1Label1.Location = New-Object System.Drawing.Point(20, 78)
$Form1Label1.Size = New-Object System.Drawing.Size(300, 30)

$Form1Label2 = New-Object System.Windows.Forms.Label
$Form1Label2.Text = "DB Adr:"
$Form1Label2.Location = New-Object System.Drawing.Point(20, 108)
$Form1Label2.Size = New-Object System.Drawing.Size(200, 20)

$Form1Label3 = New-Object System.Windows.Forms.Label
$Form1Label3.Text = "DB Name:"
$Form1Label3.Location = New-Object System.Drawing.Point(20, 139)
$Form1Label3.Size = New-Object System.Drawing.Size(200, 20)

$Form1Label4 = New-Object System.Windows.Forms.Label
$Form1Label4.Text = "DB Login:"
$Form1Label4.Location = New-Object System.Drawing.Point(20, 169)
$Form1Label4.Size = New-Object System.Drawing.Size(200, 20)

$Form1Label5 = New-Object System.Windows.Forms.Label
$Form1Label5.Text = "DB Pwd:"
$Form1Label5.Location = New-Object System.Drawing.Point(20, 199)
$Form1Label5.Size = New-Object System.Drawing.Size(200, 20)

$Form1Label6 = New-Object System.Windows.Forms.Label
$Form1Label6.Text = "Version:"
$Form1Label6.Location = New-Object System.Drawing.Point(20, 228)
$Form1Label6.Size = New-Object System.Drawing.Size(200, 20)

$Form1Label7 = New-Object System.Windows.Forms.Label
$Form1Label7.Text = "scripted by mmendrygal@queris.pl"
$Form1Label7.Location = New-Object System.Drawing.Point(20, 270)
$Form1Label7.Size = New-Object System.Drawing.Size(400, 25)

$Form1Label8 = New-Object System.Windows.Forms.Label
$Form1Label8.Location = New-Object System.Drawing.Point(30,32)
$Form1Label8.Size = New-Object System.Drawing.Size(80,20)

$Form2Label1 = New-Object System.Windows.Forms.Label
$Form2Label1.Text = "Service Path: $ServiceConfig"
$Form2Label1.Location = New-Object System.Drawing.Point (20, 18)
$Form2Label1.Size = New-Object System.Drawing.Size(500, 20)

$Form2Label2 = New-Object System.Windows.Forms.Label
$Form2Label2.Text = "RestService Path: $RestConfig"
$Form2Label2.Location = New-Object System.Drawing.Point (20, 48)
$Form2Label2.Size = New-Object System.Drawing.Size(500, 20)

$Form2Label3 = New-Object System.Windows.Forms.Label
$Form2Label3.Text = "WebClient Path: $WebClientConfig"
$Form2Label3.Location = New-Object System.Drawing.Point (20, 78)
$Form2Label3.Size = New-Object System.Drawing.Size(500, 20)

$Form2Label4 = New-Object System.Windows.Forms.Label
$Form2Label4.Text = "Client Path: $ClientConfig"
$Form2Label4.Location = New-Object System.Drawing.Point (20, 109)
$Form2Label4.Size = New-Object System.Drawing.Size(500, 20)

$Form3Label1 = New-Object System.Windows.Forms.Label
$Form3Label1.Location = New-Object System.Drawing.Point (120, 10)
$Form3Label1.Size = New-Object System.Drawing.Size(500, 20)

$Form3Label2 = New-Object System.Windows.Forms.Label
$Form3Label2.Text = "These buttons perform operations in database to`nmodify paths in user settings from selected CMMS installation"
$Form3Label2.Location = New-Object System.Drawing.Point (230, 55)
$Form3Label2.Size = New-Object System.Drawing.Size(450, 50)

$Form3Label3 = New-Object System.Windows.Forms.Label
$Form3Label3.Location = New-Object System.Drawing.Point (700, 10)
$Form3Label3.Size = New-Object System.Drawing.Size(150, 20)

$Form3Label4 = New-Object System.Windows.Forms.Label
$Form3Label4.Location = New-Object System.Drawing.Point (920, 10)
$Form3Label4.Size = New-Object System.Drawing.Size(150, 20)

$Form3Label5 = New-Object System.Windows.Forms.Label
$Form3Label5.Text = "Clear UstawieniaBin for further processing"
$Form3Label5.Location = New-Object System.Drawing.Point (230, 125)
$Form3Label5.Size = New-Object System.Drawing.Size(450, 50)

$Form3Label6 = New-Object System.Windows.Forms.Label
$Form3Label6.Text = "Get the list of scripts applied to this database and`nsearch for missing ones"
$Form3Label6.Location = New-Object System.Drawing.Point (230, 175)
$Form3Label6.Size = New-Object System.Drawing.Size(450, 50)

$Form3Label7 = New-Object System.Windows.Forms.Label
$Form3Label7.Location = New-Object System.Drawing.Point (1140, 10)
$Form3Label7.Size = New-Object System.Drawing.Size(150, 20)

$Form3Label8 = New-Object System.Windows.Forms.Label
$Form3Label8.Location = New-Object System.Drawing.Point (700, 290)
$Form3Label8.Size = New-Object System.Drawing.Size(150, 20)

$Form3Label9 = New-Object System.Windows.Forms.Label
$Form3Label9.Location = New-Object System.Drawing.Point (920, 290)
$Form3Label9.Size = New-Object System.Drawing.Size(150, 20)

$Form3Label10 = New-Object System.Windows.Forms.Label
$Form3Label10.Location = New-Object System.Drawing.Point (1140, 290)
$Form3Label10.Size = New-Object System.Drawing.Size(150, 20)

$Form4Label1 = New-Object System.Windows.Forms.Label
$Form4Label1.Location = New-Object System.Drawing.Point (50, 25)
$Form4Label1.Size = New-Object System.Drawing.Size(80 , 35)
$Form4Label1.Text = "Choose IP"

$Form4Label2 = New-Object System.Windows.Forms.Label
$Form4Label2.Location = New-Object System.Drawing.Point (265, 25)
$Form4Label2.Size = New-Object System.Drawing.Size(80, 35)
$Form4Label2.Text = "Type port"

$Form4Label3 = New-Object System.Windows.Forms.Label
$Form4Label3.Location = New-Object System.Drawing.Point (375, 25)
$Form4Label3.Size = New-Object System.Drawing.Size(400, 35)
$Form4Label3.Text = "Your endpoint address will look like this:"

$Form4Label4 = New-Object System.Windows.Forms.Label
$Form4Label4.Location = New-Object System.Drawing.Point (375, 55)
$Form4Label4.Size = New-Object System.Drawing.Size(600 , 35)

$Form4Label5 = New-Object System.Windows.Forms.Label
$Form4Label5.Location = New-Object System.Drawing.Point (375, 95)
$Form4Label5.Size = New-Object System.Drawing.Size(600 , 35)
$Form4Label5.Text = "Current endpoint address in config:"

$Form4Label6 = New-Object System.Windows.Forms.Label
$Form4Label6.Location = New-Object System.Drawing.Point (375, 125)
$Form4Label6.Size = New-Object System.Drawing.Size(600 , 35)

$Form1Button1 = New-Object System.Windows.Forms.Button
$Form1Button1.Text = "Edit`nconn. data"
$Form1Button1.Location = New-Object System.Drawing.Point(320, 80)
$Form1Button1.Size = New-Object System.Drawing.Size(100, 50)

$Form1Button2 = New-Object System.Windows.Forms.Button
$Form1Button2.Text = "Accept`nand save"
$Form1Button2.Location = New-Object System.Drawing.Point(320, 135)
$Form1Button2.Size = New-Object System.Drawing.Size(100, 50)
$Form1Button2.Enabled = $false

$Form1Button3 = New-Object System.Windows.Forms.Button
$Form1Button3.Text = "List loaded paths"
$Form1Button3.Location = New-Object System.Drawing.Point(320, 190)
$Form1Button3.Size = New-Object System.Drawing.Size(100, 50)

$Form1Button4 = New-Object System.Windows.Forms.Button
$Form1Button4.Text = "Run app"
$Form1Button4.Location = New-Object System.Drawing.Point(320, 245)
$Form1Button4.Size = New-Object System.Drawing.Size(100, 50)

$Form1Button5 = New-Object System.Windows.Forms.Button
$Form1Button5.Text = "DB Operations"
$Form1Button5.Location = New-Object System.Drawing.Point(435, 80)
$Form1Button5.Size = New-Object System.Drawing.Size(100, 50)

$Form1Button6 = New-Object System.Windows.Forms.Button
$Form1Button6.Text = "IIS Operations"
$Form1Button6.Location = New-Object System.Drawing.Point(435, 135)
$Form1Button6.Size = New-Object System.Drawing.Size(100, 50)
$Form1Button6.Enabled = $False

$Form1Button7 = New-Object System.Windows.Forms.Button
$Form1Button7.Text = "Modify endpoints"
$Form1Button7.Location = New-Object System.Drawing.Point(435, 190)
$Form1Button7.Size = New-Object System.Drawing.Size(100, 50)

$Form1Button8 = New-Object System.Windows.Forms.Button
$Form1Button8.Text = "Multichoose disabled"
$Form1Button8.Location = New-Object System.Drawing.Point(435, 15)
$Form1Button8.Size = New-Object System.Drawing.Size(100, 50)
$Form1Button8.Enabled = $False

$Form2Button1 = New-Object System.Windows.Forms.Button
$Form2Button1.Text = "OK"
$Form2Button1.Location = New-Object System.Drawing.Point(170, 142)
$Form2Button1.Size = New-Object System.Drawing.Size(100, 25)

$Form3Button1 = New-Object System.Windows.Forms.Button
$Form3Button1.Text = "Load User Settings"
$Form3Button1.Location = New-Object System.Drawing.Point (125, 50)
$Form3Button1.Size = New-Object System.Drawing.Size(100, 50)

$Form3Button2 = New-Object System.Windows.Forms.Button
$Form3Button2.Text = "Modify User Settings"
$Form3Button2.Location = New-Object System.Drawing.Point (20, 50)
$Form3Button2.Size = New-Object System.Drawing.Size(100, 50)

$Form3Button3 = New-Object System.Windows.Forms.Button
$Form3Button3.Text = "Clear BinSettings"
$Form3Button3.Location = New-Object System.Drawing.Point (20, 110)
$Form3Button3.Size = New-Object System.Drawing.Size(100, 50)

$Form3Button4 = New-Object System.Windows.Forms.Button
$Form3Button4.Text = "Load Scripts List"
$Form3Button4.Location = New-Object System.Drawing.Point (20, 170)
$Form3Button4.Size = New-Object System.Drawing.Size(100, 50)

$Form3Button5 = New-Object System.Windows.Forms.Button
$Form3Button5.Text = "Compare"
$Form3Button5.Location = New-Object System.Drawing.Point (125, 170)
$Form3Button5.Size = New-Object System.Drawing.Size(100, 50)
$Form3Button5.Enabled = $False

$Form4Button1 = New-Object System.Windows.Forms.Button
$Form4Button1.Text = "Save and set endpoints"
$Form4Button1.Location = New-Object System.Drawing.Point (780, 160)
$Form4Button1.Size = New-Object System.Drawing.Size(220,30)

$Form1ComboBox1 = New-Object System.Windows.Forms.Combobox
$Form1ComboBox1.Location = New-Object System.Drawing.Point (120, 30)
$Form1ComboBox1.Size = New-Object System.Drawing.Size(300,30)
$Form1ComboBox1.Enabled = $False
}

function Init-GUI {
###################### INICJALIZACJA GUI 
######################  TextBoxy ###################### 
$Form1.Controls.Add($Form1TextBox1)
$Form1.Controls.Add($Form1TextBox2)
$Form1.Controls.Add($Form1TextBox3)
$Form1.Controls.Add($Form1TextBox4)
$Form1.Controls.Add($Form1TextBox5)
$Form4.Controls.Add($Form4TextBox1)
######################  ListBoxy ###################### 
$Form3.Controls.Add($Form3ListBox1)
$Form3.Controls.Add($Form3ListBox2)
$Form3.Controls.Add($Form3ListBox3)
$Form4.Controls.Add($Form4ListBox1)
######################  Buttony ###################### 
$Form1.Controls.Add($Form1Button1)
$Form1.Controls.Add($Form1Button2)
$Form1.Controls.Add($Form1Button3)
$Form1.Controls.Add($Form1Button4)
$Form1.Controls.Add($Form1Button5)
$Form1.Controls.Add($Form1Button6)
$Form1.Controls.Add($Form1Button7)
$Form1.Controls.Add($Form1Button8)
$Form2.Controls.Add($Form2Button1)
$Form3.Controls.Add($Form3Button1)
$Form3.Controls.Add($Form3Button2)
$Form3.Controls.Add($Form3Button3)
$Form3.Controls.Add($Form3Button4)
$Form4.Controls.Add($Form4Button1)
#$Form3.Controls.add($Form3Button5)   <---- Obsolete for now
######################  Labele ###################### 
$Form1.Controls.Add($Form1Label1)
$Form1.Controls.Add($Form1Label2)
$Form1.Controls.Add($Form1Label3)
$Form1.Controls.Add($Form1Label4)
$Form1.Controls.Add($Form1Label5)
$Form1.Controls.Add($Form1Label6)
$Form1.Controls.Add($Form1Label7)
$Form1.Controls.Add($Form1Label8)
$Form2.Controls.Add($Form2Label1)
$Form2.Controls.Add($Form2Label2)
$Form2.Controls.Add($Form2Label3)
$Form2.Controls.Add($Form2Label4)
$Form3.Controls.Add($Form3Label1)
$Form3.Controls.Add($Form3Label2)
$Form3.Controls.Add($Form3Label3)
$Form3.Controls.Add($Form3Label4)
$Form3.Controls.Add($Form3Label5)
$Form3.Controls.Add($Form3Label6)
$Form3.Controls.Add($Form3Label7)
$Form3.Controls.Add($Form3Label8)
$Form3.Controls.Add($Form3Label9)
$Form3.Controls.Add($Form3Label10)
$Form4.Controls.Add($Form4Label1)
$Form4.Controls.Add($Form4Label2)
$Form4.Controls.Add($Form4Label3)
$Form4.Controls.Add($Form4Label4)
$Form4.Controls.Add($Form4Label5)
$Form4.Controls.Add($Form4Label6)
######################  Comboboxy ###################### 
$Form1.Controls.Add($Form1ComboBox1)
$Form1.ShowDialog()
}