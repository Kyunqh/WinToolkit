# Import necessary assemblies for Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Function to list installed programs using winget (adapt as needed)
function Get-InstalledPrograms {
    winget list | Select-Object -Skip 2 | ForEach-Object {
        $item = $_ -split '\s{2,}', 5
        [PSCustomObject]@{
            Name = $item[0]
            Id   = $item[1]
        }
    }
}

# Function to uninstall a program using winget (adapt as needed)
function Uninstall-Program($programId) {
    winget uninstall --id $programId --silent
}

# Create and display the UI
$form = New-Object System.Windows.Forms.Form
$form.Text = "Bulk Uninstall Programs"
$form.Size = New-Object System.Drawing.Size(800,600)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,10)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = "Select a program to uninstall:"
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(760,400)
$form.Controls.Add($listBox)

$uninstallButton = New-Object System.Windows.Forms.Button
$uninstallButton.Location = New-Object System.Drawing.Point(10,450)
$uninstallButton.Size = New-Object System.Drawing.Size(100,30)
$uninstallButton.Text = "Uninstall"
$uninstallButton.Add_Click({
    $selectedItem = $listBox.SelectedItem
    $programId = ($selectedItem -split '\s+', 2)[1]
    Uninstall-Program -programId $programId
})
$form.Controls.Add($uninstallButton)

# Populate the list box with installed programs
Get-InstalledPrograms | ForEach-Object {
    $listBox.Items.Add($_.Name + " " + $_.Id)
}

# Show the form
$form.ShowDialog() | Out-Null
