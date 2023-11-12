# Load necessary assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to list installed programs
function Get-InstalledPrograms {
    Get-WmiObject -Class Win32_Product | Select-Object Name, IdentifyingNumber
}

# Function to uninstall a program
function Uninstall-Program($programId) {
    $product = Get-WmiObject -Class Win32_Product | Where-Object { $_.IdentifyingNumber -eq $programId }
    $product.Uninstall()
}

# Function to create the GUI
function Show-UninstallGUI {
    # Create the main form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Bulk Uninstall Programs'
    $form.Size = New-Object System.Drawing.Size(800, 600)
    $form.StartPosition = 'CenterScreen'

    # Create a ListBox to show installed programs
    $listBox = New-Object System.Windows.Forms.ListBox
    $listBox.Location = New-Object System.Drawing.Point(10, 10)
    $listBox.Size = New-Object System.Drawing.Size(760, 480)

    # Populate ListBox with installed programs
    Get-InstalledPrograms | ForEach-Object {
        $listBox.Items.Add($_.Name)
    }

    # Create a button to uninstall selected programs
    $uninstallButton = New-Object System.Windows.Forms.Button
    $uninstallButton.Location = New-Object System.Drawing.Point(650, 500)
    $uninstallButton.Size = New-Object System.Drawing.Size(120, 30)
    $uninstallButton.Text = 'Uninstall Selected'
    $uninstallButton.Add_Click({
        $selectedItems = $listBox.SelectedItems
        foreach ($item in $selectedItems) {
            $programId = (Get-InstalledPrograms | Where-Object { $_.Name -eq $item }).IdentifyingNumber
            Uninstall-Program -programId $programId
        }
    })

    # Add controls to the form
    $form.Controls.Add($listBox)
    $form.Controls.Add($uninstallButton)

    # Show the form
    [System.Windows.Forms.Application]::Run($form)
}

# Show the GUI
Show-UninstallGUI
