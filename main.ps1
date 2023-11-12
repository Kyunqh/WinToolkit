# Import necessary assemblies for Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Function to list installed programs (modify as needed for your system)
function Get-InstalledPrograms {
    # Example: Query the registry or use a suitable method to list programs
    Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
        Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
        Where-Object { $_.DisplayName -ne $null }
}

# Function to uninstall a program (modify as needed for your system)
function Uninstall-Program($programName) {
    # Example: Use a suitable method to uninstall programs, such as winget, msiexec, etc.
    Start-Process "msiexec.exe" -arg "/x $programName /quiet" -Wait
}

# Create and display the UI
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Bulk Uninstall Programs'
$form.Size = New-Object System.Drawing.Size(800, 600)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 10)
$label.Size = New-Object System.Drawing.Size(280, 20)
$label.Text = 'Select a program to uninstall:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10, 40)
$listBox.Size = New-Object System.Drawing.Size(760, 400)
$form.Controls.Add($listBox)

$uninstallButton = New-Object System.Windows.Forms.Button
$uninstallButton.Location = New-Object System.Drawing.Point(10, 450)
$uninstallButton.Size = New-Object System.Drawing.Size(100, 30)
$uninstallButton.Text = 'Uninstall'
$uninstallButton.Add_Click({
    $selectedItem = $listBox.SelectedItem
    Uninstall-Program -programName $selectedItem
})
$form.Controls.Add($uninstallButton)

# Populate the list box with installed programs
Get-InstalledPrograms | ForEach-Object {
    $listBox.Items.Add($_.DisplayName)
}

# Show the form
$form.ShowDialog() | Out-Null
