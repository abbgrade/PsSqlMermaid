#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe 'New-SqlMermaidDiagram' {

    BeforeAll {
        Import-Module $PSScriptRoot\..\Source\PsSqlMermaid.psd1 -Force -ErrorAction Stop
        Import-Module PsDac -ErrorAction Stop
    }

    BeforeDiscovery {
        [System.IO.FileInfo] $Script:DacPacFile = "$PsScriptRoot\sql-server-samples\samples\databases\wide-world-importers\wwi-ssdt\wwi-ssdt\bin\Debug\WideWorldImporters.dacpac"
        $Script:PsDockerMermaid = Import-Module PsDockerMermaid -PassThru -ErrorAction Continue
    }

    Context 'DacPac' -Skip:( -Not $Script:DacPacFile.Exists ) {

        BeforeAll {
            $Script:Model = Import-DacModel $Script:DacPacFile
        }

        It 'Creates a diagram' {
            [string] $diagram = $Script:Model | New-SqlMermaidDiagram -ErrorAction Stop

            $diagram | Should -BeLike 'erDiagram*'

            $Script:Model | Get-DacTable | ForEach-Object {
                $containsTable = $diagram.Contains( $_.Name.ToString() )
                $containsTable | Should -Be $true -Because $_.Name.ToString()
            }
        }

        Context 'Mermaid CLI' -Skip:( -Not $Script:PsDockerMermaid ) {

            It 'Creates a valid diagram' {
                $svg = $Script:Model | New-SqlMermaidDiagram | Invoke-MermaidCommand
                $svg | Should -Not -BeNullOrEmpty
            }
        }

    }
}
