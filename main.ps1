# Load PresentationFramework assembly for WPF support
Add-Type -AssemblyName PresentationFramework

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
    # Create the main window
    $window = New-Object System.Windows.Window
    $window.Title = "Bulk Uninstall Programs"
    $window.Width = 600
    $window.Height = 400

    # Create a ListBox to show installed programs
    $listBox = New-Object System.Windows.Controls.ListBox
    $listBox.Width = 580
    $listBox.Height = 300
    $window.Content = $listBox

    # Populate ListBox with installed programs
    Get-InstalledPrograms | ForEach-Object {
        $listBox.Items.Add($_.Name)
    }

    # Create a button to uninstall selected programs
    $uninstallButton = New-Object System.Windows.Controls.Button
    $uninstallButton.Content = "Uninstall Selected"
    $uninstallButton.Add_Click({
        $selectedItems = $listBox.SelectedItems
        foreach ($item in $selectedItems) {
            $programId = (Get-InstalledPrograms | Where-Object { $_.Name -eq $item }).IdentifyingNumber
            Uninstall-Program -programId $programId
        }
    })

    # Add the button to the window
    $stackPanel = New-Object System.Windows.Controls.StackPanel
    $stackPanel.Children.Add($listBox)
    $stackPanel.Children.Add($uninstallButton)
    $window.Content = $stackPanel

    # Show the window
    $window.ShowDialog() | Out-Null
}

# Show the GUI
Show-UninstallGUI
