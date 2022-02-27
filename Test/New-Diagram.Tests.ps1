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
            $Script:Model = Import-DacModel -Path $Script:DacPacFile
        }

        It 'Creates a diagram' {
            [string] $diagram = $Script:Model | New-SqlMermaidDiagram -ErrorAction Stop

            # $diagram | Out-File 'er.mmd'

            $diagram | Should -BeLike 'erDiagram*'

            $Script:Model | Get-DacTable | ForEach-Object {
                $schema, $table = $_.Name.Parts
                $diagram | Should -Match $table
                $diagram | Should -Not -Match "\[$table\]"
            }
        }

        Context 'Mermaid CLI' -Skip:( -Not $Script:PsDockerMermaid ) {

            It 'Creates a valid diagram' {
                $svg = $Script:Model | New-SqlMermaidDiagram | Invoke-MermaidCommand

                # $svg | Out-File 'er.svg'

                $svg | Should -Not -BeNullOrEmpty
            }
        }

    }
}
